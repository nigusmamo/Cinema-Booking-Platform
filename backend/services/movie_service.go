package services

import (
	"context"

	"github.com/nigusmamo/Cinema-Booking-Platform/models"
	"github.com/nigusmamo/Cinema-Booking-Platform/utils"
)

func CreateFullMovie(req models.CreateMovieRequest) (string, error) {
	tx, err := utils.DB.BeginTx(context.Background(), nil)
	if err != nil {
		return "", err
	}
	defer tx.Rollback()

	var movieID string
	query := `INSERT INTO movies (title, description, main_image, duration_minutes, release_date) 
			  VALUES ($1, $2, $3, $4, $5) RETURNING id`
	err = tx.QueryRow(query, req.Title, req.Description, req.MainImage, req.DurationMinutes, req.ReleaseDate).Scan(&movieID)
	if err != nil {
		return "", err
	}

	for _, genreName := range req.GenreNames {
		var genreID string
		tx.QueryRow(`INSERT INTO genres (name) VALUES ($1) ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name RETURNING id`, genreName).Scan(&genreID)
		tx.Exec(`INSERT INTO movie_genres (movie_id, genre_id) VALUES ($1, $2)`, movieID, genreID)
	}

	for _, dirName := range req.DirectorNames {
		var dirID string
		tx.QueryRow(`INSERT INTO directors (name) VALUES ($1) ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name RETURNING id`, dirName).Scan(&dirID)
		tx.Exec(`INSERT INTO movie_directors (movie_id, director_id) VALUES ($1, $2)`, movieID, dirID)
	}

	for _, imgURL := range req.GalleryImages {
		tx.Exec(`INSERT INTO movie_images (movie_id, image_url) VALUES ($1, $2)`, movieID, imgURL)
	}

	err = tx.Commit()
	return movieID, err
}
