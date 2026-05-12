package routes

import (
	"github.com/nigusmamo/Cinema-Booking-Platform/controllers"
	"github.com/gin-gonic/gin"
)

func AuthRoutes(r *gin.Engine) {
	authGroup := r.Group("/auth")
	{
		authGroup.POST("/signup", controllers.SignupHandler)
		authGroup.POST("/login", controllers.LoginHandler)
	}
}