package services

import (
	"fmt"
	"strconv"
)

func calculateAmount(seatIDs []string) (float64, error) {
	if len(seatIDs) == 0 {
		return 0, fmt.Errorf("no seats selected")
	}

	conditions := make([]map[string]interface{}, 0, len(seatIDs))
	for _, seat := range seatIDs {
		row, col, err := parseSeatLabel(seat)
		if err != nil {
			return 0, err
		}
		conditions = append(conditions, map[string]interface{}{
			"row_label":     map[string]interface{}{"_eq": row},
			"column_number": map[string]interface{}{"_eq": col},
		})
	}

	const query = `
		query SeatPricing($where: seats_bool_exp!) {
			seats(where: $where) { row_label column_number type }
			seat_prices { type price }
		}`
	variables := map[string]interface{}{
		"where": map[string]interface{}{"_or": conditions},
	}

	var resp struct {
		Seats []struct {
			RowLabel     string `json:"row_label"`
			ColumnNumber int    `json:"column_number"`
			Type         string `json:"type"`
		} `json:"seats"`
		SeatPrices []struct {
			Type  string  `json:"type"`
			Price float64 `json:"price"`
		} `json:"seat_prices"`
	}
	if err := hasuraGraphQL(query, variables, &resp); err != nil {
		return 0, err
	}

	seatType := make(map[string]string)
	for _, s := range resp.Seats {
		label := s.RowLabel + strconv.Itoa(s.ColumnNumber)
		seatType[label] = s.Type
	}

	priceByType := make(map[string]float64)
	for _, p := range resp.SeatPrices {
		priceByType[p.Type] = p.Price
	}

	var total float64
	for _, seat := range seatIDs {
		t, ok := seatType[seat]
		if !ok {
			return 0, fmt.Errorf("unknown seat: %s", seat)
		}
		total += priceByType[t]
	}
	return total, nil
}

// parseSeatLabel splits a seat label like "A1" into its row ("A") and column (1).
func parseSeatLabel(label string) (string, int, error) {
	i := 0
	for i < len(label) && (label[i] < '0' || label[i] > '9') {
		i++
	}
	row := label[:i]
	number := label[i:]
	if row == "" || number == "" {
		return "", 0, fmt.Errorf("invalid seat: %s", label)
	}
	col, err := strconv.Atoi(number)
	if err != nil {
		return "", 0, fmt.Errorf("invalid seat: %s", label)
	}
	return row, col, nil
}

func createPendingBooking(req NewBookingRequest, amount float64, bookingRef, txRef string) error {
	seats := make([]map[string]interface{}, 0, len(req.SeatIDs))
	for _, seatID := range req.SeatIDs {
		seats = append(seats, map[string]interface{}{"seat_id": seatID})
	}

	const mutation = `
		mutation CreatePendingBooking($object: bookings_insert_input!) {
			insert_bookings_one(object: $object) { id }
		}`

	variables := map[string]interface{}{
		"object": map[string]interface{}{
			"user_id":           req.UserID,
			"schedule_id":       req.ScheduleID,
			"total_price":       amount,
			"payment_status":    "pending",
			"payment_method":    "chapa",
			"booking_reference": bookingRef,
			"tx_ref":            txRef,
			"booking_seats":     map[string]interface{}{"data": seats},
		},
	}

	var resp struct {
		InsertBookingsOne *struct {
			ID string `json:"id"`
		} `json:"insert_bookings_one"`
	}
	if err := hasuraGraphQL(mutation, variables, &resp); err != nil {
		return err
	}
	if resp.InsertBookingsOne == nil {
		return fmt.Errorf("failed to create booking")
	}
	return nil
}

// bookingRecord is the raw booking data loaded from Hasura.
type bookingRecord struct {
	PaymentStatus    string
	TotalPrice       float64
	BookingReference string
	FullName         string
	MovieTitle       string
	StartTime        string
	Seats            []string
}


func getBookingByTxRef(userID, txRef string) (bookingRecord, error) {
	const query = `
		query BookingByTxRef($tx_ref: String!, $user_id: uuid!) {
			bookings(where: {tx_ref: {_eq: $tx_ref}, user_id: {_eq: $user_id}}) {
				payment_status
				total_price
				booking_reference
				user { full_name }
				schedule { start_time movie { title } }
				booking_seats { seat_id }
			}
		}`
	variables := map[string]interface{}{"tx_ref": txRef, "user_id": userID}

	var resp struct {
		Bookings []struct {
			PaymentStatus    string  `json:"payment_status"`
			TotalPrice       float64 `json:"total_price"`
			BookingReference string  `json:"booking_reference"`
			User             struct {
				FullName string `json:"full_name"`
			} `json:"user"`
			Schedule struct {
				StartTime string `json:"start_time"`
				Movie     struct {
					Title string `json:"title"`
				} `json:"movie"`
			} `json:"schedule"`
			BookingSeats []struct {
				SeatID string `json:"seat_id"`
			} `json:"booking_seats"`
		} `json:"bookings"`
	}
	if err := hasuraGraphQL(query, variables, &resp); err != nil {
		return bookingRecord{}, err
	}
	if len(resp.Bookings) == 0 {
		return bookingRecord{}, fmt.Errorf("booking not found")
	}

	b := resp.Bookings[0]
	seats := make([]string, 0, len(b.BookingSeats))
	for _, s := range b.BookingSeats {
		seats = append(seats, s.SeatID)
	}
	return bookingRecord{
		PaymentStatus:    b.PaymentStatus,
		TotalPrice:       b.TotalPrice,
		BookingReference: b.BookingReference,
		FullName:         b.User.FullName,
		MovieTitle:       b.Schedule.Movie.Title,
		StartTime:        b.Schedule.StartTime,
		Seats:            seats,
	}, nil
}

func markBookingCompleted(txRef string) error {
	const mutation = `
		mutation CompleteBooking($tx_ref: String!) {
			update_bookings(
				where: {tx_ref: {_eq: $tx_ref}, payment_status: {_eq: "pending"}},
				_set: {payment_status: "completed"}
			) { affected_rows }
		}`
	variables := map[string]interface{}{"tx_ref": txRef}
	return hasuraGraphQL(mutation, variables, nil)
}
