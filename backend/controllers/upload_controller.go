package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/nigusmamo/Cinema-Booking-Platform/services"
)

func UploadSignatureHandler(c *gin.Context) {
	signature, err := services.GenerateUploadSignature()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, signature)
}
