package routes

import (
	"github.com/gin-gonic/gin"
	"github.com/nigusmamo/Cinema-Booking-Platform/controllers"
)

func UploadRoutes(r *gin.Engine) {
	uploadGroup := r.Group("/upload")
	{
		uploadGroup.POST("/file", controllers.UploadFileHandler)
	}
}
