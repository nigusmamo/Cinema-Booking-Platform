package main

import (
	"log"

	"github.com/joho/godotenv"
	"github.com/nigusmamo/Cinema-Booking-Platform/utils"
	"github.com/gin-gonic/gin"
)

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
	utils.ConnectDB()

	r := gin.Default()

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Cinema Backend is Connected and Running!",
		})
	})

	r.Run(":8000")
}