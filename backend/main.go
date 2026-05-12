package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/nigusmamo/Cinema-Booking-Platform/routes"
	"github.com/nigusmamo/Cinema-Booking-Platform/utils"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Fatal("Error loading .env file")
	}

	utils.ConnectDB()
	r := gin.Default()
	routes.AuthRoutes(r)

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "Server is running"}) 
	})
	r.Run(":8000")
}