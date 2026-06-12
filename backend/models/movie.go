package models

// CreateMovieRequest
type CreateMovieRequest struct {
	Title           string   `json:"title"`
	Description     string   `json:"description"`
	MainImage       string   `json:"main_image"`
	DurationMinutes int      `json:"duration_minutes"`
	ReleaseDate     string   `json:"release_date"`
	GenreNames      []string `json:"genre_names"`
	DirectorNames   []string `json:"director_names"`
	StarNames       []string `json:"star_names"`
	GalleryImages   []string `json:"gallery_images"`
}

// MovieResponse
type MovieResponse struct {
	ID    string `json:"id"`
	Title string `json:"title"`
}
