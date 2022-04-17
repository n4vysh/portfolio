package main

import (
	"github.com/gin-gonic/gin"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

// @Summary OpenMetrics
// @Description used by Prometheus
// @Tags Prometheus
// @Produce plain
// @Router /metrics [get]
// @Success 200 {string} string
func prometheusHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		promhttp.HandlerFor(
			prometheus.DefaultGatherer,
			promhttp.HandlerOpts{
				EnableOpenMetrics: true,
			},
		).ServeHTTP(c.Writer, c.Request)
	}
}
