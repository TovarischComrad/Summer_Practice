-- �1
SELECT model, speed, hd
FROM PC
WHERE price < 500

-- �2
SELECT DISTINCT maker
FROM Product
WHERE type = 'Printer'

-- �3
SELECT model, ram, screen
FROM Laptop
WHERE price > 1000

-- �4
SELECT *
FROM Printer
WHERE color = 'y'

-- �5
SELECT model, speed, hd
FROM PC
WHERE (cd = '12x' OR cd = '24x') AND price < 600

-- �6
SELECT DISTINCT maker, speed
FROM Product 
INNER JOIN Laptop
ON Product.model = Laptop.model AND hd >= 10

-- �7
SELECT DISTINCT Product.model, price
FROM Product, PC
WHERE Product.model = PC.model AND maker = 'B'

UNION

SELECT DISTINCT Product.model, price
FROM Product, Laptop
WHERE Product.model = Laptop.model AND maker = 'B'

UNION

SELECT DISTINCT Product.model, price
FROM Product, Printer
WHERE Product.model = Printer.model AND maker = 'B'

-- �8
SELECT DISTINCT maker
FROM Product
WHERE type = 'PC'

EXCEPT

SELECT DISTINCT maker
FROM Product
WHERE type = 'Laptop'

-- �9
SELECT DISTINCT maker
FROM Product
INNER JOIN PC
ON Product.model = PC.model AND speed >= 450

-- �10
SELECT model, price
FROM Printer
WHERE price = (SELECT MAX(price) FROM Printer)

-- �11
SELECT AVG(speed)
FROM PC

-- �12
SELECT AVG(speed)
FROM Laptop
WHERE price > 1000

-- �13
SELECT AVG(speed)
FROM PC, Product
WHERE PC.model = Product.model AND Product.maker = 'A'

-- �14
SELECT Classes.class, name, country
FROM Classes
INNER JOIN Ships
ON Classes.class = Ships.class AND numGuns >= 10

-- �15
SELECT hd
FROM PC
GROUP BY hd
HAVING COUNT(model) >= 2

-- �16
SELECT DISTINCT A.model, B.model, A.speed, A.ram
FROM PC AS A, PC AS B
WHERE A.speed = B.speed AND A.ram = B.ram AND A.model > B.model

-- �17
SELECT DISTINCT type, Laptop.model, speed
FROM Laptop, Product
WHERE Laptop.model = Product.model
AND Laptop.speed < ALL (SELECT PC.speed
                        FROM PC)

-- �18
SELECT DISTINCT maker, price
FROM Product, Printer
WHERE color = 'y'
AND Product.model = Printer.model
AND price = (SELECT MIN(price)
             FROM Printer
             WHERE color = 'y')

-- �19
SELECT maker, AVG(Laptop.screen)
FROM Product
INNER JOIN Laptop
ON Product.model = Laptop.model
GROUP BY maker

-- �20
SELECT maker, COUNT(model)
FROM Product
WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(model) >= 3

-- �21
SELECT maker, MAX(price)
FROM Product
INNER JOIN PC
ON Product.model = PC.model
GROUP BY maker

-- �22
SELECT speed, AVG(price)
FROM PC
WHERE speed > 600
GROUP BY speed

-- �23
SELECT DISTINCT maker
FROM Product
INNER JOIN PC
ON Product.model = PC.model AND speed >= 750

INTERSECT

SELECT DISTINCT maker
FROM Product
INNER JOIN Laptop
ON Product.model = Laptop.model AND speed >= 750

-- �24
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

-- �25
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
