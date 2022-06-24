-- #91
SELECT CONVERT(NUMERIC(5, 2), AVG(B_VOL))
FROM (
  SELECT Q_ID, CONVERT(NUMERIC(5, 2), SUM(B_VOL)) B_VOL
  FROM (
    SELECT Q_ID, (CASE WHEN B_VOL IS NULL THEN 0 ELSE B_VOL END) B_VOL
    FROM utQ FULL JOIN utB
    ON utQ.Q_ID = utB.B_Q_ID
  ) AS T
  GROUP BY Q_ID
) AS T


-- #92
WITH T AS (
  SELECT *
  FROM utB JOIN utV
  ON utB.B_V_ID = utV.V_ID
),
INF AS (
  SELECT *,
  (SELECT COALESCE(SUM(B_VOL), 0) FROM T AS A WHERE A.B_Q_ID = B.B_Q_ID AND 
  A.B_DATETIME <= B.B_DATETIME AND V_COLOR = 'R') R,
  (SELECT COALESCE(SUM(B_VOL), 0) FROM T AS A WHERE A.B_Q_ID = B.B_Q_ID AND 
  A.B_DATETIME <= B.B_DATETIME AND V_COLOR = 'G') G,
  (SELECT COALESCE(SUM(B_VOL), 0) FROM T AS A WHERE A.B_Q_ID = B.B_Q_ID AND 
  A.B_DATETIME <= B.B_DATETIME AND V_COLOR = 'B') B,
  (SELECT 255 - SUM(B_VOL) FROM T AS A WHERE A.B_V_ID = B.B_V_ID AND A.B_DATETIME <= B.B_DATETIME) AS remains
  FROM T AS B
),
B AS (
  SELECT B_V_ID
  FROM INF
  GROUP BY B_V_ID
  HAVING MIN(remains) = 0
),
RES1 AS (
  SELECT B_Q_ID
  FROM (
    SELECT B_Q_ID, B_V_ID,
    (CASE WHEN B_V_ID IN (SELECT * FROM B) THEN 1 ELSE 0 END) fl
    FROM INF
  ) AS T2
  GROUP BY B_Q_ID
  HAVING SUM(fl) = COUNT(*)
),
RES2 AS (
  SELECT B_Q_ID
  FROM INF
  WHERE R = 255 AND G = 255 AND B = 255
)
SELECT Q_NAME
FROM (
  SELECT *
  FROM RES1
  INTERSECT 
  SELECT * 
  FROM RES2
) R JOIN utQ
ON R.B_Q_ID = utQ.Q_ID


-- #93
SELECT name, SUM(diff)
FROM (
  SELECT name, CASE WHEN dif < 0 THEN 1440 + dif ELSE dif END diff
  FROM (
    SELECT DISTINCT P.trip_no, date, ID_comp, DATEDIFF(minute,time_out, time_in) dif
    FROM Pass_in_trip P JOIN Trip T
    ON P.trip_no = T.trip_no
  ) AS T JOIN Company C
  ON T.ID_comp = C.ID_comp
) AS T
GROUP BY name


-- #94
WITH T AS (
  SELECT date, COUNT(*) n
  FROM (
    SELECT DISTINCT P.trip_no, date
    FROM Pass_in_trip P JOIN Trip T
    ON P.trip_no = T.trip_no
    WHERE town_from = 'Rostov'
  ) AS T
  GROUP BY date
),
T2 AS (
  SELECT MIN(date) date
  FROM (
    SELECT *
    FROM T
    WHERE n = (SELECT MAX(n) FROM T)
  ) AS T2
),
D(date) AS (
  SELECT (SELECT * FROM T2)
  UNION ALL
  SELECT DATEADD(day, 1, date) FROM D WHERE date < DATEADD(day, 6, (SELECT * FROM T2))
)
SELECT D.date, COALESCE(n, 0) n
FROM D LEFT JOIN T
ON D.date = T.date


-- #95
WITH P AS (
  SELECT trip_no, date, place, T.ID_comp, plane, name, ID_psg
  FROM (
    SELECT P.trip_no, date, ID_psg, place, ID_comp, plane
    FROM Pass_in_trip P JOIN Trip T
    ON P.trip_no = T.trip_no
  ) AS T JOIN Company C
  ON T.ID_comp = C.ID_comp
),
T AS (
  SELECT DISTINCT trip_no, date, ID_comp, name
  FROM P
),
A AS (
  SELECT name, SUM(n) flights
  FROM (
    SELECT name, date, COUNT(*) n
    FROM T
    GROUP BY name, date
  ) AS T
  GROUP BY name
),
B AS (
  SELECT name, COUNT(DISTINCT plane) planes, 
  COUNT(DISTINCT ID_psg) passengers,
  COUNT(date) total
  FROM P
  GROUP BY name
)
SELECT A.name, flights, planes, passengers, total
FROM A JOIN B
ON A.name = B.name


