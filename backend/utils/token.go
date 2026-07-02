package utils

import (
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

func GenerateToken(userID string, role string) (string, error) {
	claims := jwt.MapClaims{
		"sub":  userID,
		"exp":  time.Now().Add(time.Hour * 24 * 7).Unix(), 
		"iat":  time.Now().Unix(),

		"https://hasura.io/jwt/claims": jwt.MapClaims{
			"x-hasura-allowed-roles": []string{"user", "admin"},
			"x-hasura-default-role":  role,
			"x-hasura-user-id":       userID,
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	
	secret := os.Getenv("JWT_SECRET")
	return token.SignedString([]byte(secret))
}