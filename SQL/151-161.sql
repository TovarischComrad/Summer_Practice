-- #151
SELECT name
FROM Ships
WHERE launched < 1941
UNION
SELECT ship
FROM Outcomes O JOIN Battles B
ON O.battle = B.name
WHERE YEAR(date) < 1941
UNION
SELECT class
FROM Outcomes O JOIN Ships S
ON O.ship = S.class
WHERE launched < 1941
UNION
SELECT name FROM Ships
WHERE name IN (
  SELECT class FROM Ships
  WHERE launched < 1941
)
UNION
SELECT ship 
FROM Outcomes 
WHERE ship IN (	
  SELECT class 
  FROM Ships S JOIN Outcomes O 
  ON S.name = O.ship JOIN Battles B 
  ON B.name = O.battle 
  WHERE YEAR(date) < 1941
)
UNION
SELECT name
FROM Ships 
WHERE name IN (	
  SELECT class 
  FROM Ships S JOIN Outcomes O 
  ON S.name = O.ship JOIN Battles B 
  ON B.name = O.battle 
  WHERE YEAR(date) < 1941
)


-- #152
WITH T AS (
  SELECT maker, P.model, type, price
  FROM Product P JOIN PC
  ON P.model = PC.model
  UNION ALL
  SELECT maker, P.model, type, price
  FROM Product P JOIN Laptop
  ON P.model = Laptop.model
  UNION ALL
  SELECT maker, P.model, P.type, price
  FROM Product P JOIN Printer
  ON P.model = Printer.model
),
RES AS (
  SELECT maker, SUM(n) cou, COUNT(n) cou2
  FROM (
    SELECT maker, price, COUNT(price) n FROM T
    GROUP BY maker, price
    HAVING COUNT(price) > 1
  ) AS A
  GROUP BY maker
)
SELECT X.maker,
CASE WHEN cou IS NULL THEN 0 ELSE cou END cou,
CASE WHEN cou2 IS NULL THEN 0 ELSE cou2 END cou2
FROM (SELECT DISTINCT maker FROM Product) AS X LEFT JOIN RES
ON X.maker = RES.maker


-- #153
WITH L AS (SELECT ROW_NUMBER() OVER(ORDER BY code) n, * FROM Laptop),
P AS (SELECT ROW_NUMBER() OVER(ORDER BY code) n, * FROM PC),
Pr AS (SELECT ROW_NUMBER() OVER(ORDER BY code) n, * FROM Printer),
L1 AS (SELECT *, CASE WHEN n <= (SELECT COUNT(*) FROM L) / 2 THEN 0 ELSE 1 END fl FROM L),
P1 AS (SELECT *, CASE WHEN n <= (SELECT COUNT(*) FROM P) / 2 THEN 0 ELSE 1 END fl FROM P),
Pr1 AS (SELECT *, CASE WHEN n <= (SELECT COUNT(*) FROM Pr) / 2 THEN 0 ELSE 1 END fl FROM Pr),
RES1 AS (
  SELECT ROW_NUMBER() OVER(ORDER BY code) * 6 - 5 x, 
  'Laptop' AS type, model, price
  FROM L1
  WHERE fl = 0
    UNION 
  SELECT ROW_NUMBER() OVER(ORDER BY code DESC) * 6 - 2 x, 
  'Laptop' AS type, model, price
  FROM L1
  WHERE fl = 1
),
RES2 AS (
  SELECT ROW_NUMBER() OVER(ORDER BY code) * 6 - 4 x, 
  'PC' AS type, model, price
  FROM P1
  WHERE fl = 0
    UNION 
  SELECT ROW_NUMBER() OVER(ORDER BY code DESC) * 6 - 1 x, 
  'PC' AS type, model, price
  FROM P1
  WHERE fl = 1
),
RES3 AS (
  SELECT ROW_NUMBER() OVER(ORDER BY code) * 6 - 3 x, 
  'Printer' AS type, model, price
  FROM Pr1
  WHERE fl = 0
    UNION 
  SELECT ROW_NUMBER() OVER(ORDER BY code DESC) * 6 x, 
  'Printer' AS type, model, price
  FROM Pr1
  WHERE fl = 1
)
SELECT ROW_NUMBER() OVER(ORDER BY x) AS Id, type, model, price
FROM (
  SELECT *
  FROM RES1
    UNION
  SELECT *
  FROM RES2
    UNION
  SELECT *
  FROM RES3
) AS T


-- #154
WITH I1 AS (
  SELECT point, date, SUM(inc) inc
  FROM Income
  GROUP BY point, date
),
O1 AS (
  SELECT point, date, SUM(out) out
  FROM Outcome
  GROUP BY point, date
), 
R1 AS (
  SELECT COALESCE(I1.point, O1.point) point,
  COALESCE(I1.date, O1.date) date, 
  COALESCE(inc, 0) inc, COALESCE(out, 0) out
  FROM O1 FULL JOIN I1
  ON I1.date = O1.date AND I1.point = O1.point
),
R2 AS (
  SELECT COALESCE(I.point, O.point) point,
  COALESCE(I.date, O.date) date, 
  COALESCE(inc, 0) inc, COALESCE(out, 0) out
  FROM Income_o I FULL JOIN Outcome_o O 
  ON I.date = O.date AND I.point = O.point
)
SELECT COALESCE(R1.point, R2.point) point, 
COALESCE(R1.date, R2.date) date,
COALESCE(R1.inc, R2.inc) inc,
COALESCE(R1.out, R2.out) out,
CASE WHEN R1.date IS NULL THEN 'once' ELSE 'several' END how
FROM R1 FULL JOIN R2
ON R1.point = R2.point AND R1.date = R2.date
WHERE R1.date IS NULL OR R2.date IS NULL


