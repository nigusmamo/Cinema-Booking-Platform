package models

type ChapaRequest struct {
	Amount         string                 `json:"amount"`
	Currency       string                 `json:"currency"`
	Email          string                 `json:"email"`
	FirstName      string                 `json:"first_name"`
	LastName       string                 `json:"last_name"`
	TxRef          string                 `json:"tx_ref"` 
	CallbackURL    string                 `json:"callback_url"`
	ReturnURL      string                 `json:"return_url"`
}

type ChapaResponse struct {
	Message string `json:"message"`
	Status  string `json:"status"`
	Data    struct {
		CheckoutURL string `json:"checkout_url"`
	} `json:"data"`
}

type PaymentOutput struct {
	CheckoutURL string `json:"checkout_url"`
	TxRef       string `json:"tx_ref"`
}

// ChapaVerifyResponse is the shape returned by Chapa's transaction verify API.
type ChapaVerifyResponse struct {
	Message string `json:"message"`
	Status  string `json:"status"`
	Data    struct {
		Status string  `json:"status"`
		Amount float64 `json:"amount"`
		TxRef  string  `json:"tx_ref"`
	} `json:"data"`
}