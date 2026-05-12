package services

import (
	"errors"
	"github.com/nigusmamo/Cinema-Booking-Platform/models"
	"github.com/nigusmamo/Cinema-Booking-Platform/utils"
)

func RegisterUser(req models.SignupRequest) (models.User, error) {
	var user models.User
	hashedPassword, err := utils.HashPassword(req.Password)
	if err != nil {
		return user, errors.New("Password hashing failed")
	}
	query := `INSERT INTO users (full_name, email, password, role) 
	          VALUES ($1, $2, $3, $4) 
	          RETURNING id, full_name, email, role, created_at`
	
	err = utils.DB.QueryRow(query, req.FullName, req.Email, hashedPassword, "user").Scan(
		&user.ID, &user.FullName, &user.Email, &user.Role, &user.CreatedAt,
	)

	if err != nil {
		return user, errors.New("Failed to register user: " + err.Error())
	}

	return user, nil
}

func LoginUser(req models.LoginRequest) (string, models.User, error) {
	var user models.User

	query := `SELECT id, full_name, email, password, role FROM users WHERE email = $1`
	err := utils.DB.QueryRow(query, req.Email).Scan(
		&user.ID, &user.FullName, &user.Email, &user.Password, &user.Role,
	)
	if err != nil {
		return "", user, errors.New("Email or password is not match")
	}

	if !utils.CheckPasswordHash(req.Password, user.Password) {
		return "", user, errors.New("Email or password is not match")
	}

	token, err := utils.GenerateToken(user.ID, user.Role)
	if err != nil {
		return "", user, errors.New("Token generation failed")
	}

	return token, user, nil
}