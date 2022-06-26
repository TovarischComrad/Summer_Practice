-- #21
SELECT maker, MAX(price)
FROM Product
INNER JOIN PC
ON Product.model = PC.model
GROUP BY maker

-- #22
SELECT speed, AVG(price)
FROM PC
WHERE speed > 600
GROUP BY speed

-- #23
SELECT DISTINCT maker
FROM Product
INNER JOIN PC
ON Product.model = PC.model AND speed >= 750

INTERSECT

SELECT DISTINCT maker
FROM Product
INNER JOIN Laptop
ON Product.model = Laptop.model AND speed >= 750

-- #24
WITH T AS (
      SELECT model, price
      FROM PC
      WHERE price = (SELECT MAX(price)
                     FROM PC)
      UNION
      SELECT model, price
      FROM Laptop
      WHERE price = (SELECT MAX(price)
                     FROM Laptop)
      UNION
      SELECT model, price
      FROM Printer
      WHERE price = (SELECT MAX(price)
                     FROM Printer)
)
SELECT model
FROM T
WHERE price = (SELECT MAX(price)
               FROM T)

-- #25
WITH P AS (
  SELECT PC.model, ram, speed, maker
  FROM Product
  INNER JOIN PC
  ON Product.model = PC.model
  WHERE ram = (SELECT MIN(ram)
               FROM PC)
)
SELECT DISTINCT maker
FROM P
WHERE speed = (SELECT MAX(speed)
               FROM P)

INTERSECT

SELECT DISTINCT maker
FROM Product
WHERE type = 'Printer'

-- #26
SELECT AVG(price)
FROM (
  SELECT price
  FROM Product
  INNER JOIN PC
  ON Product.model = PC.model AND Product.maker = 'A'

  UNION ALL

  SELECT price
  FROM Product
  INNER JOIN Laptop
  ON Product.model = Laptop.model AND Product.maker = 'A'
) AS T

-- #27
SELECT maker, AVG(hd)
FROM Product
INNER JOIN PC
ON Product.model = PC.model
AND maker IN (
  SELECT DISTINCT maker
  FROM Product
  WHERE type = 'Printer'
)
GROUP BY maker

-- #28
SELECT COUNT(maker)
FROM (
  SELECT maker, COUNT(model) AS model
  FROM Product
  GROUP BY maker
  HAVING COUNT(model) = 1
) AS T

-- #29
SELECT (COALESCE (Income_o.point, Outcome_o.point)) AS point,
(COALESCE (Income_o.date, Outcome_o.date)) AS date,
inc, out
FROM Income_o FULL JOIN Outcome_o
ON Income_o.point = Outcome_o.point 
AND Income_o.date = Outcome_o.date


-- #30
WITH A AS (
  SELECT point, date, SUM(inc) AS inc
  FROM Income
  GROUP BY point, date
),
B AS (
  SELECT point, date, SUM(out) AS out
  FROM Outcome
  GROUP BY point, date
)
SELECT (COALESCE (A.point, B.point)) AS point,
(COALESCE (A.date, B.date)) AS date,
out, inc
FROM A FULL JOIN B
ON A.point = B.point 
AND A.date = B.date
