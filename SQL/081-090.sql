-- #81
WITH D AS (
  SELECT *, YEAR(date) year, MONTH(date) month
  FROM Outcome
),
G AS (
  SELECT year, month, SUM(out) out
  FROM D
  GROUP BY year, month 
),
M AS (
  SELECT *
  FROM G
  WHERE out = (SELECT MAX(out) FROM G)
)
SELECT code, point, date, D.out
FROM M JOIN D
ON M.year = D.year AND M.month = D.month


-- #82
SELECT TOP ((SELECT COUNT(*) FROM PC) - 5) code, 
(
  SELECT AVG(price)
  FROM 
  (
    SELECT TOP 6 price
    FROM PC AS B
    WHERE B.code >= A.code
  ) mean
) mean
FROM PC AS A


-- #83
WITH T AS (
  SELECT name,
  (CASE WHEN numGuns = 8 THEN 1 ELSE 0 END) a1,
  (CASE WHEN bore = 15 THEN 1 ELSE 0 END) a2,
  (CASE WHEN displacement = 32000 THEN 1 ELSE 0 END) a3,
  (CASE WHEN type = 'bb' THEN 1 ELSE 0 END) a4,
  (CASE WHEN launched = 1915 THEN 1 ELSE 0 END) a5,
  (CASE WHEN S.class = 'Kongo' THEN 1 ELSE 0 END) a6,
  (CASE WHEN country = 'USA' THEN 1 ELSE 0 END) a7
  FROM Ships S JOIN Classes C
  ON S.class = C.class
)
SELECT name
FROM T
WHERE a1 + a2 + a3 + a4 + a5 + a6 + a7 >= 4


-- #84
WITH T AS (
  SELECT P.trip_no, date, time_out, ID_comp, ID_psg
  FROM Pass_in_trip P JOIN Trip T
  ON P.trip_no = T.trip_no
),
T2 AS (
  SELECT trip_no, date, time_out, T.ID_comp, ID_psg, name
  FROM T JOIN Company C
  ON T.ID_comp = C.ID_comp
),
T3 AS (
  SELECT *,
  (CASE WHEN DAY(date) < 11 THEN 1 ELSE
    (CASE WHEN DAY(date) < 21 THEN 2 ELSE 3 END) END) dec
  FROM T2
  WHERE MONTH(date) = 4 AND YEAR(date) = 2003
),
T4 AS (
  SELECT name, dec, COUNT(*) count
  FROM T3
  GROUP BY name, dec
),
T5 AS (
  SELECT name,
  (CASE WHEN dec = 1 THEN count ELSE 0 END) first,
  (CASE WHEN dec = 2 THEN count ELSE 0 END) second,
  (CASE WHEN dec = 3 THEN count ELSE 0 END) third
  FROM T4
)
SELECT name, SUM(first), SUM(second), SUM(third)
FROM T5
GROUP BY name


-- #85
WITH PR AS (
  SELECT DISTINCT maker
  FROM Product A
  WHERE type = 'Printer'
  AND NOT EXISTS(
    SELECT *
    FROM Product B
    WHERE A.maker = B.maker AND type != 'Printer'
  )
),
PC AS (  
  SELECT *
  FROM Product A
  WHERE type = 'PC'
  AND NOT EXISTS(
    SELECT *
    FROM Product B
    WHERE A.maker = B.maker AND type != 'PC'
  )
),
PC2 AS (
  SELECT maker
  FROM PC
  GROUP BY maker
  HAVING COUNT(model) >= 3
)
SELECT * 
FROM PR
UNION
SELECT *
FROM PC2


-- #86
SELECT maker, STRING_AGG(type, '/')
FROM (
  SELECT DISTINCT maker, type
  FROM Product
) AS T
GROUP BY maker


-- #87
WITH T0 AS ( 
  SELECT ID_psg, T.trip_no, date + time_out AS date, town_from
  FROM Pass_in_trip P JOIN Trip T
  ON P.trip_no = T.trip_no
),
T AS (
  SELECT *,
  ROW_NUMBER() OVER(PARTITION BY ID_psg ORDER BY date) AS n
  FROM T0
),
T2 AS (
  SELECT ID_psg, trip_no
  FROM T
  WHERE n = 1
),
PSG AS (
  SELECT ID_psg
  FROM T2 JOIN Trip A
  ON T2.trip_no = A.trip_no
  WHERE town_from != 'Moscow'
),
T3 AS (
  SELECT P.ID_psg, trip_no, date, place
  FROM PSG JOIN Pass_in_trip P
  ON PSG.ID_psg = P.ID_psg
),
T4 AS (
  SELECT ID_psg, town_to
  FROM T3 JOIN Trip A
  ON T3.trip_no = A.trip_no
  WHERE town_to = 'Moscow'
),
T5 AS (
  SELECT ID_psg, COUNT(*) num
  FROM T4
  GROUP BY ID_psg
  HAVING COUNT(*) > 1
)
SELECT name, num
FROM T5 JOIN Passenger P
ON T5.ID_psg = P.ID_psg


-- #88
WITH T AS (
  SELECT ID_psg
  FROM (
    SELECT DISTINCT ID_psg, ID_comp
    FROM Pass_in_trip P JOIN Trip T
    ON P.trip_no = T.trip_no
    GROUP BY ID_psg, ID_comp
  ) AS T
  GROUP BY ID_psg
  HAVING COUNT(DISTINCT ID_comp) = 1
),
T2 AS (
  SELECT T.ID_psg, COUNT(*) n
  FROM T JOIN Pass_in_trip P
  ON T.ID_psg = P.ID_psg
  GROUP BY T.ID_psg
),
T3 AS (
  SELECT *
  FROM T2
  WHERE n = (SELECT MAX(n) FROM T2)
)
SELECT P.name, n, D.name
FROM (
  SELECT DISTINCT ID_psg, n, name
  FROM (
    SELECT ID_psg, n, ID_comp
    FROM (
      SELECT P.ID_psg, n, trip_no
      FROM T3 JOIN Pass_in_trip P
      ON T3.ID_psg = P.ID_psg
    ) AS A JOIN Trip 
    ON A.trip_no = Trip.trip_no
  ) AS B JOIN Company C
  ON B.ID_comp = C.ID_comp
) AS D JOIN Passenger P
ON D.ID_psg = P.ID_psg


-- #89
WITH T AS (
  SELECT maker, COUNT(model) n
  FROM Product
  GROUP BY maker
)
SELECT *
FROM T
WHERE n = (SELECT MAX(n) FROM T)
OR n = (SELECT MIN(n) FROM T)


-- #90
SELECT *
FROM Product
WHERE model NOT IN (
  SELECT TOP 3 model
  FROM Product
  ORDER BY model DESC
)
AND model NOT IN (SELECT TOP 3 model FROM Product)
