CREATE DATABASE nba ;

USE nba;
show databases;

select *from game;

select  game_date,team_name_home,team_name_away,wl_home,wl_away from game
order by game_date desc; 

SELECT
    team_name_home AS team_name,
    COUNT(*) AS WINS
FROM game
WHERE wl_home = 'W'
GROUP BY team_name_home

UNION ALL

SELECT
    team_name_away AS team_name,
    COUNT(*) AS WINS
FROM game
WHERE wl_away = 'W'
GROUP BY team_name_away

ORDER BY team_name ASC;




SELECT 
    team_name,
    SUM(WINS) AS WINS,
    SUM(LOSSES) AS LOSSES
FROM (
    SELECT
        team_name_home AS team_name,
        SUM(CASE WHEN Wl_home = 'W' THEN 1 ELSE 0 END) AS WINS,
        SUM(CASE WHEN Wl_home = 'L' THEN 1 ELSE 0 END) AS LOSSES
    FROM game
    GROUP BY team_name_home

    UNION ALL

    SELECT
        team_name_away AS team_name,
        SUM(CASE WHEN Wl_away = 'W' THEN 1 ELSE 0 END) AS WINS,
        SUM(CASE WHEN Wl_away = 'L' THEN 1 ELSE 0 END) AS LOSSES
    FROM game
    GROUP BY team_name_away
) AS combined
GROUP BY team_name
ORDER BY WINS ASC;

WITH season_record AS (
    SELECT
        season,
        season_type,
        team_name,
        SUM(WINS) AS WINS,
        SUM(LOSSES) AS LOSSES
    FROM (
        SELECT
            SUBSTR(season_id, 2, 4) AS season,
            season_type,
            team_name_home AS team_name,
            SUM(CASE WHEN Wl_home = 'W' THEN 1 ELSE 0 END) AS WINS,
            SUM(CASE WHEN Wl_home = 'L' THEN 1 ELSE 0 END) AS LOSSES
        FROM game
        WHERE season_type = 'REGULAR SEASON'
        GROUP BY SUBSTR(season_id, 2, 4), season_type, team_name_home

        UNION ALL

        SELECT
            SUBSTR(season_id, 2, 4) AS season,
            season_type,
            team_name_away AS team_name,
            SUM(CASE WHEN Wl_away = 'W' THEN 1 ELSE 0 END) AS WINS,
            SUM(CASE WHEN Wl_away = 'L' THEN 1 ELSE 0 END) AS LOSSES
        FROM game
        WHERE season_type = 'REGULAR SEASON'
        GROUP BY SUBSTR(season_id, 2, 4), season_type, team_name_away
    ) AS combined
    GROUP BY season, season_type, team_name
)
SELECT * FROM season_record
ORDER BY season ASC, wins DESC;


WITH season_record AS (
    SELECT
        SUBSTR(season_id, 2, 4) AS season,
        season_type,
        team_name,
        SUM(WINS) AS WINS,
        SUM(LOSSES) AS LOSSES
    FROM (
        SELECT
            SUBSTR(season_id, 2, 4) AS season,
            season_type,
            team_name_home AS team_name,
            SUM(CASE WHEN Wl_home = 'W' THEN 1 ELSE 0 END) AS WINS,
            SUM(CASE WHEN Wl_home = 'L' THEN 1 ELSE 0 END) AS LOSSES
        FROM game
        WHERE season_type = 'REGULAR SEASON'
        GROUP BY SUBSTR(season_id, 2, 4), season_type, team_name_home

        UNION ALL

        SELECT
            SUBSTR(season_id, 2, 4) AS season,
            season_type,
            team_name_away AS team_name,
            SUM(CASE WHEN Wl_away = 'W' THEN 1 ELSE 0 END) AS WINS,
            SUM(CASE WHEN Wl_away = 'L' THEN 1 ELSE 0 END) AS LOSSES
        FROM game
        WHERE season_type = 'REGULAR SEASON'
        GROUP BY SUBSTR(season_id, 2, 4), season_type, team_name_away
    ) AS combined
    GROUP BY season, season_type, team_name
)
SELECT
season,season_type,team_name,
SUM(WINS) AS WINS,
SUM(LOSSES) AS LOSSES,
ROUND(SUM(WINS) * 1.0 / (SUM(WINS) + SUM(LOSSES)), 3) AS WIN_PCT
FROM season_record
GROUP BY season, season_type, team_name
ORDER BY season ASC, WIN_PCT DESC;

WITH season_record AS (
    SELECT
        season,
        season_type,
        team_name,
        SUM(WINS) AS WINS,
        SUM(LOSSES) AS LOSSES
    FROM (
        SELECT
            SUBSTR(season_id, 2, 4) AS season,
            season_type,
            team_name_home AS team_name,
            SUM(CASE WHEN Wl_home = 'W' THEN 1 ELSE 0 END) AS WINS,
            SUM(CASE WHEN Wl_home = 'L' THEN 1 ELSE 0 END) AS LOSSES
        FROM game
        WHERE season_type = 'REGULAR SEASON'
        GROUP BY SUBSTR(season_id, 2, 4), season_type, team_name_home

        UNION ALL

        SELECT
            SUBSTR(season_id, 2, 4) AS season,
            season_type,
            team_name_away AS team_name,
            SUM(CASE WHEN Wl_away = 'W' THEN 1 ELSE 0 END) AS WINS,
            SUM(CASE WHEN Wl_away = 'L' THEN 1 ELSE 0 END) AS LOSSES
        FROM game
        WHERE season_type = 'REGULAR SEASON'
        GROUP BY SUBSTR(season_id, 2, 4), season_type, team_name_away
    ) AS combined
    GROUP BY season, season_type, team_name
)
SELECT * FROM season_record
ORDER BY season ASC, wins DESC;



