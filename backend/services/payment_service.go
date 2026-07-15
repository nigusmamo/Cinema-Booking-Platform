package services

import (
	"crypto/rand"
	"encoding/hex"
	"math"
	"net/url"
	"os"
	"strconv"

	"github.com/nigusmamo/Cinema-Booking-Platform/models"
)

type NewBookingRequest struct {
	UserID     string
	ScheduleID string
	SeatIDs    []string
	Email      string
	FirstName  string
	LastName   string
}

// PaymentInitResult is returned to the frontend after payment is started.
type PaymentInitResult struct {
	CheckoutURL string
	TxRef       string
}

// VerifiedBooking is the confirmed booking data used to render the ticket.
type VerifiedBooking struct {
	Status           string
	BookingReference string
	TotalPrice       string
	MovieTitle       string
	StartTime        string
	FullName         string
	Seats            []string
}

func CreateBookingAndInitPayment(req NewBookingRequest) (PaymentInitResult, error) {
	amount, err := calculateAmount(req.SeatIDs)
	if err != nil {
		return PaymentInitResult{}, err
	}

	txRef := generateReference("cine-tx")
	bookingRef := generateReference("CINE")
	if err := createPendingBooking(req, amount, bookingRef, txRef); err != nil {
		return PaymentInitResult{}, err
	}

	chapaReq := models.ChapaRequest{
		Amount:    strconv.FormatFloat(amount, 'f', 2, 64),
		Currency:  "ETB",
		Email:     req.Email,
		FirstName: req.FirstName,
		LastName:  req.LastName,
		TxRef:     txRef,
		ReturnURL: os.Getenv("FRONTEND_URL") + "/booking/confirmation?tx_ref=" + url.QueryEscape(txRef),
	}
	checkoutURL, err := InitializePayment(chapaReq)
	if err != nil {
		return PaymentInitResult{}, err
	}

	return PaymentInitResult{CheckoutURL: checkoutURL, TxRef: txRef}, nil
}


func VerifyAndCompleteBooking(userID, txRef string) (VerifiedBooking, error) {
	booking, err := getBookingByTxRef(userID, txRef)
	if err != nil {
		return VerifiedBooking{}, err
	}

	if booking.PaymentStatus == "completed" {
		return toVerifiedBooking(booking), nil
	}

	chapa, err := VerifyPayment(txRef)
	if err != nil {
		return VerifiedBooking{}, err
	}

	paymentSucceeded := chapa.Status == "success" && chapa.Data.Status == "success"

	amountMatches := toCents(chapa.Data.Amount) == toCents(booking.TotalPrice)

	if !paymentSucceeded || !amountMatches {
		result := toVerifiedBooking(booking)
		result.Status = "pending"
		return result, nil
	}

	if err := markBookingCompleted(txRef); err != nil {
		return VerifiedBooking{}, err
	}
	booking.PaymentStatus = "completed"
	return toVerifiedBooking(booking), nil
}

func toVerifiedBooking(b bookingRecord) VerifiedBooking {
	return VerifiedBooking{
		Status:           b.PaymentStatus,
		BookingReference: b.BookingReference,
		TotalPrice:       strconv.FormatFloat(b.TotalPrice, 'f', 2, 64),
		MovieTitle:       b.MovieTitle,
		StartTime:        b.StartTime,
		FullName:         b.FullName,
		Seats:            b.Seats,
	}
}

// generate Payment Reference string.
func generateReference(prefix string) string {
	b := make([]byte, 6)
	_, _ = rand.Read(b)
	return prefix + "-" + hex.EncodeToString(b)
}

func toCents(amount float64) int64 {
	return int64(math.Round(amount * 100))
}
