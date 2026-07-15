package routes

import (
	"github.com/gin-gonic/gin"
	"github.com/nigusmamo/Cinema-Booking-Platform/controllers"
	"github.com/nigusmamo/Cinema-Booking-Platform/middleware"
)

func UploadRoutes(r *gin.Engine) {
	uploadGroup := r.Group("/upload")
	uploadGroup.Use(middleware.RequireActionSecret())
	{
		uploadGroup.POST("/signature", controllers.UploadSignatureHandler)
	}
}
