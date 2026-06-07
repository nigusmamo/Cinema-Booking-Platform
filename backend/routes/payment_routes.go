package routes

import (
	"github.com/gin-gonic/gin"
	"github.com/nigusmamo/Cinema-Booking-Platform/controllers"
)

func PaymentRoutes(r *gin.Engine) {
	r.POST("/payment/initialize", controllers.InitializePaymentHandler)
}
