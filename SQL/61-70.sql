-- #61
SELECT SUM(inc) - SUM(out)
FROM (
  SELECT (COALESCE (I.point, O.point)) point, 
  (COALESCE (inc, 0)) inc, (COALESCE (out, 0)) out
  FROM Income_o I FULL JOIN Outcome_o O
  ON I.point = O.point AND I.date = O.date
) T


-- #62
WITH I AS (
  SELECT *
  FROM Income_o
  WHERE date < '2001-04-15'
),
O AS (
  SELECT *
  FROM Outcome_o
  WHERE date < '2001-04-15'
)
SELECT SUM(inc) - SUM(out)
FROM (
  SELECT (COALESCE (I.point, O.point)) point, 
  (COALESCE (inc, 0)) inc, (COALESCE (out, 0)) out
  FROM I FULL JOIN O
  ON I.point = O.point AND I.date = O.date
) T


-- #63
SELECT P.name
FROM (
  SELECT DISTINCT ID_psg
  FROM Pass_in_Trip T
  GROUP BY place, ID_psg
  HAVING COUNT(*) > 1
) T, Passenger P
WHERE T.ID_psg = P.ID_psg


-- #64
WITH I AS (
  SELECT point, date, SUM(inc) inc
  FROM Income
  GROUP BY point, date
),
O AS (
  SELECT MAX(point) point, date, SUM(out) out
  FROM Outcome
  GROUP BY point, date
)
SELECT COALESCE(I.point, O.point) point,
COALESCE(I.date, O.date) date,
(CASE WHEN out IS NULL THEN 'inc' ELSE 'out' END) operation,
COALESCE(inc, out) money
FROM I FULL JOIN O
ON I.point = O.point AND I.date = O.date
WHERE inc IS NULL OR out IS NULL


-- #65
WITH T AS (
  SELECT maker, type, 
  ROW_NUMBER() OVER(PARTITION BY maker ORDER BY type) n
  FROM (
    SELECT maker,
    (CASE WHEN type = 'PC' THEN 0 ELSE
      (CASE WHEN type = 'Laptop' THEN 1 ELSE 2 END) END) AS type
    FROM Product
  ) T
  GROUP BY maker, type
)
SELECT (ROW_NUMBER() OVER(ORDER BY maker)) num,
(CASE WHEN n = 1 THEN maker ELSE '' END) maker,
(CASE WHEN type = 0 THEN 'PC' ELSE
  (CASE WHEN type = 1 THEN 'Laptop' ELSE 'Printer' END) END) type
FROM T


-- #66
WITH NUM(num) AS (
  SELECT 1
  UNION ALL
  SELECT num + 1 FROM NUM WHERE num < 7
),
DATES AS (
  SELECT num, DATETIMEFROMPARTS(2003, 4, num, 0, 0, 0, 0) Dt
  FROM NUM
),
T AS (
  SELECT date, COUNT(*) AS Qty
  FROM (
    SELECT DISTINCT P.trip_no, date, town_from
    FROM Pass_in_trip P JOIN Trip T
    ON P.trip_no = T.trip_no
    WHERE town_from = 'Rostov'
  ) T
  GROUP BY date
  HAVING date >= '2003-04-01' AND date <= '2003-04-07'
)
SELECT Dt, (CASE WHEN Qty IS NULL THEN 0 ELSE Qty END) Qty
FROM DATES LEFT JOIN T
ON DATES.Dt = T.date


-- #67
WITH T AS (
  SELECT town_from, town_to, COUNT(*) AS num
  FROM Trip
  GROUP BY town_from, town_to
)
SELECT COUNT(*)
FROM T
WHERE num = (SELECT MAX(num) FROM T)


-- #68
WITH T AS (
  SELECT town_from, town_to, COUNT(*) AS num
  FROM Trip
  GROUP BY town_from, town_to
),
T2 AS (
  SELECT (CASE WHEN town_from < town_to THEN town_from ELSE town_to END) A,
  (CASE WHEN town_from >= town_to THEN town_from ELSE town_to END) B, num
  FROM T
),
T3 AS (
  SELECT A, B, SUM(num) AS num
  FROM T2
  GROUP BY A, B
)
SELECT COUNT(*)
FROM T3
WHERE num = (SELECT MAX(num) FROM T3)


-- #69
WITH I AS (
  SELECT point, date, SUM(inc) inc
  FROM Income
  GROUP BY point, date
),
O AS (
  SELECT point, date, SUM(out) out
  FROM Outcome
  GROUP BY point, date
),
T AS (
  SELECT COALESCE(I.point, O.point) point,
  COALESCE(I.date, O.date) date,
  COALESCE(inc, 0) inc,
  COALESCE(out, 0) out
  FROM I FULL JOIN O
  ON I.point = O.point AND I.date = O.date
),
T2 AS (
  SELECT *, inc - out AS del
  FROM T
)
SELECT point, FORMAT(date, 'dd/MM/yyyy') day,
(
  SELECT SUM(del) 
  FROM T2
  WHERE point = T3.point AND date <= T3.date
) del2
FROM T2 AS T3


-- #70
WITH SH AS (  
  SELECT C.class, name, country
  FROM Classes C JOIN Ships S
  ON C.class = S.class
),
B AS (
  SELECT ship, battle, country
  FROM Outcomes O JOIN SH
  ON O.ship = SH.name

  UNION

  SELECT ship, battle, country
  FROM Outcomes O JOIN Classes C
  ON O.ship = C.class
)
SELECT DISTINCT battle
FROM B
GROUP BY battle, country
HAVING COUNT(*) >= 3
