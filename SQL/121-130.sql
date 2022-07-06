-- #121 
WITH S AS (
  SELECT S.name AS ship, launched, B.name AS battle, date
  FROM Ships S LEFT JOIN Battles B
  ON launched IS NULL OR launched <= YEAR(date)
),
R1 AS (
  SELECT ship, MIN(launched) launched,
  (
    SELECT TOP 1 battle
    FROM S AS I
    WHERE O.ship = I.ship
    ORDER BY date DESC
  ) battle
  FROM S AS O
  WHERE launched IS NULL
  GROUP BY ship
),
R2 AS (
  SELECT ship, MIN(launched) launched, 
  (
    SELECT TOP 1 battle
    FROM S AS I
    WHERE O.ship = I.ship
    ORDER BY ISNULL(date, '1800-01-01')
  ) battle
  FROM S AS O
  WHERE launched IS NOT NULL
  GROUP BY ship
)
SELECT * FROM R1
  UNION ALL
SELECT * FROM R2


-- #122
WITH T AS (
  SELECT P.trip_no, date, ID_psg, town_from, town_to, time_out, time_in,
  CASE WHEN time_out < time_in THEN 0 ELSE 1 END fl
  FROM Pass_in_trip P JOIN Trip T
  ON P.trip_no = T.trip_no
),
T2 AS (
  SELECT trip_no, ID_psg, town_from, town_to, time_out + date start, 
  CASE WHEN fl = 1 THEN DATEADD(dd, 1, time_in + date) ELSE time_in + date END 
  finish
  FROM T
),
ST AS (
  SELECT ID_psg, town_from
  FROM T2 AS B
  WHERE start = (SELECT MIN(start) FROM T2 AS A WHERE A.ID_psg = B.ID_psg)
),
FN AS (
  SELECT ID_psg, town_to
  FROM T2 AS B
  WHERE finish = (SELECT MAX(finish) FROM T2 AS A WHERE A.ID_psg = B.ID_psg)
)
SELECT name, town_from
FROM (
  SELECT ST.ID_psg, town_from
  FROM ST JOIN FN
  ON ST.ID_psg = FN.ID_psg
  WHERE town_from != town_to
) AS R JOIN Passenger P
ON R.ID_psg = P.ID_psg


-- #123
WITH N AS (SELECT COUNT(model) cnt FROM product WHERE type='printer'),
T AS (
  SELECT pc_n - (N.cnt * ((pc_n - 1) / N.cnt)) num, model, type, 2 mod
  FROM N, (
    SELECT model, ROW_NUMBER() OVER(ORDER BY model) pc_n, type 
    FROM product 
    WHERE type = 'PC'
  ) AS T
    UNION ALL
  SELECT ROW_NUMBER() OVER(ORDER BY model) pr_n, model, type, 1 mod
  FROM Product
  WHERE type = 'Printer' 
)
SELECT ROW_NUMBER() OVER(ORDER BY num, mod) AS n, model, type
FROM T


-- #124
SELECT name
FROM (
  SELECT ID_psg
  FROM (
    SELECT ID_psg, ID_comp, COUNT(*) n
    FROM (
      SELECT ID_psg, ID_comp
      FROM Pass_in_trip P JOIN Trip T
      ON P.trip_no = T.trip_no
    ) AS T
    GROUP BY ID_psg, ID_comp
  ) AS T
  GROUP BY ID_psg
  HAVING COUNT(n) > 1 AND COUNT(DISTINCT n) = 1
) AS T JOIN Passenger P
ON T.ID_psg = P.ID_psg


-- #125
WITH T AS (
  SELECT ROW_NUMBER() OVER(PARTITION BY ID_psg ORDER BY date) n, * 
  FROM (
    SELECT ID_psg, place, date + time_out AS date
    FROM Pass_in_trip P JOIN Trip T
    ON P.trip_no = T.trip_no
  ) AS T
)
SELECT name
FROM (
  SELECT A.ID_psg
  FROM T AS A JOIN T AS B
  ON A.n = B.n - 1
  AND A.ID_psg = B.ID_psg AND A.place = B.place
) AS R JOIN Passenger P
ON R.ID_psg = P.ID_psg
GROUP BY R.ID_psg, name


-- #126
WITH T AS (
  SELECT ID_psg, name, COUNT(trip_no) cnt
  FROM (
    SELECT P.ID_psg, name, trip_no
    FROM Passenger P LEFT JOIN Pass_in_trip T
    ON P.ID_psg = T.ID_psg
  ) AS T
  GROUP BY ID_psg, name
),
T2 AS (
  SELECT ROW_NUMBER() OVER(ORDER BY T.ID_psg) n, name, cnt,
  LAG(name) OVER(ORDER BY T.ID_psg) before,
  LEAD(name) OVER(ORDER BY T.ID_psg) after
  FROM T
)
SELECT name,
CASE 
  WHEN before IS NULL 
  THEN (SELECT name FROM T2 WHERE n = (SELECT MAX(n) FROM T2))
  ELSE before
