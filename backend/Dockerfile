# syntax=docker/dockerfile:1

# base: shared build environment + cached Go module download
FROM golang:1.26-alpine AS base
WORKDIR /app
# git + ca-certificates are needed to fetch modules / make outbound HTTPS calls
RUN apk add --no-cache git ca-certificates
# Download dependencies first so this layer is cached until go.mod/go.sum change
COPY go.mod go.sum ./
RUN go mod download

# dev: hot reload via Air. Source is bind-mounted by docker-compose at runtime.
FROM base AS dev
# Air rebuilds and restarts the server whenever a .go file changes
RUN go install github.com/air-verse/air@latest
COPY . .
EXPOSE 8000
CMD ["air", "-c", ".air.toml"]

# builder: compile a small, static, production binary
FROM base AS builder
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/server .

# prod: minimal runtime image
FROM alpine:3.20 AS prod
WORKDIR /app
RUN apk add --no-cache ca-certificates wget \
 && adduser -D -u 10001 appuser
COPY --from=builder /out/server /app/server

RUN touch .env && chown -R appuser:appuser /app
USER appuser
EXPOSE 8000
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=5 \
  CMD wget -qO- http://localhost:8000/ping || exit 1
CMD ["/app/server"]
