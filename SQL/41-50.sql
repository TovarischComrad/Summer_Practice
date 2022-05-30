-- #41
WITH T AS (
  SELECT maker,
  CASE 
    WHEN COUNT(*) = COUNT(price)
    THEN MAX(price)
    ELSE NULL
  END AS price
  FROM Product INNER JOIN PC
  ON PC.model = Product.model
  GROUP BY maker

  UNION

  SELECT maker,
  CASE 
    WHEN COUNT(*) = COUNT(price)
    THEN MAX(price)
    ELSE NULL
  END AS price
  FROM Product INNER JOIN Laptop
  ON Laptop.model = Product.model
  GROUP BY maker

  UNION

  SELECT maker,
  CASE 
    WHEN COUNT(*) = COUNT(price)
    THEN MAX(price)
    ELSE NULL
  END AS price
  FROM Product INNER JOIN Printer
  ON Printer.model = Product.model
  GROUP BY maker
)
SELECT maker,
CASE 
  WHEN COUNT(*) = COUNT(price)
  THEN MAX(price)
  ELSE NULL
END AS price
FROM T
GROUP BY maker


-- #42
SELECT ship, battle
FROM Outcomes
WHERE result = 'sunk'


-- #43
SELECT name
FROM Battles
WHERE DATEPART(yyyy, date) NOT IN (
  SELECT CASE
    WHEN launched IS NULL
    THEN 0
    ELSE launched
  END
  FROM Ships
)


-- #44
SELECT DISTINCT name
FROM Ships
WHERE name LIKE 'R%'

UNION 

SELECT DISTINCT ship
FROM Outcomes
WHERE ship LIKE 'R%'


-- #45
SELECT DISTINCT name
FROM Ships
WHERE name LIKE '% % %'

UNION 

SELECT DISTINCT ship
FROM Outcomes
WHERE ship LIKE '% % %'


-- #46
SELECT ship, displacement, numGuns
FROM (
  SELECT name, displacement, numGuns
  FROM Ships JOIN Classes
  ON Ships.class = Classes.class

  UNION

  SELECT class AS name, displacement, numGuns
  FROM Classes
) AS T
RIGHT JOIN Outcomes
ON T.name = Outcomes.ship 
WHERE battle = 'Guadalcanal'


-- #47
WITH SH AS (
  SELECT country, name
  FROM Ships JOIN Classes
  ON Ships.class = Classes.class

  UNION

  SELECT country, ship
  FROM Outcomes JOIN Classes
  ON Classes.class = Outcomes.ship
),
T AS (
  SELECT country, name, 
  (CASE WHEN result = 'sunk' THEN 1 ELSE 0 END) AS result
  FROM SH LEFT JOIN Outcomes
  ON SH.name = Outcomes.ship
)
SELECT country
FROM T
GROUP BY country
HAVING COUNT(DISTINCT name) = SUM(result)


-- #48
WITH SH AS (
  SELECT country, name, Classes.class
  FROM Ships JOIN Classes
  ON Ships.class = Classes.class

  UNION

  SELECT country, ship, class
  FROM Outcomes JOIN Classes
  ON Classes.class = Outcomes.ship
),
T AS (
  SELECT class, 
  (CASE WHEN result = 'sunk' THEN 1 ELSE 0 END) AS result
  FROM SH LEFT JOIN Outcomes
  ON SH.name = Outcomes.ship
)
SELECT class
FROM T
GROUP BY class
HAVING SUM(result) > 0


-- #49
SELECT name
FROM Ships INNER JOIN Classes
ON Ships.class = Classes.class AND bore = 16

UNION

SELECT ship
FROM Outcomes INNER JOIN Classes
ON Outcomes.ship = Classes.class AND bore = 16


-- #50
SELECT DISTINCT battle
FROM Ships INNER JOIN Outcomes
ON Outcomes.ship = Ships.name AND Ships.class = 'Kongo'
