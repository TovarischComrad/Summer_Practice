-- #111
WITH T AS (
  SELECT *
  FROM utB JOIN utV
  ON utB.B_V_ID = utV.V_ID
),
INF AS (
  SELECT *,
  (SELECT COALESCE(SUM(B_VOL), 0) FROM T AS A WHERE A.B_Q_ID = B.B_Q_ID AND 
  A.B_DATETIME <= B.B_DATETIME AND V_COLOR = 'R') R,
  (SELECT COALESCE(SUM(B_VOL), 0) FROM T AS A WHERE A.B_Q_ID = B.B_Q_ID AND 
  A.B_DATETIME <= B.B_DATETIME AND V_COLOR = 'G') G,
  (SELECT COALESCE(SUM(B_VOL), 0) FROM T AS A WHERE A.B_Q_ID = B.B_Q_ID AND 
  A.B_DATETIME <= B.B_DATETIME AND V_COLOR = 'B') B
  FROM T AS B
),
RES AS (
  SELECT B_Q_ID, MAX(R) R, MAX(G) G, MAX(B) B
  FROM INF
  GROUP BY B_Q_ID
  HAVING MAX(R) = MAX(G) AND MAX(B) = MAX(G)
  AND MAX(R) > 0 AND MAX(G) > 0 AND MAX(B) > 0
  AND MAX(R) < 255 AND MAX(G) < 255 AND MAX(B) < 255
)
SELECT Q_NAME, R
FROM RES JOIN utQ
ON RES.B_Q_ID = utQ.Q_ID


-- #112
WITH T AS (
  SELECT *
  FROM utB JOIN utV
  ON utB.B_V_ID = utV.V_ID
),
INF AS (
  SELECT *,
  (SELECT 255 - SUM(B_VOL) FROM T AS A WHERE A.B_V_ID = B.B_V_ID AND A.B_DATETIME <= B.B_DATETIME) AS remains
  FROM T AS B
),
REM AS (
  SELECT V_COLOR, SUM(remains) remains
  FROM (
    SELECT V_ID, V_NAME, V_COLOR, MIN(remains) remains
    FROM INF
    GROUP BY V_ID, V_NAME, V_COLOR
  ) AS T
  GROUP BY V_COLOR
),
REM2 AS (
  SELECT V_COLOR, COUNT(*) * 255 remains
  FROM (
    SELECT V_ID, V_name, V_COLOR
    FROM utV
    EXCEPT
    SELECT DISTINCT V_ID, V_NAME, V_COLOR
    FROM INF
  ) AS T
  GROUP BY V_COLOR
),
RES AS (
  SELECT REM.V_COLOR, REM.remains + REM2.remains rem
  FROM REM2 JOIN REM
  ON REM2.V_COLOR = REM.V_COLOR
)
SELECT CASE WHEN COUNT(*) < 3 THEN 0 ELSE MIN(n) END n
FROM (
  SELECT *, rem / 255 n
  FROM RES
) AS T


-- #113
WITH T AS (
  SELECT *
  FROM utB JOIN utV
  ON utB.B_V_ID = utV.V_ID
),
INF AS (
  SELECT *,
  (SELECT COALESCE(SUM(B_VOL), 0) FROM T AS A WHERE A.B_Q_ID = B.B_Q_ID AND 
  A.B_DATETIME <= B.B_DATETIME AND V_COLOR = 'R') R,
  (SELECT COALESCE(SUM(B_VOL), 0) FROM T AS A WHERE A.B_Q_ID = B.B_Q_ID AND 
  A.B_DATETIME <= B.B_DATETIME AND V_COLOR = 'G') G,
  (SELECT COALESCE(SUM(B_VOL), 0) FROM T AS A WHERE A.B_Q_ID = B.B_Q_ID AND 
  A.B_DATETIME <= B.B_DATETIME AND V_COLOR = 'B') B
  FROM T AS B
),
R1 AS (
  SELECT B_Q_ID, 255 - MAX(R) R, 255 - MAX(G) G, 255 - MAX(B) B
  FROM INF
  GROUP BY B_Q_ID
),
R2 AS (
  SELECT Q_ID, 255 R, 255 G, 255 B
  FROM (
    SELECT DISTINCT Q_ID FROM utQ
    EXCEPT
    SELECT DISTINCT B_Q_ID FROM INF
  ) AS T
)
SELECT SUM(R), SUM(G), SUM(B)
FROM (SELECT * FROM R1 UNION SELECT * FROM R2) AS T


-- #114
WITH T AS (
  SELECT ID_psg, place, COUNT(*) n
  FROM Pass_in_trip
  GROUP BY ID_psg, place
)
SELECT name, n
FROM (
  SELECT DISTINCT ID_psg, n FROM T
  WHERE n = (SELECT MAX(n) FROM T)
) AS R JOIN Passenger P
ON R.ID_psg = P.ID_psg


-- #115
SELECT DISTINCT A.B_VOL Up, B.B_VOL Down, C.B_VOL Side,
CONVERT( NUMERIC(6, 2), 
         SQRT(CONVERT(NUMERIC(6, 2), A.B_VOL) 
              * CONVERT(NUMERIC(6, 2), B.B_VOL)) / 2 ) Rad
FROM utB A, utB B, utB C
WHERE A.B_VOL < B.B_VOL
AND CONVERT(NUMERIC(6, 2), C.B_VOL) * 2 = CONVERT(NUMERIC(6, 2), A.B_VOL) + 
CONVERT(NUMERIC(6, 2), B.B_VOL)


