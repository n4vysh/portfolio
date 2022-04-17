package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func noRouteHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.FileFromFS("404/", convertFS("dist"))
		c.AbortWithStatus(http.StatusNotFound)
	}
}
