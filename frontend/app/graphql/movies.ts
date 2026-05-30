import { gql } from '#imports'

export const GET_HOME_PAGE_DATA = gql`
  query GetHomePageData {
    movies(order_by: {created_at: desc}) {
      id
      title
      main_image
      duration_minutes
      rating_avg
      movie_directors { director { name } }
      movie_genres { genre { name } }
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
      movie_directors { director { name } }
      movie_stars { star { name } }
      movie_genres { genre { name } }
      schedules {
        id
        start_time
        price
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