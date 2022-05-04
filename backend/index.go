package main

import (
	"github.com/gin-gonic/gin"
)

func indexHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		_, span := tracer.Start(c.Request.Context(), "indexHandler")
		defer span.End()
		c.FileFromFS("/", convertFS("dist"))
	}
}
