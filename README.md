# Spotify SQL Analysis 🎵

## 📌 Project Overview

This project uses **PostgreSQL** to analyse a Spotify dataset and answer different business and music-related questions using SQL.

The project covers data cleaning, aggregation, filtering, subqueries, CTEs and window functions.

## 📂 Files

* `Spotify_SQL_query.sql` – SQL queries used for data analysis
* `cleaned_dataset.csv` – Cleaned Spotify dataset

## 🛠️ Tools Used

* PostgreSQL
* SQL
* GitHub

## 🧹 Data Cleaning

Removed tracks where the duration was 0 minutes.

```sql
DELETE FROM spotify 
WHERE duration_min = 0;
```

## 📊 SQL Questions

### Easy SQL Questions

**1. Retrieve the names of all tracks that have more than 1 billion streams**

```sql
SELECT track 
FROM spotify
WHERE stream > 1000000000;
```

**2. List all albums along with their respectives artists.**

```sql
SELECT DISTINCT album, artist 
FROM spotify;
```

**3. Get the total numbers of comments for the tracks where licensed = True**

```sql
SELECT SUM(comments) AS total_comments 
FROM spotify 
WHERE licensed = 'true';
```

**4. Find all tracks that belong to the album type single.**

```sql
SELECT track 
FROM spotify
WHERE album_type = 'single';
```

**5. Count the total number of tracks by each artist.**

```sql
SELECT artist, COUNT(*)
FROM spotify
GROUP BY artist;
```

**6. Calculate the average danceability of tracks in each album.**

```sql
SELECT album,
       AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;
```

**7. Find the top 5 tracks with the highest energy values.**

```sql
SELECT track, energy 
FROM spotify
ORDER BY energy DESC
LIMIT 5;
```

**8. List all the tracks along their views and likes where official_video = True.**

```sql
SELECT track, 
       SUM(views) AS total_views,
       SUM(likes) AS total_likes
FROM spotify 
WHERE official_video = 'true'
GROUP BY track
ORDER BY total_views DESC;
```

**9. For each album, calculate the total views of all associated tracks.**

```sql
SELECT album, track,
       SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY total_views DESC;
```

**10. Retrieve the track names that have been streamed on Spotify more than YouTube.**

```sql
SELECT *
FROM (
    SELECT 
        track,
        COALESCE(SUM(CASE 
            WHEN most_playedon = 'Youtube' THEN stream 
        END), 0) AS streamed_on_youtube,
        COALESCE(SUM(CASE 
            WHEN most_playedon = 'Spotify' THEN stream 
        END), 0) AS streamed_on_spotify
    FROM spotify
    GROUP BY track
) AS t1
WHERE streamed_on_spotify > streamed_on_youtube
AND streamed_on_youtube <> 0;
```

### Advanced SQL

**11. Find the top 3 most-viewed tracks for each artist using window functions.**

```sql
WITH ranking_artist AS (
    SELECT 
        artist,
        track,
        SUM(views) AS total_views,
        DENSE_RANK() OVER(
            PARTITION BY artist 
            ORDER BY SUM(views) DESC
        ) AS rank
    FROM spotify
    GROUP BY artist, track
)

SELECT *
FROM ranking_artist
WHERE rank <= 3;
```

**12. Write a query to find tracks where the liveness score is above the average.**

```sql
SELECT track, liveness 
FROM spotify
WHERE liveness > (
    SELECT AVG(liveness) 
    FROM spotify
)
ORDER BY liveness DESC;
```

**13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.**

```sql
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
```

## 🧠 SQL Concepts Used

* SELECT
* WHERE
* DISTINCT
* GROUP BY
* ORDER BY
* LIMIT
* Aggregate Functions
* CASE WHEN
* COALESCE
* Subqueries
* CTE (WITH)
* Window Functions
* DENSE_RANK
* MAX / MIN / AVG / SUM / COUNT

## 🎯 Key Learning

This project helped me practise SQL for **data cleaning, exploratory analysis and extracting meaningful insights from a real-world music dataset**.

---

### 👤 Author

**Ajay**

Business Analytics | SQL | Power BI | Python | Machine Learning
