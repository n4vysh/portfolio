package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func noRouteHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		_, span := tracer.Start(c.Request.Context(), "noRouteHandler")
		defer span.End()
		c.FileFromFS("404/", convertFS("dist"))
		c.AbortWithStatus(http.StatusNotFound)
	}
}
