-- #71
WITH T AS (
  SELECT maker, code
  FROM Product P FULL JOIN PC
  ON P.model = PC.model
  WHERE P.type = 'PC'
)
SELECT maker
FROM T
GROUP BY maker
HAVING COUNT(code) = COUNT(*)


-- #72
WITH T AS (
  SELECT P.trip_no, ID_psg, ID_comp
  FROM Pass_in_trip P JOIN Trip T
  ON P.trip_no = T.trip_no
),
P AS (
  SELECT ID_psg
  FROM T
  GROUP BY ID_psg
  HAVING COUNT(DISTINCT ID_comp) = 1
),
P2 AS (
  SELECT P.ID_psg, COUNT(*) num
  FROM T JOIN P
  ON P.ID_psg = T.ID_psg
  GROUP BY P.ID_psg
),
P3 AS (
  SELECT *
  FROM P2
  WHERE num = (SELECT MAX(num) FROM P2)
)
SELECT name, num
FROM P3 JOIN Passenger PS
ON P3.ID_psg = PS.ID_psg


-- #73
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
),
C AS (
  SELECT DISTINCT country
  FROM Classes
),
T AS (
  SELECT country, battle
  FROM B
  GROUP BY battle, country
)
SELECT country, name
FROM Battles BT CROSS JOIN C

EXCEPT

SELECT *
FROM T


-- #74
WITH FL AS (
  SELECT (
  CASE 
    WHEN (SELECT COUNT(*) FROM Classes WHERE country = 'Russia') = 0
    THEN 0
    ELSE 1
  END) fl
),
T AS (
  SELECT *, CASE WHEN country = 'Russia' THEN 1 ELSE 0 END c
  FROM Classes CROSS JOIN FL
)
SELECT country, class
FROM T
WHERE fl = c


-- #75
WITH A AS (
  SELECT maker, MAX(price) as pc
  FROM PC JOIN Product
  ON PC.model = Product.model
  GROUP BY maker
),
B AS (
  SELECT maker, MAX(price) as laptop
  FROM Laptop JOIN Product
  ON Laptop.model = Product.model
  GROUP BY maker
),
C AS (
  SELECT maker, MAX(price) as printer
  FROM Printer JOIN Product
  ON Printer.model = Product.model
  GROUP BY maker
),
M AS (SELECT DISTINCT maker FROM Product),
T AS (
  SELECT M.maker, laptop
  FROM M LEFT JOIN B
  ON M.maker = B.maker
),
T2 AS (
  SELECT T.maker, laptop, pc
  FROM T LEFT JOIN A
  ON T.maker = A.maker
)
SELECT T2.maker, laptop, pc, printer
FROM T2 LEFT JOIN C
ON T2.maker = C.maker
WHERE NOT laptop IS NULL OR NOT pc IS NULL OR NOT printer IS NULL


-- #76
WITH P AS (
  SELECT ID_psg
  FROM Pass_in_trip
  GROUP BY ID_psg
  HAVING COUNT(DISTINCT place) = COUNT(*)
),
T AS (
  SELECT P.trip_no, ID_psg, time_out, time_in
  FROM Pass_in_trip P JOIN Trip T
  ON P.trip_no = T.trip_no
),
D AS (
  SELECT T.ID_psg, time_out, time_in, (DATEDIFF(minute, time_out, time_in)) dif
  FROM T JOIN P
  ON T.ID_psg = P.ID_psg
),
D1 AS (
  SELECT ID_psg, 
  CASE WHEN dif < 0 THEN 1440 + dif ELSE dif END dif
  FROM D
),
D2 AS (
  SELECT ID_psg, SUM(dif) minutes
  FROM D1
  GROUP BY ID_psg
)
SELECT name, minutes
FROM D2 JOIN Passenger P
ON D2.ID_psg = P.ID_psg


-- #77
WITH P AS (
  SELECT DISTINCT trip_no, date
  FROM Pass_in_trip
),
T AS (
  SELECT date, town_from
  FROM P JOIN Trip T
  ON P.trip_no = T.trip_no
  WHERE town_from = 'Rostov'
),
T2 AS (
  SELECT COUNT(*) as Qty, date
  FROM T
  GROUP BY date
)
SELECT *
FROM T2
WHERE Qty = (SELECT MAX(Qty) FROM T2)


-- #78
SELECT name,  
DATEFROMPARTS(YEAR(date), MONTH(date), 1) firstD,
DATEADD(dd, -1, DATEFROMPARTS(YEAR(DATEADD(mm, 1, date)), MONTH(DATEADD(mm, 1, date)), 1)) lastD
FROM Battles


-- #79
WITH T AS (
  SELECT P.trip_no, ID_psg, DATEDIFF(minute, time_out, time_in) dif
  FROM Pass_in_trip P JOIN Trip T
  ON P.trip_no = T.trip_no
),
T2 AS (
  SELECT trip_no, ID_psg,
  CASE WHEN dif < 0 THEN 1440 + dif ELSE dif END dif
  FROM T
),
T3 AS (
  SELECT ID_psg, SUM(dif) time
  FROM T2
  GROUP BY ID_psg
)
SELECT name, time
FROM T3 JOIN Passenger P
ON T3.ID_psg = P.ID_psg
WHERE time = (SELECT MAX(time) FROM T3)


-- #80
WITH T AS (
  SELECT maker, 
  CASE WHEN NOT code IS NULL THEN 1 ELSE 0 END el
  FROM Product P LEFT JOIN PC
  ON P.model = PC.model
  WHERE type = 'PC'
),
T2 AS (
  SELECT maker
  FROM T
  GROUP BY maker
  HAVING SUM(el) = COUNT(*)
),
T3 AS (
  SELECT maker
  FROM Product
  GROUP BY maker

  EXCEPT

  SELECT maker
  FROM Product
  WHERE type = 'PC'
  GROUP BY maker
)
SELECT *
FROM T2

UNION

SELECT *
FROM T3

