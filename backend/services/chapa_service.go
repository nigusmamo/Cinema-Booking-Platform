package services

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"time"

	"github.com/nigusmamo/Cinema-Booking-Platform/models"
)

var chapaHTTPClient = &http.Client{Timeout: 15 * time.Second}

// InitializePayment starts a Chapa checkout and returns the checkout URL.
func InitializePayment(req models.ChapaRequest) (string, error) {
	secretKey := os.Getenv("CHAPA_SECRET_KEY")
	apiURL := os.Getenv("CHAPA_API_URL")

	jsonData, _ := json.Marshal(req)

	httpReq, _ := http.NewRequest("POST", apiURL, bytes.NewBuffer(jsonData))
	httpReq.Header.Set("Authorization", "Bearer "+secretKey)
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := chapaHTTPClient.Do(httpReq)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)

	var chapaResp models.ChapaResponse
	json.Unmarshal(body, &chapaResp)

	if chapaResp.Status != "success" {
		return "", fmt.Errorf("Chapa Error: %s", chapaResp.Message)
	}

	return chapaResp.Data.CheckoutURL, nil
}

// VerifyPayment asks Chapa about a transaction by its reference.
func VerifyPayment(txRef string) (models.ChapaVerifyResponse, error) {
	var result models.ChapaVerifyResponse

	secretKey := os.Getenv("CHAPA_SECRET_KEY")
	verifyURL := os.Getenv("CHAPA_VERIFY_URL") + txRef

	httpReq, err := http.NewRequest("GET", verifyURL, nil)
	if err != nil {
		return result, err
	}
	httpReq.Header.Set("Authorization", "Bearer "+secretKey)

	resp, err := chapaHTTPClient.Do(httpReq)
	if err != nil {
		return result, err
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)
	if err := json.Unmarshal(body, &result); err != nil {
		return result, err
	}
	return result, nil
}
