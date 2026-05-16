export const GET_HOME_PAGE_DATA = gql`
  query GetHomePageData {
    movies(order_by: {created_at: desc}) {
      id
      title
      main_image
      duration_minutes
      rating_avg
      movie_directors {
        director {
          id
          name
        }
      }
      movie_genres {
        genre {
          id
          name
        }
      }
    }
    genres {
      id
      name
    }
    directors {
      id
      name
    }
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
      movie_images {
        id
        image_url
      }
      movie_directors {
        director {
          name
        }
      }
      movie_stars {
        star {
          name
        }
      }
      movie_genres {
        genre {
          name
        }
      }
    }
  }
`;

export const GET_MOVIE_SCHEDULES = gql`
  query GetMovieSchedules {
    movies(order_by: {created_at: desc}) {
      id
      title
      description
      main_image
      duration_minutes
      rating_avg
      movie_genres {
        genre {
          name
        }
      }
    }
  }
`;