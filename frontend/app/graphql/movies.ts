import { gql } from '#imports'

export const GET_HOME_PAGE_DATA = gql`
  query GetHomePageData {
    movies(order_by: {created_at: desc}) {
      id
      title
      main_image
      duration_minutes
      rating_avg
      movie_directors { director { id name } }
      movie_genres { genre { id name } }
      schedules {
        start_time
      }
    }
    genres { id name }
    directors { id name }
  }
`;

export const GET_MOVIE_DETAILS = gql`
  query GetMovieDetails($id: uuid!) {
    movies_by_pk(id: $id) {
      id
      title
      description
      main_image
      duration_minutes
      rating_avg
      release_date
      status
      movie_images { id image_url }
      movie_directors { director { name image_url } }
      movie_stars { star { name image_url } }
      movie_genres { genre { name } }
      schedules {
        id
        start_time
      }
    }
  }
`;

export const GET_MOVIE_SCHEDULES = gql`
  query GetMovieSchedules {
    movies {
      id
      title
      main_image
      description
      duration_minutes
      rating_avg
      movie_genres {
        genre { name }
      }
      schedules {
        id
        start_time
      }
    }
  }
`;

export const GET_SCHEDULE_SEATS = gql`
  query GetScheduleSeats($schedule_id: uuid!) {
    schedules_by_pk(id: $schedule_id) {
      id
      movie {
        id
        title
        main_image
        duration_minutes
      }
      bookings {
        booking_seats {
          seat_id
        }
      }
    }
  }
`;

export const GET_SEAT_PRICES = gql`
  query GetSeatPrices {
    seat_prices {
      type
      price
    }
  }
`;

export const GET_BOOKED_SEATS = gql`
  query GetBookedSeats($schedule_id: uuid!) {
    booking_seats(where: { 
      booking: { 
        schedule_id: { _eq: $schedule_id }, 
        payment_status: { _eq: "completed" } 
      } 
    }) {
      seat_id
    }
  }
`;


export const INITIATE_PAYMENT = gql`
  mutation InitiatePayment($amount: String!, $email: String!, $first_name: String!, $last_name: String!) {
    pay(amount: $amount, email: $email, first_name: $first_name, last_name: $last_name) {
      checkout_url
      tx_ref
    }
  }
`;

export const CREATE_BOOKING = gql`
  mutation CreateBooking($object: bookings_insert_input!) {
    insert_bookings_one(object: $object) {
      id
      booking_reference
    }
  }
`;

export const GET_ME = gql`
  query GetMe {
    users {
      id
      full_name
      email
    }
  }
`;