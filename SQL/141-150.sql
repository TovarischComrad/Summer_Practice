-- #141
WITH D AS (
  SELECT ID_psg, MIN(date) mn, MAX(date) mx
  FROM Pass_in_trip
  GROUP BY ID_psg
),
R AS (
  SELECT *,
  CASE 
    WHEN mx < '2003-04-01' THEN 0
    WHEN mn >= '2003-05-01' THEN 0
    WHEN mn < '2003-04-01' AND mx >= '2003-04-01' AND mx < '2003-05-01'
      THEN DATEDIFF(day, '2003-04-01', mx) + 1
    WHEN mn >= '2003-04-01' AND mx < '2003-05-01'
      THEN DATEDIFF(day, mn, mx) + 1
    WHEN mn >= '2003-04-01' AND mn < '2003-05-01' AND mx >= '2003-05-01'
      THEN DATEDIFF(day, mn, '2003-05-01')
    ELSE -1
  END cnt
  FROM D
)
SELECT name, cnt
FROM R JOIN Passenger P
ON R.ID_psg = P.ID_psg


-- #142
WITH T AS (
  SELECT ID_psg, plane, town_to
  FROM Pass_in_trip P JOIN Trip T
  ON P.trip_no = T.trip_no
),
R1 AS (
  SELECT ID_psg
  FROM T
  GROUP BY ID_psg
  HAVING COUNT(DISTINCT plane) = 1
),
R2 AS (
  SELECT DISTINCT ID_psg
  FROM T
  GROUP BY ID_psg, town_to
  HAVING COUNT(*) >= 2
)
SELECT name
FROM (
  SELECT * FROM R1
    INTERSECT
  SELECT * FROM R2
) AS T JOIN Passenger P
ON T.ID_psg = P.ID_psg


-- #143
WITH NUM AS (
  SELECT 0 AS n
    UNION ALL
  SELECT n + 1 FROM NUM WHERE n < 6
)
SELECT B.name, CAST(B.date AS date) date, DATEADD(day, -n , EOMONTH(B.date)) fri
FROM Battles B JOIN Num N
ON DATEPART(dw, DATEADD(day, -n , EOMONTH(B.date))) = DATEPART(dw, '20210326')


-- #144
WITH T AS (
  SELECT maker, price
  FROM Product P JOIN PC
  ON P.model = PC.model
)
SELECT DISTINCT maker
FROM T
WHERE price = (SELECT MAX(price) FROM T)
  INTERSECT 
SELECT DISTINCT maker
FROM T
WHERE price = (SELECT MIN(price) FROM T)


-- #145
WITH T AS (
  SELECT ROW_NUMBER() OVER(ORDER BY date) n, date
  FROM (
    SELECT DISTINCT date
    FROM Income_o
  ) AS T
),
T2 AS (
  SELECT A.date dt1, B.date dt2
  FROM T AS A JOIN T AS B
  ON B.n = A.n + 1
)
SELECT COALESCE(SUM(out), 0), dt1, dt2
FROM T2 LEFT JOIN Outcome_o O
ON dt1 < date AND dt2 >= date
GROUP BY dt1, dt2


-- #146
SELECT char, val
FROM (
  SELECT CONVERT(VARCHAR(MAX), model) model, 
  CONVERT(VARCHAR(MAX), speed) speed, 
  CONVERT(VARCHAR(MAX), ram) ram,
  CONVERT(VARCHAR(MAX), hd) hd,
  CONVERT(VARCHAR(MAX), cd) cd,
  COALESCE(CONVERT(VARCHAR(MAX), price), '') price
  FROM PC
  WHERE code = (SELECT MAX(code) FROM PC)
) AS T
UNPIVOT (
  val FOR char IN (model, speed, ram, hd, cd, price)
) AS P


-- #147
WITH T AS (
  SELECT maker, COUNT(model) cnt
  FROM Product
  GROUP BY maker
)
SELECT ROW_NUMBER() OVER(ORDER BY cnt DESC, T.maker, model) no, T.maker, model
FROM T JOIN Product P
ON T.maker = P.maker


-- #148
WITH T AS (
  SELECT *
  FROM Outcomes
  CROSS APPLY (
    VALUES (
      CHARINDEX(' ', ship, 1),
      DATALENGTH(ship) - CHARINDEX(' ', REVERSE(ship), 1) + 1 
    )
  ) AS T(first, last)
  WHERE NOT (first = last OR first = 0 OR last = 0)
)
SELECT ship, 
STUFF(ship, first + 1, last - first - 1, REPLICATE('*', last - first - 1)) AS new_name
FROM T


-- #149
WITH T AS (
  SELECT MAX(date) ub
  FROM (
    SELECT B_V_ID, MIN(B_DATETIME) date
    FROM utB
    GROUP BY B_V_ID
  ) AS T
)
SELECT V_NAME
FROM utB JOIN utV
ON utB.B_V_ID = utV.V_ID
WHERE B_DATETIME = (SELECT * FROM T)
GROUP BY B_V_ID, V_NAME


-- #150
WITH T AS (
  SELECT point, MIN(date) mi, MAX(date) ma
  FROM Income
  GROUP BY point
)
SELECT point, MAX(date1) date1, MIN(mi) mi, MAX(ma) max, MIN(date2) date2
FROM (
  SELECT T.point, mi, ma, 
  CASE WHEN date < mi THEN date ELSE NULL END date1,
  CASE WHEN date > ma THEN date ELSE NULL END date2
  FROM T CROSS JOIN Income I
) AS T
GROUP BY point