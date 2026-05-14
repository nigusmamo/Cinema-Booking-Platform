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