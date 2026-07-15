package routes

import (
	"github.com/gin-gonic/gin"
	"github.com/nigusmamo/Cinema-Booking-Platform/controllers"
	"github.com/nigusmamo/Cinema-Booking-Platform/middleware"
)

func PaymentRoutes(r *gin.Engine) {
	payment := r.Group("/payment")
	payment.Use(middleware.RequireActionSecret())
	{
		payment.POST("/initialize", controllers.InitializePaymentHandler)
		payment.POST("/verify", controllers.VerifyPaymentHandler)
	}
}
