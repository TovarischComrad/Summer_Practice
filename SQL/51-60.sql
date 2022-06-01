-- #51
WITH SH AS (
  SELECT name, numGuns, displacement
  FROM Ships S JOIN Classes C
  ON S.class = C.class

  UNION 

  SELECT ship, numGuns, displacement
  FROM Outcomes O JOIN Classes C
  ON O.ship = C.class
),
INF AS (
  SELECT displacement, MAX(numGuns) AS maxGuns
  FROM SH
  GROUP BY displacement
)
SELECT name
FROM SH JOIN INF
ON SH.displacement = INF.displacement AND SH.numGuns = INF.maxGuns


-- #52
WITH SH AS (
  SELECT country, Classes.class, name, numGuns, bore, displacement, type
  FROM Ships JOIN Classes
  ON Ships.class = Classes.class
)
SELECT name
FROM SH
WHERE type = 'bb' AND country = 'Japan'
AND (numGuns >= 9 OR numGuns IS NULL)
AND (bore < 19 OR bore IS NULL) 
AND (displacement <= 65000 OR displacement IS NULL)


-- #53
SELECT CONVERT(NUMERIC(4, 2), AVG(numGuns))
FROM (
  SELECT CONVERT(NUMERIC(4, 2), numGuns) AS numGuns
  FROM Classes
  WHERE type = 'bb'
) AS T


-- #54
WITH SH AS (
  SELECT name, CONVERT(NUMERIC(4, 2), numGuns) AS numGuns, type
  FROM Ships S JOIN Classes C
  ON S.class = C.class AND type = 'bb'

  UNION ALL

  SELECT ship, CONVERT(NUMERIC(4, 2), numGuns) AS numGuns, type
  FROM Outcomes O JOIN Classes C
  ON O.ship = C.class AND type = 'bb'
)
SELECT CONVERT(NUMERIC(4, 2), AVG(numGuns))
FROM (
  SELECT DISTINCT *
  FROM SH
) AS T


-- #55
SELECT class, MIN(launched) AS year
FROM (
  SELECT C.class, launched
  FROM Classes C LEFT JOIN Ships S
  ON C.class = S.class
) AS T
GROUP BY class


-- #56
WITH SH AS (
  SELECT ship, class, result
  FROM Outcomes O JOIN Ships S
  ON O.ship = S.name

  UNION

  SELECT ship, class, result
  FROM Outcomes O JOIN Classes C
  ON O.ship = C.class
)
SELECT T1.class, (CASE WHEN sunks IS NULL THEN 0 ELSE sunks END)
FROM (
  SELECT class
  FROM Classes
  GROUP BY class
) AS T1 FULL JOIN (
  SELECT class, SUM(CASE WHEN result = 'sunk' THEN 1 ELSE 0 END) AS sunks
  FROM SH
  GROUP BY class
) AS T2
ON T1.class = T2.class


-- #57
WITH SH AS (
  SELECT ship, class, result
  FROM Outcomes O JOIN Ships S
  ON O.ship = S.name

  UNION

  SELECT ship, class, result
  FROM Outcomes O JOIN Classes C
  ON O.ship = C.class
),
SUNK AS (
  SELECT T1.class, (CASE WHEN sunks IS NULL THEN 0 ELSE sunks END) AS sunks
  FROM (
    SELECT class
    FROM Classes
    GROUP BY class
  ) AS T1 FULL JOIN (
    SELECT class, SUM(CASE WHEN result = 'sunk' THEN 1 ELSE 0 END) AS sunks
    FROM SH
    GROUP BY class
  ) AS T2
  ON T1.class = T2.class
  WHERE sunks > 0
),
SH2 AS (
  SELECT class
  FROM (
    SELECT name, C.class
    FROM Ships S JOIN Classes C
    ON S.class = C.class

    UNION 

    SELECT ship, class
    FROM Outcomes O JOIN Classes C
    ON O.ship = C.class
  ) AS T
  GROUP BY class
  HAVING COUNT(DISTINCT name) >= 3
)
SELECT SUNK.class, sunks
FROM SUNK JOIN SH2
ON SUNK.class = SH2.class


-- #58
WITH T1 AS (
  SELECT maker, type, COUNT(model) AS prc
  FROM Product
  GROUP BY maker, type
),
T2 AS (
  SELECT A.maker, B.type
  FROM Product A CROSS JOIN Product B
  GROUP BY A.maker, B.type
),
T3 AS (
  SELECT T2.maker, T2.type, 
  CONVERT(NUMERIC(4, 2), CASE WHEN T1.prc IS NULL THEN 0 ELSE T1.prc END) AS prc
  FROM T1 RIGHT JOIN T2
  ON T1.maker = T2.maker AND T1.type = T2.type
),
T4 AS (
  SELECT maker, CONVERT(NUMERIC(4, 2), COUNT(model)) AS model
  FROM Product
  GROUP BY maker
)
SELECT maker, type, 
CONVERT(NUMERIC(5, 2), prc * 100 / (
  SELECT model
  FROM T4
  WHERE T3.maker = T4.maker
))
FROM T3


-- #59
SELECT point, (inc - out) AS remain
FROM (
  SELECT point, SUM(inc) AS inc, SUM(out) AS out
  FROM (
    SELECT COALESCE(I.point, O.point) AS point, 
    (COALESCE (inc, 0)) AS inc, (COALESCE (out, 0)) AS out
    FROM Income_o I FULL JOIN Outcome_o O
    ON I.point = O.point AND I.date = O.date
  ) AS T
  GROUP BY point
) AS T2


-- #60
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
SELECT point, (inc - out) AS remain
FROM (
  SELECT point, SUM(inc) AS inc, SUM(out) AS out
  FROM (
    SELECT COALESCE(I.point, O.point) AS point, 
    (COALESCE (inc, 0)) AS inc, (COALESCE (out, 0)) AS out
    FROM I FULL JOIN O
    ON I.point = O.point AND I.date = O.date
  ) AS T
  GROUP BY point
) AS T2