END before,
CASE 
  WHEN after IS NULL
  THEN (SELECT name FROM T2 WHERE n = 1)
  ELSE after
END after
FROM T2
WHERE cnt = (SELECT MAX(cnt) FROM T2)


-- #127
WITH PC1 AS (
  SELECT maker, P.model, type, code, speed, ram, hd, cd, price,
  CONVERT(INT, LEFT(cd, LEN(cd) - 1)) cd_int
  FROM Product P JOIN PC
  ON P.model = PC.model
),
L1 AS (
  SELECT maker, P.model, type, code, speed, ram, hd, price, screen
  FROM Product P JOIN Laptop L
  ON P.model = L.model
),
P1 AS (
  SELECT maker, P.model, P.type, code, color, Pr.type AS pr_type, price
  FROM Product P JOIN Printer Pr
  ON P.model = Pr.model
),
Low_cd AS (
  SELECT DISTINCT maker FROM PC1
  WHERE cd_int = (SELECT MIN(cd_int) FROM PC1)
),
RES1 AS (
  SELECT MIN(price) price
  FROM L1
  WHERE maker IN (SELECT * FROM Low_cd)
),
Low_pr AS (
  SELECT DISTINCT maker
  FROM P1
  WHERE price = (SELECT MIN(price) FROM P1)
),
RES2 AS (
  SELECT MAX(price) price
  FROM PC1
  WHERE maker IN (SELECT * FROM Low_pr)
),
High_ram AS (
  SELECT DISTINCT maker
  FROM L1
  WHERE ram = (SELECT MAX(ram) FROM L1)
),
RES3 AS (
  SELECT MAX(price) price
  FROM P1
  WHERE maker IN (SELECT * FROM High_ram)
),
RES AS (
SELECT * FROM RES1
    UNION ALL
  SELECT * FROM RES2
    UNION ALL
  SELECT * FROM RES3
)
SELECT CONVERT(DECIMAL(8, 2), AVG(price)) avg_val
FROM RES


-- #128
WITH P AS (
  SELECT DISTINCT point
  FROM Outcome
    INTERSECT
  SELECT DISTINCT point
  FROM Outcome_o
), 
O AS (
  SELECT point, date, SUM(out) out
  FROM Outcome
  GROUP BY date, point
),
T AS (
  SELECT COALESCE(O.point, O2.point) point,
  COALESCE(O.date, O2.date) date,
  COALESCE(O.out, 0) out1,
  COALESCE(O2.out, 0) out2
  FROM O FULL JOIN Outcome_o O2
  ON O.point = O2.point AND O.date = O2.date
)
SELECT point, date,
CASE 
  WHEN out1 > out2 THEN 'more than once a day' 
  WHEN out1 = out2 THEN 'both'
  ELSE 'once a day'
END lider
FROM T
WHERE point IN (SELECT * FROM P)


-- #129
WITH T AS (
  SELECT ROW_NUMBER() OVER(ORDER BY Q_ID) n, Q_ID
  FROM utQ
),
R AS (
  SELECT A, 
  CASE WHEN dif > 1 THEN B ELSE NULL END B
  FROM (
    SELECT A.Q_ID AS A, B.Q_ID AS B, B.Q_ID - A.Q_ID dif
    FROM T A LEFT JOIN T B
    ON B.n = A.n + 1
  ) AS T
),
R2 AS (
  SELECT A + 1 AS prev, B - 1 AS next
  FROM R
  WHERE B IS NOT NULL
)
SELECT MIN(prev), MAX(next)
FROM R2


-- #130
WITH N AS (
  SELECT ROW_NUMBER() OVER(ORDER BY date, name) n, *,
  (SELECT COUNT(*) FROM Battles) cnt
  FROM Battles
),
GR AS (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY gr ORDER BY n) num
  FROM (
    SELECT *, CASE 
      WHEN cnt % 2 = 0 THEN 
        CASE WHEN n <= cnt / 2 THEN 1 ELSE 2 END
      ELSE
        CASE WHEN n <= cnt / 2 + 1 THEN 1 ELSE 2 END
    END gr
    FROM N
  ) AS T
)
SELECT A.n, A.name, A.date, B.n, B.name, B.date
FROM (SELECT * FROM GR WHERE gr = 1) AS A
LEFT JOIN (SELECT * FROM GR WHERE gr = 2) AS B
ON A.num = B.num