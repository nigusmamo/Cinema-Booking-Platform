import { gql } from '#imports'

export const GET_ADMIN_DASHBOARD = gql`
  query GetAdminDashboard {
    movies_aggregate { aggregate { count } }
    bookings_aggregate { aggregate { count sum { total_price } } }
    schedules_aggregate { aggregate { count } }
    users_aggregate { aggregate { count } }
    movies(order_by: {created_at: desc}, limit: 6) {
      id
      title
      main_image
      duration_minutes
      rating_avg
      status
      created_at
      movie_genres { genre { name } }
      schedules_aggregate { aggregate { count } }
    }
  }
`;

export const GET_ADMIN_MOVIES = gql`
  query GetAdminMovies {
    movies(order_by: {created_at: desc}) {
      id
      title
      main_image
      duration_minutes
      rating_avg
      status
      created_at
      movie_directors { director { id name } }
      movie_genres { genre { id name } }
      movie_stars { star { id name } }
      movie_images { id image_url }
      schedules { id start_time end_time }
    }
  }
`;

export const GET_ADMIN_FORM_DATA = gql`
  query GetAdminFormData {
    directors(order_by: {name: asc}) { id name image_url }
    stars(order_by: {name: asc}) { id name image_url }
    genres(order_by: {name: asc}) { id name }
    movies(order_by: {title: asc}) { id title }
  }
`;

export const GET_ADMIN_SCHEDULES = gql`
  query GetAdminSchedules {
    schedules(order_by: {start_time: asc}) {
      id
      start_time
      end_time
      movie { id title main_image duration_minutes }
    }
  }
`;

export const INSERT_MOVIE = gql`
  mutation InsertMovie($object: movies_insert_input!) {
    insert_movies_one(object: $object) { id }
  }
`;

export const UPDATE_MOVIE = gql`
  mutation UpdateMovie($id: uuid!, $set: movies_set_input!) {
    update_movies_by_pk(pk_columns: {id: $id}, _set: $set) { id }
  }
`;

export const DELETE_MOVIE = gql`
  mutation DeleteMovie($id: uuid!) {
    delete_movies_by_pk(id: $id) { id }
  }
`;

export const INSERT_DIRECTOR = gql`
  mutation InsertDirector($name: String!, $image_url: String) {
    insert_directors_one(object: {name: $name, image_url: $image_url}) { id name }
  }
`;

export const UPDATE_DIRECTOR = gql`
  mutation UpdateDirector($id: uuid!, $name: String!, $image_url: String) {
    update_directors_by_pk(pk_columns: {id: $id}, _set: {name: $name, image_url: $image_url}) { id }
  }
`;

export const DELETE_DIRECTOR = gql`
  mutation DeleteDirector($id: uuid!) {
    delete_directors_by_pk(id: $id) { id }
  }
`;

export const INSERT_STAR = gql`
  mutation InsertStar($name: String!, $image_url: String) {
    insert_stars_one(object: {name: $name, image_url: $image_url}) { id name }
  }
`;

export const UPDATE_STAR = gql`
  mutation UpdateStar($id: uuid!, $name: String!, $image_url: String) {
    update_stars_by_pk(pk_columns: {id: $id}, _set: {name: $name, image_url: $image_url}) { id }
  }
`;

export const DELETE_STAR = gql`
  mutation DeleteStar($id: uuid!) {
    delete_stars_by_pk(id: $id) { id }
  }
`;

export const INSERT_SCHEDULE = gql`
  mutation InsertSchedule($object: schedules_insert_input!) {
    insert_schedules_one(object: $object) { id }
  }
`;

export const UPDATE_SCHEDULE = gql`
  mutation UpdateSchedule($id: uuid!, $set: schedules_set_input!) {
    update_schedules_by_pk(pk_columns: {id: $id}, _set: $set) { id }
  }
`;

export const DELETE_SCHEDULE = gql`
  mutation DeleteSchedule($id: uuid!) {
    delete_schedules_by_pk(id: $id) { id }
  }
`;

export const INSERT_MOVIE_GENRES = gql`
  mutation InsertMovieGenres($objects: [movie_genres_insert_input!]!) {
    insert_movie_genres(objects: $objects) { affected_rows }
  }
`;

export const DELETE_MOVIE_GENRES = gql`
  mutation DeleteMovieGenres($movie_id: uuid!) {
    delete_movie_genres(where: {movie_id: {_eq: $movie_id}}) { affected_rows }
  }
`;

export const INSERT_MOVIE_DIRECTORS = gql`
  mutation InsertMovieDirectors($objects: [movie_directors_insert_input!]!) {
    insert_movie_directors(objects: $objects) { affected_rows }
  }
`;

export const DELETE_MOVIE_DIRECTORS = gql`
  mutation DeleteMovieDirectors($movie_id: uuid!) {
    delete_movie_directors(where: {movie_id: {_eq: $movie_id}}) { affected_rows }
  }
`;

export const INSERT_MOVIE_STARS = gql`
  mutation InsertMovieStars($objects: [movie_stars_insert_input!]!) {
    insert_movie_stars(objects: $objects) { affected_rows }
  }
`;

export const DELETE_MOVIE_STARS = gql`
  mutation DeleteMovieStars($movie_id: uuid!) {
    delete_movie_stars(where: {movie_id: {_eq: $movie_id}}) { affected_rows }
  }
`;

export const INSERT_MOVIE_IMAGES = gql`
  mutation InsertMovieImages($objects: [movie_images_insert_input!]!) {
    insert_movie_images(objects: $objects) { affected_rows }
  }
`;

export const DELETE_MOVIE_IMAGES = gql`
  mutation DeleteMovieImages($movie_id: uuid!) {
    delete_movie_images(where: {movie_id: {_eq: $movie_id}}) { affected_rows }
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

export const UPDATE_SEAT_PRICE = gql`
  mutation UpdateSeatPrice($type: String!, $price: numeric!) {
    update_seat_prices_by_pk(
      pk_columns: { type: $type }
      _set: { price: $price }
    ) {
      type
      price
    }
  }
`;

export const UPLOAD_FILE = gql`
  mutation UploadFile($base64_data: String!, $filename: String!) {
    upload_file(base64_data: $base64_data, filename: $filename) {
      url
    }
  }
`;

export const GET_MOVIE_BY_ID = gql`
  query GetMovieById($id: uuid!) {
    movies_by_pk(id: $id) {
      id title description main_image duration_minutes release_date status rating_avg
      movie_directors { director { id name } }
      movie_stars { star { id name } }
      movie_genres { genre { id name } }
      movie_images { id image_url }
    }
  }
`;

export const DELETE_MOVIE_IMAGE_BY_ID = gql`
  mutation DeleteMovieImageById($id: uuid!) {
    delete_movie_images_by_pk(id: $id) { id }
  }
`;
