package models

import "time"

type User struct {
	ID        string    `json:"id"`
	FullName  string    `json:"full_name"`
	Email     string    `json:"email"`
	Password  string    `json:"password"`
	Role      string    `json:"role"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type SignupRequest struct {
	FullName string `json:"full_name" binding:"required"`
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

type SignupActionPayload struct {
	Action struct {
		Name string `json:"name"`
	} `json:"action"`
	Input SignupRequest `json:"input"`
}

type LoginActionPayload struct {
	Action struct {
		Name string `json:"name"`
	} `json:"action"`
	Input LoginRequest `json:"input"`
}