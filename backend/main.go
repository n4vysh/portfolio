package main

import (
	"context"
	"errors"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"syscall"
	"time"

	"github.com/kelseyhightower/envconfig"
	"go.uber.org/zap"

	_ "main/docs"
)

// @title portfolio internal endpoints
// @version 1.0

// @license.name MIT License
// @license.url https://github.com/n4vysh/portfolio/blob/main/LICENSE.txt

// @host localhost:8081
// @BasePath /

type Server struct {
	name      string
	parameter *http.Server
	logger    *zap.Logger
}

type Env struct {
	Host         string `default:""`
	Port         int    `default:"8080"`
	InternalPort int    `envconfig:"INTERNAL_PORT" default:"8081"`
}

const (
	readTimeout     = 5 * time.Second
	writeTimeout    = 10 * time.Second
	shutdownTimeout = 5 * time.Second
)

func main() {
	logger, err := zap.NewProduction()
	if err != nil {
		log.Fatal(err)
	}
	defer logger.Sync() // nolint: errcheck, wsl

	var env Env
	err = envconfig.Process("portfolio", &env)
	if err != nil { // nolint: wsl
		logger.Fatal(err.Error())
	}

	cleanup := installExportPipeline(context.Background(), logger)
	defer cleanup()

	server := []*Server{
		{
			"public",
			&http.Server{
				Addr:         ":" + strconv.Itoa(env.Port),
				Handler:      publicRouter(logger, env.Host),
				ReadTimeout:  readTimeout,
				WriteTimeout: writeTimeout,
			},
			logger,
		},
		{
			"internal",
			&http.Server{
				Addr:         ":" + strconv.Itoa(env.InternalPort),
				Handler:      internalRouter(logger),
				ReadTimeout:  readTimeout,
				WriteTimeout: writeTimeout,
			},
			logger,
		},
	}

	for _, v := range server {
		s := v
		go s.run()
	}

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	logger.Info("Shutting down server...")

	ctx, cancel := context.WithTimeout(context.Background(), shutdownTimeout)
	defer cancel()

	for _, v := range server {
		s := v
		s.shutdown(ctx)
	}

	logger.Info("Server exiting")
}

func (s *Server) run() {
	s.logger.Info(
		"Listen and serve",
		zap.String("service", s.name),
	)

	err := s.parameter.ListenAndServe()
	if err != nil && errors.Is(err, http.ErrServerClosed) {
		s.logger.Info(
			"Server closed",
			zap.String("service", s.name),
		)
	}
}

func (s *Server) shutdown(ctx context.Context) {
	if err := s.parameter.Shutdown(ctx); err != nil {
		s.logger.Fatal(
			"Server forced to shutdown",
			zap.Error(err),
			zap.String("service", s.name),
		)
	}
}
