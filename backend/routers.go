package main

import (
	"net/http"

	"github.com/gin-contrib/secure"
	"github.com/gin-gonic/contrib/gzip"
	"github.com/gin-gonic/gin"
	swaggerfiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
	"go.uber.org/zap"
)

func publicRouter(logger *zap.Logger, host string) http.Handler {
	e := gin.New()

	e.Use(zapLogger(logger))
	e.Use(zapRecovery(logger, true))
	e.Use(injectTracingHeaders())
	e.Use(otelgin.Middleware("portfolio"))
	e.Use(gzip.Gzip(gzip.DefaultCompression))

	securityConfig := secure.Config{
		FrameDeny:          true,
		ContentTypeNosniff: true,
		BrowserXssFilter:   true,
		IENoOpen:           true,
	}
	if host != "" {
		securityConfig.AllowedHosts = []string{host}
	}

	e.Use(secure.New(securityConfig))

	// nolint: errcheck
	e.SetTrustedProxies(nil) // for using ALB, EnvoyProxy, and Linkerd

	g := e.Group("/", otelSetSpan("index"))
	g.StaticFS("/", convertToHFS(indexEFS, "dist"))

	e.NoRoute(noRouteHandler())

	return e
}

func internalRouter(logger *zap.Logger) http.Handler {
	e := gin.New()

	e.Use(zapLogger(logger))
	e.Use(zapRecovery(logger, true))
	// nolint: errcheck
	e.SetTrustedProxies(nil) // for using Linkerd

	e.GET("/metrics", prometheusHandler())
	e.GET("/healthz", healthzHandler())
	e.GET("/readyz", readyzHandler())

	e.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))

	if gin.Mode() == gin.DebugMode {
		e.GET("/panic", panicHandler())
		e.GET("/timeout", timeoutHandler())
	}

	return e
}
