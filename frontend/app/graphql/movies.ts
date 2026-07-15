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
      schedules { id start_time }
      ratings(order_by: { created_at: desc }, limit: 20) {
        id
        rating_value
        comment
        created_at
        user_id
      }
    }
  }
`;

export const GET_USER_BOOKMARK = gql`
  query GetUserBookmark($movie_id: uuid!, $user_id: uuid!) {
    bookmarks(where: { movie_id: { _eq: $movie_id }, user_id: { _eq: $user_id } }) {
      id
    }
  }
`;

export const INSERT_BOOKMARK = gql`
  mutation InsertBookmark($movie_id: uuid!) {
    insert_bookmarks_one(object: { movie_id: $movie_id }) { id }
  }
`;

export const DELETE_BOOKMARK = gql`
  mutation DeleteBookmark($id: uuid!) {
    delete_bookmarks_by_pk(id: $id) { id }
  }
`;

export const GET_USER_RATING = gql`
  query GetUserRating($movie_id: uuid!, $user_id: uuid!) {
    ratings(where: { movie_id: { _eq: $movie_id }, user_id: { _eq: $user_id } }) {
      id rating_value comment
    }
  }
`;

export const INSERT_RATING = gql`
  mutation InsertRating($movie_id: uuid!, $rating_value: Int!, $comment: String) {
    insert_ratings_one(object: { movie_id: $movie_id, rating_value: $rating_value, comment: $comment }) { id }
  }
`;

export const UPDATE_RATING = gql`
  mutation UpdateRating($id: uuid!, $rating_value: Int!, $comment: String) {
    update_ratings_by_pk(pk_columns: { id: $id }, _set: { rating_value: $rating_value, comment: $comment }) { id }
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
    booked_seats(where: { schedule_id: { _eq: $schedule_id } }) {
      seat_id
    }
  }
`;


export const INITIATE_PAYMENT = gql`
  mutation InitiatePayment($schedule_id: String!, $seat_ids: [String!]!, $email: String!, $first_name: String!, $last_name: String!) {
    pay(schedule_id: $schedule_id, seat_ids: $seat_ids, email: $email, first_name: $first_name, last_name: $last_name) {
      checkout_url
      tx_ref
    }
  }
`;

export const VERIFY_PAYMENT = gql`
  mutation VerifyPayment($tx_ref: String!) {
    verify_payment(tx_ref: $tx_ref) {
      status
      booking_reference
      total_price
      movie_title
      start_time
      full_name
      seats
    }
  }
`;

export const GET_MY_PROFILE = gql`
  query GetMyProfile {
    users {
      id
      full_name
      email
      role
      created_at
      bookings(order_by: { created_at: desc }) {
        id
        booking_reference
        total_price
        payment_status
        created_at
        schedule {
          start_time
          end_time
          movie { id title main_image duration_minutes }
        }
        booking_seats { seat_id }
      }
      bookmarks(order_by: { id: desc }) {
        id
        movie { id title main_image duration_minutes rating_avg }
      }
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