-- #11
SELECT AVG(speed)
FROM PC

-- #12
SELECT AVG(speed)
FROM Laptop
WHERE price > 1000

-- #13
SELECT AVG(speed)
FROM PC, Product
WHERE PC.model = Product.model AND Product.maker = 'A'

-- #14
SELECT Classes.class, name, country
FROM Classes
INNER JOIN Ships
ON Classes.class = Ships.class AND numGuns >= 10

-- #15
SELECT hd
FROM PC
GROUP BY hd
HAVING COUNT(model) >= 2

-- #16
SELECT DISTINCT A.model, B.model, A.speed, A.ram
FROM PC AS A, PC AS B
WHERE A.speed = B.speed AND A.ram = B.ram AND A.model > B.model

-- #17
SELECT DISTINCT type, Laptop.model, speed
FROM Laptop, Product
WHERE Laptop.model = Product.model
AND Laptop.speed < ALL (SELECT PC.speed
                        FROM PC)

-- #18
SELECT DISTINCT maker, price
FROM Product, Printer
WHERE color = 'y'
AND Product.model = Printer.model
AND price = (SELECT MIN(price)
             FROM Printer
             WHERE color = 'y')

-- #19
SELECT maker, AVG(Laptop.screen)
FROM Product
INNER JOIN Laptop
ON Product.model = Laptop.model
GROUP BY maker

-- #20
SELECT maker, COUNT(model)
FROM Product
WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(model) >= 3

