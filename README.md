# 🎬 Cinema Booking Platform

A full-stack cinema ticket booking platform. Users can browse movies, view showtimes, pick seats on an interactive seat map, pay online, and manage bookmarks and ratings — with a full admin panel for managing movies, schedules, cast, and pricing.

## Tech Stack

- **Frontend:** Nuxt 4 · Vue 3 · Tailwind CSS · Apollo GraphQL
- **API / Data:** Hasura GraphQL Engine + PostgreSQL
- **Backend:** Go (Gin) — handles auth, payments, and file uploads
- **Payments:** Chapa · **Auth:** JWT

## Features

- Browse movies with posters, genres, cast, and directors
- View schedules and showtimes
- Interactive seat selection and online payment
- Bookmark and rate movies
- User profiles with booking history
- Admin panel for movies, schedules, cast, and pricing

## Getting Started

**Prerequisites:** Docker, Go 1.26+, Node.js 18+, and the [Hasura CLI](https://hasura.io/docs/latest/hasura-cli/install-hasura-cli/).

```bash
# 1. Clone
git clone https://github.com/nigusmamo/Cinema-Booking-Platform.git
cd Cinema-Booking-Platform

# 2. Start Postgres & Hasura
docker compose up -d

# 3. Apply migrations, metadata & seeds
hasura migrate apply && hasura metadata apply && hasura seed apply

# 4. Run the backend
cd backend && go run main.go

# 5. Run the frontend
cd frontend && npm install && npm run dev
```

> Create a root `.env` and a `backend/.env` with your database, JWT, and Chapa credentials before running.

The app runs at **http://localhost:3000**, GraphQL at **http://localhost:8080**, and the Go API at **http://localhost:8000**.

## Project Structure

```
frontend/    # Nuxt 4 + Vue 3 app
backend/     # Go (Gin) service (auth, payments, uploads)
metadata/    # Hasura tables, relationships & permissions
migrations/  # Database migrations
seeds/       # Seed data
```
