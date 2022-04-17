package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// @Summary Liveness check
// @Description used by Kubernetes liveness probe
// @Tags Kubernetes
// @Produce json
// @Router /healthz [get]
// @Success 200 {string} string
func healthzHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "OK",
		})
	}
}

// @Summary Readiness check
// @Description used by Kubernetes readiness probe
// @Tags Kubernetes
// @Produce json
// @Router /readyz [get]
// @Success 200 {string} string
func readyzHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "OK",
		})
	}
}
