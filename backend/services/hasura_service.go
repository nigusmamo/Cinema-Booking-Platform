package services

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"time"
)

type hasuraGraphQLRequest struct {
	Query     string                 `json:"query"`
	Variables map[string]interface{} `json:"variables,omitempty"`
}

type hasuraGraphQLError struct {
	Message string `json:"message"`
}

var hasuraHTTPClient = &http.Client{Timeout: 15 * time.Second}

func hasuraGraphQL(query string, variables map[string]interface{}, out interface{}) error {
	endpoint := os.Getenv("HASURA_GRAPHQL_URL")
	adminSecret := os.Getenv("HASURA_GRAPHQL_ADMIN_SECRET")
	if endpoint == "" || adminSecret == "" {
		return fmt.Errorf("hasura graphql is not configured")
	}

	payload, err := json.Marshal(hasuraGraphQLRequest{Query: query, Variables: variables})
	if err != nil {
		return err
	}

	req, err := http.NewRequest(http.MethodPost, endpoint, bytes.NewBuffer(payload))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("x-hasura-admin-secret", adminSecret)

	resp, err := hasuraHTTPClient.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	
	var result struct {
		Data   json.RawMessage      `json:"data"`
		Errors []hasuraGraphQLError `json:"errors"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return fmt.Errorf("invalid response from hasura: %w", err)
	}

	if len(result.Errors) > 0 {
		return fmt.Errorf("%s", result.Errors[0].Message)
	}

	if out != nil {
		if err := json.Unmarshal(result.Data, out); err != nil {
			return err
		}
	}
	return nil
}
