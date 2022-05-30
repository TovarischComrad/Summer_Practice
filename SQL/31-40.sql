-- #31
SELECT class, country
FROM Classes
WHERE bore >= 16


-- #32
WITH T AS (
  SELECT country, bore, name
  FROM Classes AS C INNER JOIN Ships AS S
  ON C.class = S.class

  UNION

  SELECT DISTINCT country, bore, ship
  FROM Classes AS C INNER JOIN Outcomes AS O
  ON O.ship = C.class
)
SELECT country, CONVERT(NUMERIC(6, 2), AVG(POWER(bore, 3) / 2)) as mw
FROM T
GROUP BY country


-- #33
SELECT ship
FROM Outcomes
WHERE battle = 'North Atlantic' AND result = 'sunk'


-- #34
SELECT DISTINCT name
FROM Classes INNER JOIN Ships
ON Classes.class = Ships.class AND NOT launched IS NULL
AND launched >= 1922 AND displacement > 35000 AND type = 'bb'


-- #35
SELECT model, type
FROM Product
WHERE model NOT LIKE '%[^0-9]%'
OR UPPER(model) NOT LIKE '%[^A-Z]%'


-- #36
SELECT DISTINCT name
FROM Ships
WHERE name = class

UNION

SELECT DISTINCT ship
FROM Outcomes INNER JOIN Classes
ON Outcomes.ship = Classes.class


-- #37
WITH T AS (
  SELECT class, name
  FROM Ships

  UNION

  SELECT class, ship
  FROM Outcomes INNER JOIN Classes
  ON Outcomes.ship = Classes.class
)
SELECT class
FROM T
GROUP BY class
HAVING COUNT(name) = 1

-- #38
SELECT DISTINCT country
FROM Classes 
WHERE type = 'bb'

INTERSECT

SELECT DISTINCT country
FROM Classes 
WHERE type = 'bc'


-- #39
WITH T AS (
  SELECT *
  FROM Outcomes INNER JOIN Battles
  ON Outcomes.battle = Battles.name
)
SELECT DISTINCT ship
FROM T AS T1
WHERE result = 'damaged'
AND EXISTS (
  SELECT *
  FROM T AS T2
  WHERE T1.ship = T2.ship 
  AND T2.date > T1.date
)


-- #40
WITH T AS (
  SELECT maker
  FROM Product
  GROUP BY maker
  HAVING COUNT(model) > 1

  INTERSECT

  SELECT maker
  FROM Product
  GROUP BY maker
  HAVING COUNT(DISTINCT type) = 1
)
SELECT DISTINCT T.maker, type
FROM T, Product
WHERE T.maker = Product.maker