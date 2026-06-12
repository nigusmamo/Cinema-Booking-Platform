package controllers

import (
	"encoding/base64"
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

type UploadActionPayload struct {
	Action struct {
		Name string `json:"name"`
	} `json:"action"`
	Input struct {
		Base64Data string `json:"base64_data"`
		Filename   string `json:"filename"`
	} `json:"input"`
}

func UploadFileHandler(c *gin.Context) {
	var payload UploadActionPayload

	if err := c.ShouldBindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid request body"})
		return
	}

	b64data := payload.Input.Base64Data
	if idx := strings.Index(b64data, ";base64,"); idx != -1 {
		b64data = b64data[idx+8:]
	}

	decodedData, err := base64.StdEncoding.DecodeString(b64data)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid base64 data: " + err.Error()})
		return
	}

	ext := filepath.Ext(payload.Input.Filename)
	base := strings.TrimSuffix(payload.Input.Filename, ext)
	base = strings.ReplaceAll(base, " ", "_")
	newFilename := fmt.Sprintf("%s_%d%s", base, time.Now().UnixNano(), ext)

	uploadDir := "./uploads"
	if err := os.MkdirAll(uploadDir, os.ModePerm); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to create upload directory"})
		return
	}

	filePath := filepath.Join(uploadDir, newFilename)
	if err := os.WriteFile(filePath, decodedData, 0644); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to write file: " + err.Error()})
		return
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
	}
	url := fmt.Sprintf("http://localhost:%s/uploads/%s", port, newFilename)

	c.JSON(http.StatusOK, gin.H{
		"url": url,
	})
}
