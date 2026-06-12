-- Seed Genres
INSERT INTO public.genres (name) VALUES 
    ('Action'), ('Drama'), ('Sci-Fi'), ('Crime'), ('Thriller'), ('Adventure'), ('Romance'), ('Biography'), ('Mystery')
ON CONFLICT (name) DO NOTHING;

-- Seed Directors
INSERT INTO public.directors (name, image_url) VALUES 
    ('Christopher Nolan', 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=200'),
    ('Ridley Scott', 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=200'),
    ('Quentin Tarantino', 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&q=80&w=200'),
    ('Francis Ford Coppola', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=200'),
    ('James Cameron', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=200'),
    ('Martin Scorsese', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200'),
    ('Frank Darabont', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200'),
    ('Bong Joon-ho', 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&q=80&w=200'),
    ('Anthony Russo', 'https://images.unsplash.com/photo-1463453091185-61582044d556?auto=format&fit=crop&q=80&w=200'),
    ('Todd Phillips', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200'),
    ('Jon Watts', 'https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?auto=format&fit=crop&q=80&w=200'),
    ('Denis Villeneuve', 'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?auto=format&fit=crop&q=80&w=200'),
    ('George Miller', 'https://images.unsplash.com/photo-1513910367299-bce8d8a0ebf6?auto=format&fit=crop&q=80&w=200'),
    ('Chad Stahelski', 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&q=80&w=200')
ON CONFLICT (name) DO NOTHING;

-- Seed Stars
INSERT INTO public.stars (name, image_url) VALUES 
    ('Christian Bale', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200'),
    ('Heath Ledger', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200'),
    ('Leonardo DiCaprio', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&q=80&w=200'),
    ('Russell Crowe', 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&q=80&w=200'),
    ('Matthew McConaughey', 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&q=80&w=200'),
    ('John Travolta', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200'),
    ('Marlon Brando', 'https://images.unsplash.com/photo-1463453091185-61582044d556?auto=format&fit=crop&q=80&w=200'),
    ('Keanu Reeves', 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&q=80&w=200'),
    ('Song Kang-ho', 'https://images.unsplash.com/photo-1513910367299-bce8d8a0ebf6?auto=format&fit=crop&q=80&w=200'),
    ('Tim Robbins', 'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?auto=format&fit=crop&q=80&w=200'),
    ('Robert Downey Jr.', 'https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?auto=format&fit=crop&q=80&w=200'),
    ('Joaquin Phoenix', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200'),
    ('Kate Winslet', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=200'),
    ('Tom Holland', 'https://images.unsplash.com/photo-1488161628813-244768e7f600?auto=format&fit=crop&q=80&w=200'),
    ('Timothée Chalamet', 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&q=80&w=200'),
    ('Cillian Murphy', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&q=80&w=200'),
    ('Tom Hardy', 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&q=80&w=200'),
    ('Zoe Saldana', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200')
ON CONFLICT (name) DO NOTHING;

-- Function to link movies, directors, stars and genres
DO $$
DECLARE
    m_id UUID;
    d_id UUID;
    s1_id UUID;
    s2_id UUID;
    g_id UUID;
BEGIN
    -- 1. The Dark Knight
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'The Dark Knight') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'The Dark Knight', 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.', '/uploads/batman_1781000037645548000.jpeg', '2008-07-18', 152, 9.0, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Christopher Nolan' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Christian Bale' LIMIT 1;
        SELECT id INTO s2_id FROM public.stars WHERE name = 'Heath Ledger' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id), (m_id, s2_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Action' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 2. Inception
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Inception') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Inception', 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.', 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?auto=format&fit=crop&q=80&w=800', '2010-07-16', 148, 8.8, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Christopher Nolan' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Leonardo DiCaprio' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Sci-Fi' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 3. Gladiator
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Gladiator') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Gladiator', 'A former Roman General sets out to exact vengeance against the corrupt emperor who murdered his family and sent him into slavery.', '/uploads/gladiator_1781000055370470000.jpeg', '2000-05-05', 155, 8.5, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Ridley Scott' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Russell Crowe' LIMIT 1;
        SELECT id INTO s2_id FROM public.stars WHERE name = 'Joaquin Phoenix' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id), (m_id, s2_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Action' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 4. Interstellar
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Interstellar') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Interstellar', 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity survival.', 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?auto=format&fit=crop&q=80&w=800', '2014-11-07', 169, 8.7, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Christopher Nolan' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Matthew McConaughey' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Sci-Fi' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 5. Pulp Fiction
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Pulp Fiction') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Pulp Fiction', 'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.', 'https://images.unsplash.com/photo-1594908900066-3f47337549d8?auto=format&fit=crop&q=80&w=800', '1994-10-14', 154, 8.9, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Quentin Tarantino' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'John Travolta' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Crime' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 6. The Godfather
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'The Godfather') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'The Godfather', 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.', 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?auto=format&fit=crop&q=80&w=800', '1972-03-24', 175, 9.2, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Francis Ford Coppola' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Marlon Brando' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Crime' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 7. The Matrix
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'The Matrix') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'The Matrix', 'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.', 'https://images.unsplash.com/photo-1533035353720-f1c6a75cd8ab?auto=format&fit=crop&q=80&w=800', '1999-03-31', 136, 8.7, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'James Cameron' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Keanu Reeves' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Sci-Fi' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 8. Parasite
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Parasite') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Parasite', 'Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.', 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?auto=format&fit=crop&q=80&w=800', '2019-05-30', 132, 8.5, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Bong Joon-ho' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Song Kang-ho' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Thriller' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 9. The Shawshank Redemption
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'The Shawshank Redemption') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'The Shawshank Redemption', 'Over the course of several years, two convicts form a friendship, seeking consolation and, eventually, redemption through basic compassion.', '/uploads/prison_1781001116225919000.jpg', '1994-09-22', 142, 9.3, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Frank Darabont' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Tim Robbins' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Drama' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 10. Avengers: Endgame
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Avengers: Endgame') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Avengers: Endgame', 'After the devastating events of Infinity War, the universe is in ruins. With the help of remaining allies, the Avengers assemble once more in order to restore balance to the universe.', 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&q=80&w=800', '2019-04-26', 181, 8.4, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Anthony Russo' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Robert Downey Jr.' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Action' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 11. Joker
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Joker') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Joker', 'In Gotham City, mentally troubled comedian Arthur Fleck is disregarded and mistreated by society. He then embarks on a downward spiral of revolution and bloody crime.', 'https://images.unsplash.com/photo-1531259683007-016a7b628fc3?auto=format&fit=crop&q=80&w=800', '2019-10-04', 122, 8.4, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Todd Phillips' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Joaquin Phoenix' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Crime' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 12. Titanic
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Titanic') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Titanic', 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.', 'https://images.unsplash.com/photo-1500077423678-25eead48513a?auto=format&fit=crop&q=80&w=800', '1997-12-19', 194, 7.9, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'James Cameron' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Leonardo DiCaprio' LIMIT 1;
        SELECT id INTO s2_id FROM public.stars WHERE name = 'Kate Winslet' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id), (m_id, s2_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Romance' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 13. Spider-Man: No Way Home
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Spider-Man: No Way Home') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Spider-Man: No Way Home', 'With Spider-Mans identity now revealed, Peter asks Doctor Strange for help. When a spell goes wrong, dangerous foes from other worlds start to appear.', 'https://images.unsplash.com/photo-1635805737707-575885ab0820?auto=format&fit=crop&q=80&w=800', '2021-12-17', 148, 8.2, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Jon Watts' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Tom Holland' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Action' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 14. Dune
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Dune') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Dune', 'A noble family becomes embroiled in a war for control over the galaxys most valuable asset while its heir becomes troubled by visions of a dark future.', 'https://images.unsplash.com/photo-1614850523296-d8c1af93d400?auto=format&fit=crop&q=80&w=800', '2021-10-22', 155, 8.0, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Denis Villeneuve' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Timothée Chalamet' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Sci-Fi' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 15. Oppenheimer
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Oppenheimer') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Oppenheimer', 'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb.', 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?auto=format&fit=crop&q=80&w=800', '2023-07-21', 180, 8.5, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Christopher Nolan' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Cillian Murphy' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Biography' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 16. The Wolf of Wall Street
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'The Wolf of Wall Street') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'The Wolf of Wall Street', 'Based on the true story of Jordan Belfort, from his rise to a wealthy stock-broker living the high life to his fall involving crime, corruption and the federal government.', 'https://images.unsplash.com/photo-1611974762655-849c177e76a1?auto=format&fit=crop&q=80&w=800', '2013-12-25', 180, 8.2, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Martin Scorsese' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Leonardo DiCaprio' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Biography' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 17. Mad Max: Fury Road
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Mad Max: Fury Road') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Mad Max: Fury Road', 'In a post-apocalyptic wasteland, a woman rebels against a tyrannical ruler in search for her homeland with the help of a group of female prisoners, a psychotic worshiper, and a drifter named Max.', 'https://images.unsplash.com/photo-1509343256512-d77a5cb3791b?auto=format&fit=crop&q=80&w=800', '2015-05-15', 120, 8.1, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'George Miller' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Tom Hardy' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Action' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 18. John Wick
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'John Wick') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'John Wick', 'An ex-hit-man comes out of retirement to track down the gangsters that killed his dog and took everything from him.', 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?auto=format&fit=crop&q=80&w=800', '2014-10-24', 101, 7.4, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Chad Stahelski' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Keanu Reeves' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Action' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 19. Shutter Island
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Shutter Island') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Shutter Island', 'Teddy Daniels and Chuck Aule, two US marshals, are sent to an asylum on a remote island in order to investigate the disappearance of a patient, where Teddy uncovers a shocking truth about the place.', 'https://images.unsplash.com/photo-1477346611705-65d1883cee1e?auto=format&fit=crop&q=80&w=800', '2010-02-19', 138, 8.2, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'Martin Scorsese' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Leonardo DiCaprio' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Mystery' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

    -- 20. Avatar
    IF NOT EXISTS (SELECT 1 FROM public.movies WHERE title = 'Avatar') THEN
        m_id := gen_random_uuid();
        INSERT INTO public.movies (id, title, description, main_image, release_date, duration_minutes, rating_avg, status)
        VALUES (m_id, 'Avatar', 'A paraplegic Marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.', 'https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&q=80&w=800', '2009-12-18', 162, 7.9, 'now_showing');
        
        SELECT id INTO d_id FROM public.directors WHERE name = 'James Cameron' LIMIT 1;
        INSERT INTO public.movie_directors (movie_id, director_id) VALUES (m_id, d_id);
        
        SELECT id INTO s1_id FROM public.stars WHERE name = 'Zoe Saldana' LIMIT 1;
        INSERT INTO public.movie_stars (movie_id, star_id) VALUES (m_id, s1_id);
        
        SELECT id INTO g_id FROM public.genres WHERE name = 'Sci-Fi' LIMIT 1;
        INSERT INTO public.movie_genres (movie_id, genre_id) VALUES (m_id, g_id);
    END IF;

END $$;
