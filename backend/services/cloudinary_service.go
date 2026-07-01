package services

import (
	"fmt"
	"net/url"
	"os"
	"strconv"
	"time"

	"github.com/cloudinary/cloudinary-go/v2/api"
)

const UploadFolder = "cinema_uploads"

type UploadSignature struct {
	Signature string `json:"signature"`
	Timestamp int64  `json:"timestamp"`
	APIKey    string `json:"api_key"`
	CloudName string `json:"cloud_name"`
	Folder    string `json:"folder"`
}

func GenerateUploadSignature() (UploadSignature, error) {
	cloudName := os.Getenv("CLOUDINARY_CLOUD_NAME")
	apiKey := os.Getenv("CLOUDINARY_API_KEY")
	apiSecret := os.Getenv("CLOUDINARY_API_SECRET")

	if cloudName == "" || apiKey == "" || apiSecret == "" {
		return UploadSignature{}, fmt.Errorf("cloudinary credentials are not configured")
	}

	timestamp := time.Now().Unix()

	params := url.Values{}
	params.Set("folder", UploadFolder)
	params.Set("timestamp", strconv.FormatInt(timestamp, 10))

	signature, err := api.SignParameters(params, apiSecret)
	if err != nil {
		return UploadSignature{}, fmt.Errorf("failed to sign upload params: %w", err)
	}

	return UploadSignature{
		Signature: signature,
		Timestamp: timestamp,
		APIKey:    apiKey,
		CloudName: cloudName,
		Folder:    UploadFolder,
	}, nil
}