-- #155 
WITH D AS (
  SELECT ROW_NUMBER() OVER(ORDER BY date) n, date
  FROM (
    SELECT CONVERT(VARCHAR(100), date, 23) date
    FROM Battles
      UNION
    SELECT CONVERT(VARCHAR(100), GETDATE(), 23) date
  ) AS T
),
R AS (
  SELECT A.date AS date1, B.date AS date2,
  CASE 
    WHEN DAY(B.date) >= DAY(A.date) 
      THEN DATEDIFF(month, A.date, B.date)
    WHEN DAY(B.date) < DAY(A.date) AND DAY(DATEADD(day, 1, B.date)) = 1
      THEN DATEDIFF(month, A.date, B.date)
    WHEN DAY(B.date) < DAY(A.date) AND DAY(DATEADD(day, 1, B.date)) != 1
      THEN DATEDIFF(month, A.date, B.date) - 1
  END mo
  FROM D AS A JOIN D AS B
  ON B.n = A.n + 1
)
SELECT CASE
  WHEN mo = 0 THEN ''
  WHEN mo < 12 THEN CONVERT(VARCHAR(10), mo) + ' m.'
  WHEN mo % 12 != 0 
    THEN CONVERT(VARCHAR(10), mo / 12) + ' y., ' + CONVERT(VARCHAR(10), mo % 12) + ' m.'
  WHEN mo % 12 = 0 THEN CONVERT(VARCHAR(10), mo / 12) + ' y.' 
END age, date1, date2
FROM R


-- #156
WITH T AS (
  SELECT ID_comp, (
    SELECT CAST('' + B.ID_comp AS VARCHAR(MAX))
    FROM Company B
    WHERE B.ID_comp <= A.ID_comp
    FOR XML PATH('')
  ) AS lower_hill, (
    SELECT CAST('' + B.ID_comp AS VARCHAR(MAX))
    FROM Company B
    WHERE B.ID_comp <= A.ID_comp
    ORDER BY B.ID_comp DESC
    OFFSET 1 ROWS
    FOR XML PATH('')
  ) AS upper_hill
  FROM Company A
)
SELECT ID_comp AS top_id, CONCAT(lower_hill, upper_hill) AS hill
FROM T


-- #157 
WITH T AS (
  SELECT C.class, name AS ship
  FROM Ships S JOIN Classes C
  ON S.class = C.class
    UNION
  SELECT ship AS class, ship
  FROM Outcomes
  WHERE ship NOT IN (SELECT name FROM Ships)
),
T2 AS (
  SELECT T.ship, battle, result
  FROM T LEFT JOIN Outcomes O
  ON T.ship = O.ship 
)
SELECT ship AS name, COUNT(battle) AS K
FROM T2
WHERE ship NOT IN (SELECT ship FROM T2 WHERE result = 'sunk')
GROUP BY ship


-- #158
SELECT date,
CASE 
  WHEN prev1 IS NULL AND prev2 IS NULL THEN NULL
  WHEN prev2 IS NULL THEN out - prev1 
  ELSE out - ((prev1 + prev2) / 2)
END out_over
FROM (
  SELECT date, out,
  LAG(out) OVER(ORDER BY date) prev1,
  LAG(out, 2) OVER(ORDER BY date) prev2
  FROM (
    SELECT date, SUM(out) out
    FROM Outcome
    GROUP BY date
  ) AS T
) AS T


-- #159
WITH T AS (
  SELECT 
  A.B_DATETIME AS t, A.B_Q_ID AS q,
  A.B_V_ID AS v, A.B_VOL AS vol, 
  B.B_DATETIME AS tp, B.B_VOL AS volp
  FROM utB AS A LEFT JOIN utB AS B
  ON B.B_DATETIME < A.B_DATETIME AND 
  A.B_Q_ID = B.B_Q_ID AND A.B_V_ID = B.B_V_ID
)
SELECT *
FROM T AS A
WHERE tp = (
  SELECT MAX(tp) 
  FROM T AS B
  WHERE A.t = B.t AND A.q = B.q AND A.v = B.v
) OR tp IS NULL


-- #160
WITH T AS (
  SELECT DISTINCT B_Q_ID, B_V_ID
  FROM utB
),
T2 AS (
  SELECT B_Q_ID, STRING_AGG(B_V_ID,',') WITHIN GROUP(ORDER BY B_V_ID) rn 
  FROM T
  GROUP BY B_Q_ID
)
SELECT A.B_Q_ID AS Q1, B.B_Q_ID AS Q2
FROM T2 AS A, T2 AS B
WHERE A.rn = B.rn AND A.B_Q_ID < B.B_Q_ID


-- #161
WITH T AS (
  SELECT DISTINCT name, YEAR(date) year, date
  FROM Battles
),
T2 AS (
  SELECT A.name, COALESCE(A.launched, B.launched) launched
  FROM Ships A LEFT JOIN Ships B
  ON A.class = B.name
  WHERE A.name NOT IN (SELECT ship FROM Outcomes)
)
SELECT ship, STRING_AGG(battle, ',') WITHIN GROUP(ORDER BY date) AS battle_list
FROM (
  SELECT T2.name AS ship, T.name AS battle, date
  FROM T2 LEFT JOIN T 
  ON launched > year
) AS T
GROUP BY ship
