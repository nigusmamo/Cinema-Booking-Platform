package middleware

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func RequireActionSecret() gin.HandlerFunc {
	return func(c *gin.Context) {
		expected := os.Getenv("ACTION_SECRET")
		provided := c.GetHeader("X-Hasura-Action-Secret")

		if expected == "" || provided != expected {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"message": "Unauthorized"})
			return
		}

		c.Next()
	}
}
