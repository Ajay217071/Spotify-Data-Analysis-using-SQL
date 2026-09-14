-- Advanced SQL Project -- Spotify Datasets
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify(
artist VARCHAR (256),
track VARCHAR (256),
album VARCHAR (256),
album_type VARCHAR (50),
danceability FLOAT,
energy FLOAT,
loudness FLOAT,
speechness FLOAT,
acousticness FLOAT,
instrumentalness FLOAT,
liveness FLOAT,
valence FLOAT,
tempo FLOAT,
duration_min FLOAT,
title VARCHAR(256),
channel VARCHAR(256),
views BIGINT,
likes BIGINT,
comments BIGINT,
licensed BOOLEAN,
official_video BOOLEAN,
stream BIGINT,
energy_liveness FLOAT,
most_playedon VARCHAR(50));


--EDA--
SELECT * FROM spotify;

SELECT duration_min from spotify
WHERE duration_min =0;

-- delete these two songs with 0 duration---
DELETE FROM spotify 
WHERE duration_min = 0;

--------------data analysis easy category------------
/*1. Retrieve the names of all tracks that have more than 1 billion streams*/
SELECT track from spotify
WHERE stream > 1000000000;

/* 2. List all albums along with their respectives artists.*/
SELECT DISTINCT album, artist FROM spotify;

/* 3. Get the total numbers of comments for the tracks where licensed = True*/
SELECT 
sum (comments) as total_cooments from spotify 
WHERE licensed = 'true';

/* 4.Find all tracks that belong to the album type single. */
SELECT track FROM spotify
WHERE album_type = 'single';

/* 5. Count the total number of tracks by each artist. */
SELECT artist, 
COUNT(*) from spotify
GROUP BY artist

/* 6. Calculate the average danceability of tracks in each album.*/

SELECT album,
       avg(danceability) as avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC


/* 7.  Find the top 5 tracks with the highest energy values. */

SELECT track, energy 
FROM spotify
ORDER BY 2 desc
limit 5 

/* 8. List all the tracks along their views and likes where official_video = True. */
SELECT track, 
sum(views) as total_views,
sum(likes) as total_likes
from spotify 
where official_video = 'true'
group by 1
order by 2 desc

/* 9. For each album, calculate the total views of all associated tracks. */
select album, track,
sum(views) as total_views
from spotify
group by 1,2
order by 3 desc

/* 10. Retrieve the track names that have been streamed on spotify more than youtube. */

SELECT *
FROM (
    SELECT 
        track,
        COALESCE(SUM(CASE WHEN most_playedon = 'Youtube' THEN stream END), 0) AS streamed_on_youtube,
        COALESCE(SUM(CASE WHEN most_playedon = 'Spotify' THEN stream END), 0) AS streamed_on_spotify
    FROM spotify
    GROUP BY 1
) AS t1
WHERE 
     streamed_on_spotify > streamed_on_youtube
   AND
   streamed_on_youtube <>0;

/* 11. Find the top 3 most-viewed tracks for each artist using window functions. */

WITH ranking_artist 
AS
(SELECT artist,track, SUM(views) as total_views,
DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC)

SELECT * FROM ranking_artist
WHERE rank <=3

/* 12. Write a query to find tracks where the liveness score is above the average.*/

 SELECT track, liveness FROM Spotify
 WHERE liveness > (SELECT avg(liveness) FROM spotify)
 ORDER BY liveness DESC

/* 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album. */

WITH cte AS (
    SELECT 
        album,
        MAX(energy) AS maximum_energy,
        MIN(energy) AS minimum_energy
    FROM spotify
    GROUP BY album
)
SELECT 
    album,
    maximum_energy - minimum_energy AS energy_diff
FROM cte
ORDER BY energy_diff DESC;








