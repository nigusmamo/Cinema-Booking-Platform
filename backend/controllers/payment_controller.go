package controllers

import (
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/nigusmamo/Cinema-Booking-Platform/models"
	"github.com/nigusmamo/Cinema-Booking-Platform/services"
)

func InitializePaymentHandler(c *gin.Context) {
	var payload struct {
		Input models.ChapaRequest `json:"input"`
	}

	if err := c.ShouldBindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid data provided"})
		return
	}

	req := payload.Input
	req.TxRef = fmt.Sprintf("CINE-%d", time.Now().Unix())
	req.Currency = "ETB"
	req.ReturnURL = "http://localhost:3000/booking/confirmation"

	checkoutURL, err := services.InitializePayment(req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Payment initialization failed"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"checkout_url": checkoutURL,
		"tx_ref":       req.TxRef,
	})
}
