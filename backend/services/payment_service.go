package services

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"

	"github.com/nigusmamo/Cinema-Booking-Platform/models"
)

func InitializePayment(req models.ChapaRequest) (string, error) {
	secretKey := os.Getenv("CHAPA_SECRET_KEY")
	apiURL := os.Getenv("CHAPA_API_URL")

	jsonData, _ := json.Marshal(req)

	client := &http.Client{}
	httpReq, _ := http.NewRequest("POST", apiURL, bytes.NewBuffer(jsonData))
	httpReq.Header.Set("Authorization", "Bearer "+secretKey)
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := client.Do(httpReq)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)
	fmt.Println("Chapa API Response:", string(body))

	var chapaResp models.ChapaResponse
	json.Unmarshal(body, &chapaResp)

	if chapaResp.Status != "success" {
		return "", fmt.Errorf("Chapa Error: %s", chapaResp.Message)
	}

	return chapaResp.Data.CheckoutURL, nil
}
