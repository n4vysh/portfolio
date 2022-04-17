package main

import "github.com/gin-gonic/gin"

func indexHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.FileFromFS("/", convertFS("dist"))
	}
}
