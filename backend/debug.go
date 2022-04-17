package main

import (
	"time"

	"github.com/gin-gonic/gin"
)

const timeout = 15 * time.Second

// @Summary Panic
// @Description call panic function to check 500 Internal Server Error page
// @Tags Debug
// @Produce plain
// @Router /panic [get]
// @Success 500 {string} string
func panicHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		panic("An unexpected error happen!")
	}
}

// @Summary Timeout
// @Description call sleep function to check forced shutdown
// @Tags Debug
// @Produce plain
// @Router /timeout [get]
func timeoutHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		time.Sleep(timeout)
	}
}
