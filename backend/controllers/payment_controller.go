package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/nigusmamo/Cinema-Booking-Platform/services"
)

type payInput struct {
	ScheduleID string   `json:"schedule_id"`
	SeatIDs    []string `json:"seat_ids"`
	Email      string   `json:"email"`
	FirstName  string   `json:"first_name"`
	LastName   string   `json:"last_name"`
}

type payPayload struct {
	Input            payInput          `json:"input"`
	SessionVariables map[string]string `json:"session_variables"`
}

func InitializePaymentHandler(c *gin.Context) {
	var payload payPayload
	if err := c.ShouldBindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid data provided"})
		return
	}

	userID := payload.SessionVariables["x-hasura-user-id"]
	if userID == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"message": "Authentication required"})
		return
	}
	if payload.Input.ScheduleID == "" || len(payload.Input.SeatIDs) == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Schedule and seats are required"})
		return
	}

	result, err := services.CreateBookingAndInitPayment(services.NewBookingRequest{
		UserID:     userID,
		ScheduleID: payload.Input.ScheduleID,
		SeatIDs:    payload.Input.SeatIDs,
		Email:      payload.Input.Email,
		FirstName:  payload.Input.FirstName,
		LastName:   payload.Input.LastName,
	})
	
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Payment initialization failed"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"checkout_url": result.CheckoutURL,
		"tx_ref":       result.TxRef,
	})
}

type verifyInput struct {
	TxRef string `json:"tx_ref"`
}

type verifyPayload struct {
	Input            verifyInput       `json:"input"`
	SessionVariables map[string]string `json:"session_variables"`
}

func VerifyPaymentHandler(c *gin.Context) {
	var payload verifyPayload
	if err := c.ShouldBindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid data provided"})
		return
	}

	userID := payload.SessionVariables["x-hasura-user-id"]
	if userID == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"message": "Authentication required"})
		return
	}
	if payload.Input.TxRef == "" {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Transaction reference is required"})
		return
	}

	booking, err := services.VerifyAndCompleteBooking(userID, payload.Input.TxRef)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Payment verification failed"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status":            booking.Status,
		"booking_reference": booking.BookingReference,
		"total_price":       booking.TotalPrice,
		"movie_title":       booking.MovieTitle,
		"start_time":        booking.StartTime,
		"full_name":         booking.FullName,
		"seats":             booking.Seats,
	})
}
