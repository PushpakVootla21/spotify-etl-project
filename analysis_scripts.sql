-- 1. Top Artists: Who are the most featured artists in the playlist(s)?
SELECT artist_name, COUNT(*) AS track_count
FROM artist_data
GROUP BY artist_name
ORDER BY track_count DESC
LIMIT 10;

-- 2. Popular Songs: Which songs have the highest popularity scores?
SELECT song_name, MAX(song_popularity) AS max_popularity
FROM songs_data
GROUP BY song_name
ORDER BY max_popularity DESC
LIMIT 10;

-- 3. Album Trends: Which albums have the most tracks in the playlist(s)?
SELECT album_name, COUNT(*) AS track_count
FROM album_data
GROUP BY album_name
ORDER BY track_count DESC
LIMIT 10;

-- 4. Release Date Analysis: What is the distribution of song release years?
SELECT year(album_release_date) AS release_year, COUNT(*) AS song_count
FROM album_data
GROUP BY year(album_release_date)
ORDER BY release_year;

-- 5. Playlist Freshness: How many songs were added in the last month?
SELECT COUNT(*) AS songs_added_last_month
FROM songs_data
WHERE song_added >= date_trunc('month', current_date) - interval '1' month;

-- 6. Artist Diversity: How many unique artists are represented?
SELECT COUNT(DISTINCT artist_id) AS unique_artists
FROM artist_data;

-- 7. Song Duration: What is the average, shortest, and longest song duration in Mins?
SELECT 
  AVG(song_duration)/(60*60) AS avg_duration_min,
  MIN(song_duration)/(60*60) AS min_duration_min,
  MAX(song_duration)/(60*60) AS max_duration_min
FROM songs_data;

-- 8. Popularity by Artist: Which artists have the highest average song popularity?
SELECT a.artist_name, AVG(s.song_popularity) AS avg_popularity
FROM songs_data s
JOIN artist_data a ON s.artist_id = a.artist_id
GROUP BY a.artist_name
ORDER BY avg_popularity DESC
LIMIT 10;

-- 9. Recent Releases: Which songs were released in the last year?
SELECT s.song_name, a.album_release_date
FROM songs_data s
JOIN album_data a ON s.album_id = a.album_id
WHERE a.album_release_date >= date_add('year', -1, current_date);

-- 10. Most Added Albums: Which albums have the most songs added recently?
SELECT a.album_id, a.album_name, COUNT(*) AS songs_added
FROM album_data a
JOIN songs_data s
ON a.album_id = s.album_id
WHERE song_added >= date_trunc('month', current_date) - interval '1' month
GROUP BY a.album_id, a.album_name
ORDER BY songs_added DESC
LIMIT 10;