WITH season_record AS (
    SELECT
        SUBSTR(season_id, 2, 4) AS season,
        team_name_home AS team_name,
        SUM(CASE WHEN wl_home = 'W' THEN 1 ELSE 0 END) AS wins,
        SUM(CASE WHEN wl_home = 'L' THEN 1 ELSE 0 END) AS losses
    FROM game
    WHERE season_type = 'Regular Season'
    GROUP BY season_id, team_name_home

    UNION ALL

    SELECT
        SUBSTR(season_id, 2, 4),
        team_name_away,
        SUM(CASE WHEN wl_away = 'W' THEN 1 ELSE 0 END) AS wins,
        SUM(CASE WHEN wl_away = 'L' THEN 1 ELSE 0 END) AS losses
    FROM game
    WHERE season_type = 'Regular Season'
    GROUP BY season_id, team_name_away
)

SELECT
    season,
    team_name,
    SUM(wins) AS wins,
    SUM(losses) AS losses,
    ROUND(SUM(wins) / SUM(wins + losses), 2) AS win_pct
FROM season_record
GROUP BY season, team_name
ORDER BY WIN_PCT asc;


WITH season_record AS (
    SELECT
        SUBSTR(season_id, 2, 4) AS season,
        team_name_home AS team_name,
        SUM(CASE WHEN wl_home = 'W' THEN 1 ELSE 0 END) AS wins,
        SUM(CASE WHEN wl_home = 'L' THEN 1 ELSE 0 END) AS losses
    FROM game
    WHERE season_type = 'Regular Season'
    GROUP BY season_id, team_name_home

    UNION ALL

    SELECT
        SUBSTR(season_id, 2, 4),
        team_name_away,
        SUM(CASE WHEN wl_away = 'W' THEN 1 ELSE 0 END) AS wins,
        SUM(CASE WHEN wl_away = 'L' THEN 1 ELSE 0 END) AS losses
    FROM game
    WHERE season_type = 'Regular Season'
    GROUP BY season_id, team_name_away
)

SELECT
    season,
    team_name,
    SUM(wins) AS wins,
    SUM(losses) AS losses,
    ROUND(SUM(wins) / SUM(wins + losses), 2) AS win_pct
FROM season_record
GROUP BY season, team_name
ORDER BY team_name ASC,season ASC;

SELECT
game_id,
season_id,
team_name_home,
team_name_away,
wl_home,
wl_away
FROM game 
LEFT JOIN team_info 
    ON team_name_home = team_name;
    
    
SELECT
    g.game_id,
    g.season_id,
    g.team_name_home,
    g.team_name_away,
    g.wl_home,
    g.wl_away,
    t.team_abbreviation,
    t.conference
FROM game g
LEFT JOIN teams t
    ON g.team_name_home = t.team_full_name;
    
   SELECT
    t.team_name,
    t.team_abbreviation,
    g.game_id,
    g.team_name_home
FROM team_info t
LEFT JOIN game g
    ON t.team_name = g.team_name_home;
 
    
SELECT
    g.team_name_home,
    t.team_abbreviation
FROM game g
LEFT JOIN team_info t
    ON g.team_name_home = t.team_name;


CREATE VIEW team_season_summary AS
WITH season_record AS (
    SELECT
        SUBSTR(season_id, 2, 4) AS season,
        season_type,
        team_name,
        SUM(WINS) AS wins,
        SUM(LOSSES) AS losses
    FROM (
        SELECT
            SUBSTR(season_id, 2, 4) AS season,
            season_type,
            team_name_home AS team_name,
            SUM(CASE WHEN wl_home = 'W' THEN 1 ELSE 0 END) AS wins,
            SUM(CASE WHEN wl_home = 'L' THEN 1 ELSE 0 END) AS losses
        FROM game
        WHERE season_type = 'REGULAR SEASON'
        GROUP BY SUBSTR(season_id, 2, 4), season_type, team_name_home

        UNION ALL

        SELECT
            SUBSTR(season_id, 2, 4) AS season,
            season_type,
            team_name_away AS team_name,
            SUM(CASE WHEN wl_away = 'W' THEN 1 ELSE 0 END) AS wins,
            SUM(CASE WHEN wl_away = 'L' THEN 1 ELSE 0 END) AS losses
        FROM game
        WHERE season_type = 'REGULAR SEASON'
        GROUP BY SUBSTR(season_id, 2, 4), season_type, team_name_away
    ) AS combined
    GROUP BY season, season_type, team_name
)
SELECT
    season,
    season_type,
    team_name,
    wins,
    losses,
    ROUND(wins * 1.0 / (wins + losses), 3) AS win_pct
FROM season_record;