-- #116
WITH T AS (
  SELECT ROW_NUMBER() OVER(ORDER BY B_DATETIME) n, *
  FROM utB
),
N AS (SELECT MAX(n) n FROM T),
L AS (SELECT * FROM T WHERE n < (SELECT * FROM N)),
R AS (SELECT * FROM T WHERE n > 1),
D AS (
  SELECT L.n n1, L.B_DATETIME date1, R.n n2, R.B_DATETIME date2, 
  DATEDIFF(s, L.B_DATETIME,R.B_DATETIME) dif
  FROM L JOIN R
  ON L.n = R.n - 1
  WHERE L.B_DATETIME < R.B_DATETIME
)
SELECT MIN(date1), MAX(date2)
FROM (
  SELECT *, SUM(fl) OVER(ORDER BY n1 ROWS UNBOUNDED PRECEDING) n
  FROM (
    SELECT *, CASE WHEN dif <= 1 THEN 0 ELSE 1 END fl
    FROM D
  ) AS T
) AS T
WHERE fl = 0
GROUP BY n


-- #117
WITH T AS (
  SELECT country, MAX(max_val) max_val, name
  FROM Classes 
  CROSS APPLY (VALUES
    (numGuns * 5000, 'numGuns'),
    (bore * 3000, 'bore'),
    (displacement, 'displacement')
  ) AS V(max_val, name)
  GROUP BY country, name
)
SELECT *
FROM T AS A
WHERE max_val = (
  SELECT MAX(max_val)
  FROM T AS B
  WHERE A.country = B.country
)


-- #118
WITH D AS (
  SELECT name, CONVERT(DATE, date) date,
  DATEFROMPARTS(YEAR(date), 4, 1) d
  FROM Battles
),
R AS (
  SELECT name, date, 
  DATEADD(dd, 1, 
    CASE 
      WHEN DATEPART(dw, d) = 2 THEN d
      WHEN DATEPART(dw, d) = 1 THEN DATEADD(dd, 1, d)
      ELSE DATEADD(dd, 9 - DATEPART(dw, d), d)
    END) d
  FROM D
  UNION ALL
  SELECT name, date,
  DATEADD(dd, 1, 
    CASE 
      WHEN DATEPART(dw, DATEFROMPARTS(YEAR(d) + 1, 4, 1)) = 2 
	    THEN DATEFROMPARTS(YEAR(d) + 1, 4, 1)
      WHEN DATEPART(dw, DATEFROMPARTS(YEAR(d) + 1, 4, 1)) = 1 
	    THEN DATEADD(dd, 1, DATEFROMPARTS(YEAR(d) + 1, 4, 1))
      ELSE DATEADD(dd, 9 - DATEPART(dw, DATEFROMPARTS(YEAR(d) + 1, 4, 1)), DATEFROMPARTS(YEAR(d) + 1, 4, 1))
    END) d
  FROM R
  WHERE d <= date
  OR ((YEAR(d) % 4 != 0 OR YEAR(d) % 100 = 0) AND YEAR(d) % 400 != 0)
)
SELECT name, date, MAX(d) d
FROM R
GROUP BY name, date


-- #119
WITH T AS (
  SELECT *, 
  YEAR(B_DATETIME) year, MONTH(B_DATETIME) month, DAY(B_DATETIME) day
  FROM utB
),
Y AS (
  SELECT CONVERT(VARCHAR, year) AS period, SUM(B_VOL) vol
  FROM T
  GROUP BY year
  HAVING COUNT(DISTINCT B_DATETIME) > 10
),
M AS (
  SELECT CONCAT(year, '-', CASE WHEN month < 10 THEN '0' ELSE '' END, month) 
  period, 
  SUM(B_VOL) vol
  FROM T
  GROUP BY year, month
  HAVING COUNT(DISTINCT B_DATETIME) > 10
),
D AS (
  SELECT CONCAT( year, '-', 
               CASE WHEN month < 10 THEN '0' ELSE '' END, month, '-',
               CASE WHEN day < 10 THEN '0' ELSE '' END, day) 
  period, 
  SUM(B_VOL) vol
  FROM T
  GROUP BY year, month, day
  HAVING COUNT(DISTINCT B_DATETIME) > 10
)
SELECT * FROM Y
UNION 
SELECT * FROM M
UNION
SELECT * FROM D


-- #120
WITH T AS (
  SELECT T.ID_comp, name, DATEDIFF(minute, time_out, time_in) dif
  FROM (
    SELECT DISTINCT P.trip_no, date, ID_comp, time_out, time_in
    FROM Pass_in_trip P JOIN Trip T
    ON P.trip_no = T.trip_no
  ) AS T JOIN Company C
  ON T.ID_comp = C.ID_comp
),
R AS (
  SELECT ID_comp, name, 
  CONVERT(NUMERIC(6, 2), CASE WHEN dif < 0 THEN 1440 + dif ELSE dif END) dif
  FROM T
)
SELECT CASE WHEN name IS NULL THEN 'TOTAL' ELSE name END name,
CONVERT(NUMERIC(6, 2), AVG(dif)) A_Mean, 
CONVERT(NUMERIC(6, 2), POWER(EXP(SUM(LOG(dif))), CONVERT(FLOAT, 1) / COUNT(*))) G_Mean, 
CONVERT(NUMERIC(6, 2), SQRT(SUM(square) / COUNT(*))) Q_Mean,
CONVERT(NUMERIC(6, 2), COUNT(*) / SUM(div)) H_Mean
FROM (
  SELECT *, dif * dif square, CONVERT(FLOAT, 1) / dif div
  FROM R
) AS A
GROUP BY name WITH ROLLUP