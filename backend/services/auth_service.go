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

	const mutation = `
		mutation RegisterUser($full_name: String!, $email: String!, $password: String!, $role: String!) {
			insert_users_one(object: {full_name: $full_name, email: $email, password: $password, role: $role}) {
				id
				full_name
				email
				role
			}
		}`

	variables := map[string]interface{}{
		"full_name": req.FullName,
		"email":     req.Email,
		"password":  hashedPassword,
		"role":      "user",
	}

	var resp struct {
		InsertUsersOne *models.User `json:"insert_users_one"`
	}
	if err := hasuraGraphQL(mutation, variables, &resp); err != nil {
		return user, errors.New("Failed to register user: " + err.Error())
	}
	if resp.InsertUsersOne == nil {
		return user, errors.New("Failed to register user")
	}

	return *resp.InsertUsersOne, nil
}

func LoginUser(req models.LoginRequest) (string, models.User, error) {
	var user models.User

	const query = `
		query GetUserByEmail($email: String!) {
			users(where: {email: {_eq: $email}}, limit: 1) {
				id
				full_name
				email
				password
				role
			}
		}`

	variables := map[string]interface{}{
		"email": req.Email,
	}

	var resp struct {
		Users []models.User `json:"users"`
	}
	if err := hasuraGraphQL(query, variables, &resp); err != nil {
		return "", user, errors.New("Email or password is not match")
	}
	if len(resp.Users) == 0 {
		return "", user, errors.New("Email or password is not match")
	}
	user = resp.Users[0]

	if !utils.CheckPasswordHash(req.Password, user.Password) {
		return "", user, errors.New("Email or password is not match")
	}

	token, err := utils.GenerateToken(user.ID, user.Role)
	if err != nil {
		return "", user, errors.New("Token generation failed")
	}

	return token, user, nil
}