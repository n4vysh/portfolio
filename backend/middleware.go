package main

import (
	"net"
	"net/http"
	"net/http/httputil"
	"os"
	"runtime/debug"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

func zapLogger(logger *zap.Logger) gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now()
		path := c.Request.URL.Path
		query := c.Request.URL.RawQuery
		c.Next()

		if len(c.Errors) > 0 {
			for _, e := range c.Errors.Errors() {
				logger.Error(e)
			}
		} else {
			fields := []zapcore.Field{
				zap.Int("status", c.Writer.Status()),
				zap.String("method", c.Request.Method),
				zap.String("path", path),
				zap.String("query", query),
				zap.String("ip", c.ClientIP()),
				zap.String("user_agent", c.Request.UserAgent()),
				zap.Duration("latency", time.Since(start)),
			}
			logger.Info(path, fields...)
		}
	}
}

func zapRecovery(logger *zap.Logger, stack bool) gin.HandlerFunc {
	return func(c *gin.Context) {
		defer func() {
			if err := recover(); err != nil {
				httpRequest, _ := httputil.DumpRequest(c.Request, false)
				if checkBrokenPipe(logger, err) {
					logger.Error(c.Request.URL.Path,
						zap.Any("error", err),
						zap.String("request", string(httpRequest)),
					)
					// nolint: errcheck, forcetypeassert
					c.Error(err.(error))
					c.Abort()

					return
				}

				if stack {
					logger.Error("recovery from panic",
						zap.Time("time", time.Now()),
						zap.Any("error", err),
						zap.String("request", string(httpRequest)),
						zap.String("stack", string(debug.Stack())),
					)
				} else {
					logger.Error("recovery from panic",
						zap.Time("time", time.Now()),
						zap.Any("error", err),
						zap.String("request", string(httpRequest)),
					)
				}

				msg := "Internal Server Error - The server is currently unable to service your request."
				c.String(http.StatusInternalServerError, msg)
			}
		}()
		c.Next()
	}
}

func checkBrokenPipe(logger *zap.Logger, err interface{}) (brokenPipe bool) {
	ne, ok := err.(*net.OpError)
	if !ok {
		brokenPipe = false
	}

	se, ok := ne.Err.(*os.SyscallError) // nolint: errorlint
	if !ok {
		brokenPipe = false
	}

	errstr := strings.ToLower(se.Error())
	if strings.Contains(errstr, "broken pipe") ||
		strings.Contains(errstr, "connection reset by peer") {
		brokenPipe = true
	}

	return
}

// https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/observability/tracing
// https://istio.io/latest/docs/tasks/observability/distributed-tracing/overview/
func injectTracingHeaders() gin.HandlerFunc {
	return func(c *gin.Context) {
		headers := []string{
			"x-request-id",
			"x-b3-traceid",
			"x-b3-spanid",
			"x-b3-parentspanid",
			"x-b3-sampled",
			"x-b3-flags",
		}
		for i := range headers {
			v := c.Request.Header.Get(headers[i])
			if len(v) > 0 {
				c.Writer.Header().Set(headers[i], v)
			}
		}

		c.Next()
	}
}

func otelSetSpan(span string) gin.HandlerFunc {
	return func(c *gin.Context) {
		_, span := tracer.Start(c.Request.Context(), span+"Handler")
		defer span.End()

		c.Next()
	}
}
