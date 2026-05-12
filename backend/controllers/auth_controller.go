package controllers

import (
	"net/http"
	"github.com/nigusmamo/Cinema-Booking-Platform/models"
	"github.com/nigusmamo/Cinema-Booking-Platform/services"
	"github.com/gin-gonic/gin"
)

func SignupHandler(c *gin.Context) {
	var payload models.SignupActionPayload
	
	if err := c.ShouldBindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid request body"})
		return
	}

	user, err := services.RegisterUser(payload.Input)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"id":        user.ID,
		"full_name": user.FullName,
		"email":     user.Email,
	})
}

func LoginHandler(c *gin.Context) {
	var payload models.LoginActionPayload

	if err := c.ShouldBindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid request body"})
		return
	}

	token, user, err := services.LoginUser(payload.Input)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"token":     token,
		"id":        user.ID,
		"full_name": user.FullName,
	})
}