-- #96
WITH T AS (
  SELECT *
  FROM utB JOIN utV
  ON utB.B_V_ID = utV.V_ID
),
B AS (
  SELECT V_NAME
  FROM T
  WHERE V_COLOR = 'R'
  GROUP BY V_NAME
  HAVING COUNT(*) > 1
),
INF AS (
  SELECT *,
  (SELECT COALESCE(SUM(B_VOL), 0) FROM T AS A WHERE A.B_Q_ID = B.B_Q_ID AND 
  A.B_DATETIME <= B.B_DATETIME AND V_COLOR = 'R') R,
  (SELECT COALESCE(SUM(B_VOL), 0) FROM T AS A WHERE A.B_Q_ID = B.B_Q_ID AND 
  A.B_DATETIME <= B.B_DATETIME AND V_COLOR = 'G') G,
  (SELECT COALESCE(SUM(B_VOL), 0) FROM T AS A WHERE A.B_Q_ID = B.B_Q_ID AND 
  A.B_DATETIME <= B.B_DATETIME AND V_COLOR = 'B') B
  FROM T AS B
),
Q AS (
  SELECT DISTINCT B_Q_ID
  FROM INF
  WHERE B > 0
),
B2 AS (
  SELECT DISTINCT V_NAME
  FROM Q JOIN INF
  ON Q.B_Q_ID = INF.B_Q_ID
)
SELECT *
FROM B
INTERSECT
SELECT *
FROM B2


-- #97 ***
SELECT code, speed, ram, price, screen
FROM Laptop
WHERE EXISTS (
  SELECT 1 x
  FROM (
    SELECT value, RANK() OVER(ORDER BY value) rank
    FROM (
      SELECT CONVERT(FLOAT, speed) speed, CONVERT(FLOAT, ram) ram,
      CONVERT(FLOAT, price) price, CONVERT(FLOAT, screen) screen
    ) AS T
    UNPIVOT (value FOR spec IN (speed, ram, price, screen)) AS C
  ) AS T
  PIVOT (MAX(value) FOR rank IN ([1], [2], [3], [4])) AS R
  WHERE [1]*2 <= [2] AND [2]*2 <= [3] AND [3]*2 <= [4]
)


-- #98 ***
WITH BIN AS (
  SELECT 1 n, CAST(0 AS VARCHAR(16)) bit,
  code, speed, ram
  FROM PC
  UNION ALL
  SELECT n * 2, 
  CAST(CONVERT(BIT, (speed | ram) & n) AS VARCHAR(1)) + CAST(bit AS VARCHAR(15)),
  code, speed, ram
  FROM BIN
  WHERE n < 65536
)
SELECT code, speed, ram
FROM BIN
WHERE n = 65536
AND bit LIKE '%1111%'


-- #99
WITH T AS (  
  SELECT I.point IP, I.date ID, O.point OP, O.date OD, inc, out
  FROM Income_o I LEFT JOIN Outcome_o O
  ON I.point = O.point AND I.date = O.date
),
T2 AS (
  SELECT IP, ID, 
  CASE WHEN OD IS NULL THEN ID ELSE NULL END DI
  FROM T
),
T3 AS (
  SELECT IP, ID
  FROM T2
  WHERE DI IS NULL
),
REC AS (
  SELECT 1 n, IP, ID
  FROM T3
  UNION ALL
  SELECT n + 1, IP, ID
  FROM REC
  WHERE EXISTS (SELECT * FROM Outcome_o O WHERE O.date = DATEADD(day, n, ID) AND O.point = IP)
  OR DATEPART(WEEKDAY, DATEADD(day, n, ID)) = 1
),
RES AS (
  SELECT IP, ID, DATEADD(day, n, ID) DI
  FROM (
    SELECT IP, ID, MAX(n) n
    FROM REC
    GROUP BY IP, ID
  ) AS T
)
SELECT T2.IP, T2.ID, COALESCE(T2.DI, RES.DI) DI
FROM T2 LEFT JOIN RES
ON T2.IP = RES.IP AND T2.ID = RES.ID


-- #100
WITH I AS (
  SELECT date, COUNT(*) n
  FROM Income
  GROUP BY date
),
O AS (
  SELECT date, COUNT(*) n
  FROM Outcome
  GROUP BY date
),
NUM AS (
  SELECT date, CASE WHEN i > o THEN i ELSE o END n
  FROM (
    SELECT COALESCE(I.date, O.date) date,
    COALESCE(I.n, 0) i, COALESCE(O.n, 0) o
    FROM I FULL JOIN O
    ON I.date = O.date
  ) AS T
),
T AS (
  SELECT date, 1 x, n FROM NUM
  UNION ALL 
  SELECT date, x + 1, n FROM T WHERE x < n
),
I2 AS (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY date ORDER BY code) n
  FROM Income
),
T2 AS (
  SELECT T.date, x, point, inc
  FROM T LEFT JOIN I2 
  ON T.date = I2.date AND T.x = I2.n
),
O2 AS (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY date ORDER BY code) n
  FROM Outcome
)
SELECT T2.date, x, T2.point, inc, O2.point, out
FROM T2 LEFT JOIN O2 
ON T2.date = O2.date AND T2.x = O2.n