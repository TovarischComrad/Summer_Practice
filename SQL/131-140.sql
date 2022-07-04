-- #131
WITH City AS (
  SELECT town_from AS town FROM Trip
    UNION
  SELECT town_to FROM Trip
),
Vowels AS (
  SELECT 'a' v UNION ALL SELECT 'e' UNION ALL SELECT 'i'
    UNION ALL
  SELECT 'o' UNION ALL SELECT 'u'
),
INF AS (
  SELECT town, REPLACE(town, v, '') r, v, 
  DATALENGTH(town) - DATALENGTH(REPLACE(town, v, '')) n
  FROM City, Vowels
)
SELECT DISTINCT town
FROM (
  SELECT *,
  COUNT(*) OVER(PARTITION BY town) cnt,
  MIN(n) OVER(PARTITION BY town) mn,
  MAX(n) OVER(PARTITION BY town) mx
  FROM INF
  WHERE n > 0 
) AS T
WHERE cnt > 1 AND mn = mx


-- #132
WITH BIN AS (
  SELECT trip_no, trip_no AS n, CONVERT(VARCHAR(MAX), '') bin
  FROM Trip
    UNION ALL
  SELECT trip_no, n / 2, 
  CONVERT(VARCHAR(MAX), n % 2) + bin
  FROM BIN
  WHERE n > 0
)
SELECT trip_no, bin
FROM BIN
WHERE n = 0


-- #133
WITH T AS (
  SELECT ROW_NUMBER() OVER(PARTITION BY gr ORDER BY n) num, *
  FROM (
    SELECT *,
    CASE 
      WHEN n % 3 = 1 THEN 1
      WHEN n % 3 = 2 THEN 2
      ELSE 3
    END gr
    FROM (SELECT ROW_NUMBER() OVER(ORDER BY Q_ID) n, * FROM utQ) AS T
  ) AS T
),
A AS (SELECT num, Q_ID FROM T WHERE gr = 1),
B AS (SELECT num, Q_ID FROM T WHERE gr = 2),
C AS (SELECT num, Q_ID FROM T WHERE gr = 3)
SELECT X, Y, C.Q_ID AS Z
FROM (
  SELECT A.num, A.Q_ID AS X, B.Q_ID AS Y
  FROM A LEFT JOIN B 
  ON A.num = B.num
) AS T
LEFT JOIN C ON T.num = C.num


-- #134
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
  (SELECT 255 - SUM(B_VOL) FROM T AS A WHERE A.B_V_ID = B.B_V_ID AND 
  A.B_DATETIME <= B.B_DATETIME) AS remains
  FROM T AS B
),
SQR AS (
  SELECT *
  FROM (
    SELECT Q_ID, 
    COALESCE(R, 0) R, COALESCE(G, 0) G, COALESCE(B, 0) B
    FROM (
      SELECT B_Q_ID, MAX(R) R, MAX(G) G, MAX(B) B
      FROM INF
      GROUP BY B_Q_ID
    ) AS T RIGHT JOIN utQ
    ON T.B_Q_ID = utQ.Q_ID
  ) AS T
  WHERE R != 255 OR G != 255 OR B != 255
),
COL AS (
  SELECT V_COLOR, SUM(remains) remains
  FROM ( 
    SELECT V_ID, utV.V_COLOR, 
    COALESCE(remains, 255) remains
    FROM (
      SELECT B_V_ID, V_COLOR, MIN(remains) remains
      FROM INF
     GROUP BY B_V_ID, V_COLOR
    ) AS T RIGHT JOIN utV
    ON T.B_V_ID = utV.V_ID
  ) AS T
  GROUP BY V_COLOR
),
Red AS (
  SELECT ROW_NUMBER() OVER(ORDER BY R DESC, Q_ID ASC) n, Q_ID, 255 - R AS R
  FROM SQR
), 
Red_rem AS (
  SELECT Q_ID
  FROM (
    SELECT *, 
    (SELECT SUM(R) FROM Red AS B WHERE B.n <= A.n) sum,
    (SELECT remains FROM COL WHERE V_COLOR = 'R') x
    FROM Red AS A
  ) AS T
  WHERE x - sum < 0
),
Green AS (
  SELECT ROW_NUMBER() OVER(ORDER BY G DESC, Q_ID ASC) n, Q_ID, 255 - G AS G
  FROM SQR
), 
Green_rem AS (
  SELECT Q_ID
  FROM (
    SELECT *, 
    (SELECT SUM(G) FROM Green AS B WHERE B.n <= A.n) sum,
    (SELECT remains FROM COL WHERE V_COLOR = 'G') x
    FROM Green AS A
  ) AS T
  WHERE x - sum < 0
),
Blue AS (
  SELECT ROW_NUMBER() OVER(ORDER BY B DESC, Q_ID ASC) n, Q_ID, 255 - B AS B
  FROM SQR
), 
Blue_rem AS (
  SELECT Q_ID
  FROM (
    SELECT *, 
    (SELECT SUM(B) FROM Blue AS B WHERE B.n <= A.n) sum,
    (SELECT remains FROM COL WHERE V_COLOR = 'B') x
    FROM Blue AS A
  ) AS T
  WHERE x - sum < 0
)
SELECT *
FROM Blue_rem
  UNION 
