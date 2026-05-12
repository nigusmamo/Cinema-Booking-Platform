package utils

import (
	"database/sql"
	"log"
	"os"

	_ "github.com/lib/pq"
)

var DB *sql.DB
func ConnectDB() {
	var err error
	dbURL := os.Getenv("DB_URL")
	
	DB, err = sql.Open("postgres", dbURL)
	if err != nil {
		log.Fatal("Can not connect to database", err)
	}

	err = DB.Ping()
	if err != nil {
		log.Fatal("Can not connect to database", err)
	}

	log.Println("Database connected successfully!")
}