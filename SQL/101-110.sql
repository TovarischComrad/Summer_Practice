-- #101
WITH T AS (
  SELECT *, 
  CASE WHEN color = 'n' THEN 1 ELSE 0 END bit
  FROM Printer
),
GR AS (
  SELECT *, (
    SELECT SUM(bit)
    FROM T AS A
    WHERE A.code <= B.code
  ) AS gr
  FROM T AS B
),
RES AS (
  SELECT gr, MAX(model) max_model, COUNT(DISTINCT type) distinct_types, 
  AVG(price) avg_price
  FROM GR
  GROUP BY gr
)
SELECT code, model, color, type, price, max_model, distinct_types, avg_price
FROM GR JOIN RES
ON GR.gr = RES.gr


-- #102
WITH INF AS (
  SELECT ID_psg, town_from, town_to
  FROM Pass_in_trip P JOIN Trip T
  ON P.trip_no = T.trip_no
) 
SELECT name
FROM (
  SELECT ID_psg
  FROM (
    SELECT DISTINCT ID_psg, town_from AS town
    FROM INF
    UNION
    SELECT DISTINCT ID_psg, town_to AS town
    FROM INF
  ) AS T
  GROUP BY ID_psg
  HAVING COUNT(town) = 2
) AS N JOIN Passenger P
ON N.ID_psg = P.ID_psg


-- #103
WITH T AS (
  SELECT ROW_NUMBER() OVER(ORDER BY trip_no) n, * 
  FROM Trip
),
T2 AS (
  SELECT TOP 3 trip_no
  FROM T
  UNION
  SELECT trip_no
  FROM T
  WHERE n > (SELECT MAX(n) - 3 FROM T)
)
SELECT *
FROM (
  SELECT ROW_NUMBER() OVER(ORDER BY trip_no) n, *
  FROM T2
) AS A
PIVOT (MAX(trip_no) FOR n IN ([1], [2], [3], [4], [5], [6])) AS P


-- #104
WITH T AS (
  SELECT class, numGuns numGuns
  FROM Classes
  WHERE type = 'bc' AND numGuns IS NOT NULL
),
N AS (
  SELECT 1 n, class, numGuns
  FROM T
  UNION ALL
  SELECT n + 1, class, numGuns
  FROM N
  WHERE n < numGuns
)
SELECT class, 'bc-' + CONVERT(VARCHAR(2), n) num
FROM N


-- #105
WITH T AS (
  SELECT maker, model, ROW_NUMBER() OVER(ORDER BY maker, model) A,
  DENSE_RANK() OVER(ORDER BY maker) B,
  RANK() OVER(ORDER BY maker) C
  FROM Product
)
SELECT T.maker, T.model, A, B, C, D
FROM (
  SELECT maker, MAX(A) D
  FROM T
  GROUP BY maker
) AS D JOIN T
ON T.maker = D.maker


-- #106
WITH T AS (
  SELECT ROW_NUMBER() OVER(ORDER BY B_DATETIME, B_Q_ID, B_V_ID) n, B_DATETIME, 
  B_Q_ID, B_V_ID,
  CONVERT(NUMERIC(12, 8), B_VOL) B_VOL
  FROM utB
),
T2 AS (
  SELECT *,
  CASE WHEN n % 2 = 0 THEN CONVERT(NUMERIC(12, 8), 1) / B_VOL ELSE B_VOL END B_VOL2
  FROM T
)
SELECT B_DATETIME, B_Q_ID, B_V_ID, CONVERT(INT, B_VOL) B_VOL,
CONVERT(NUMERIC(12, 8), ROUND ((
  SELECT EXP(SUM(LOG(B_VOL2)))
  FROM T2 AS B
  WHERE B.n <= A.n
), 8)) sv
FROM T2 AS A


-- #107
WITH T AS (
  SELECT ID_comp, trip_no, date
  FROM (
    SELECT ROW_NUMBER() OVER(ORDER BY date, trip_no) n, *
    FROM (
      SELECT ID_comp, T.trip_no, date
      FROM Pass_in_trip P JOIN Trip T
      ON P.trip_no = T.trip_no
      WHERE YEAR(date) = 2003 AND MONTH(date) = 4
      AND town_from = 'Rostov'
    ) AS T
  ) AS T
  WHERE n = 5
)
SELECT name, trip_no, date
FROM T JOIN Company C
ON T.ID_comp = C.ID_comp


-- #108
SELECT DISTINCT A.B_VOL a, B.B_VOL b, C.B_VOL c
FROM utB A, utB B, utB C
WHERE A.B_VOL < B.B_VOL AND B.B_VOL < C.B_VOL
AND C.B_VOL <= SQRT(SQUARE(A.B_VOL) + SQUARE(B.B_VOL))


-- #109
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
WHITE AS (
  SELECT Q_NAME
  FROM (
    SELECT DISTINCT B_Q_ID
    FROM INF
    WHERE R = 255 AND G = 255 AND B = 255
  ) AS T JOIN utQ 
  ON T.B_Q_ID = utQ.Q_ID
),
BLACK AS (
  SELECT DISTINCT Q_NAME
  FROM utQ LEFT OUTER JOIN utB
  ON utB.B_Q_ID = utQ.Q_ID
  WHERE utB.B_Q_ID IS NULL
)
SELECT *, 
(SELECT COUNT(*) FROM WHITE) Whites,
(SELECT COUNT(*) FROM BLACK) Blacks
FROM (
  SELECT *
  FROM WHITE
  UNION
  SELECT *
  FROM BLACK
) AS T


-- #110
WITH T AS (
  SELECT ID_psg
  FROM (
    SELECT DISTINCT ID_psg,
    DATEDIFF(minute, time_out, time_in) dif
    FROM Pass_in_trip P JOIN Trip T
    ON P.trip_no = T.trip_no
    WHERE DATEPART(dw, date) = 7
  ) AS T
  WHERE dif < 0
)
SELECT name
FROM T JOIN Passenger P
ON T.ID_psg = P.ID_psg