SELECT *
FROM Green_rem
  UNION 
SELECT *
FROM Red_rem


-- #135
SELECT MAX(B_DATETIME) AS max_time
FROM utB
GROUP BY CAST(B_DATETIME AS date), DATEPART(hour, B_DATETIME)


-- #136
SELECT *
FROM (
  SELECT name, 
  PATINDEX('%[^A-Za-z]%', name) n, 
  SUBSTRING(name, PATINDEX('%[^A-Za-z]%', name), 1) let 
  FROM Ships
) AS T
WHERE n > 0


-- #137
WITH T AS (
  SELECT model, price FROM PC
    UNION ALL
  SELECT model, price FROM Printer
    UNION ALL
  SELECT model, price FROM Laptop
),
T2 AS (
  SELECT ROW_NUMBER() OVER(ORDER BY model) n, * 
  FROM (
    SELECT P.model, type, AVG(price) avg_price
    FROM Product P LEFT JOIN T
    ON P.model = T.model
    GROUP BY P.model, type
  ) AS T
)
SELECT type, avg_price
FROM T2
WHERE n % 5 = 0


-- #138
WITH T AS (
  SELECT ID_psg, P.trip_no, town_from, town_to
  FROM Pass_in_trip P JOIN Trip T
  ON P.trip_no = T.trip_no
),
C AS (
  SELECT ID_psg, town_from AS town
  FROM T
  GROUP BY ID_psg, town_from
    UNION
  SELECT ID_psg, town_to
  FROM T
  GROUP BY ID_psg, town_to
),
R AS (
  SELECT name, COUNT(*) cnt
  FROM C JOIN Passenger P 
  ON C.ID_psg = P.ID_psg
  GROUP BY name
)
SELECT name
FROM R
WHERE cnt = (SELECT MAX(cnt) FROM R)


-- #139
SELECT DISTINCT country
FROM Classes
  EXCEPT
SELECT *
FROM (
  SELECT DISTINCT country
  FROM (
    SELECT ship, class
    FROM Outcomes O JOIN Ships S
    ON O.ship = S.name
  ) AS T JOIN Classes C
  ON T.class = C.class
    UNION
  SELECT DISTINCT country
  FROM Outcomes O JOIN Classes C
  ON O.ship = C.class
) AS T


-- #140
WITH T AS (
  SELECT MIN(YEAR(date) / 10) mn, MAX(YEAR(date) / 10) mx 
  FROM Battles
),
R AS (
  SELECT mn AS date, '' AS name
  FROM T
    UNION ALL
  SELECT date + 1, '' 
  FROM R
  WHERE date < (SELECT mx FROM T)
),
R2 AS (
  SELECT CONVERT(VARCHAR(10), YEAR(date) / 10 * 10) + 's' AS years, name
  FROM Battles
    UNION ALL
  SELECT CONVERT(VARCHAR(10), date * 10) + 's' AS years, name
  FROM R
)
SELECT years, SUM(fl) AS battles
FROM (
  SELECT *, 
  CASE WHEN name = '' THEN 0 ELSE 1 END fl
  FROM R2
) AS T
GROUP BY years