-- #1
SELECT model, speed, hd
FROM PC
WHERE price < 500

-- #2
SELECT DISTINCT maker
FROM Product
WHERE type = 'Printer'

-- #3
SELECT model, ram, screen
FROM Laptop
WHERE price > 1000

-- #4
SELECT *
FROM Printer
WHERE color = 'y'

-- #5
SELECT model, speed, hd
FROM PC
WHERE (cd = '12x' OR cd = '24x') AND price < 600

-- #6
SELECT DISTINCT maker, speed
FROM Product 
INNER JOIN Laptop
ON Product.model = Laptop.model AND hd >= 10

-- #7
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

-- #8
SELECT DISTINCT maker
FROM Product
WHERE type = 'PC'

EXCEPT

SELECT DISTINCT maker
FROM Product
WHERE type = 'Laptop'

-- #9
SELECT DISTINCT maker
FROM Product
INNER JOIN PC
ON Product.model = PC.model AND speed >= 450

-- #10
SELECT model, price
FROM Printer
WHERE price = (SELECT MAX(price) FROM Printer)
