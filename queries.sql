USE IranGeo;
GO

-- 1) لیست شهرهای استان آذربایجان شرقی (جوین دوتایی)
SELECT c.cid, c.name AS city, p.name AS province
FROM city c
JOIN province p ON p.pid = c.pid
WHERE p.name = N'آذربایجان شرقی'
ORDER BY c.name;
GO

-- 2) لیست روستاهای استان خراسان رضوی (جوین سه‌تایی)
SELECT v.vid, v.name AS village, c.name AS city, p.name AS province
FROM village v
JOIN city c ON c.cid = v.cid
JOIN province p ON p.pid = c.pid
WHERE p.name = N'خراسان رضوی'
ORDER BY c.name, v.name;
GO

-- 3) نام روستاهایی که در چند شهر وجود دارند (سلف جوین)
-- برای سرعت بیشتر یک بار این ایندکس را بسازید:
-- CREATE INDEX IX_village_name ON village(name) INCLUDE (cid);
SELECT DISTINCT v1.name AS village
FROM village v1
JOIN village v2 ON v1.name = v2.name AND v1.cid <> v2.cid
ORDER BY v1.name;
GO

-- 4) لیست شهرهایی که روستا ندارند (left join)
SELECT c.cid, c.name AS city, p.name AS province
FROM city c
LEFT JOIN village v ON v.cid = c.cid
JOIN province p ON p.pid = c.pid
WHERE v.vid IS NULL
ORDER BY p.name, c.name;
GO

-- 5) نام استان‌ها به همراه تعداد شهرهای هرکدام (group by)
SELECT p.name AS province, COUNT(c.cid) AS city_count
FROM province p
LEFT JOIN city c ON c.pid = p.pid
GROUP BY p.pid, p.name
ORDER BY city_count DESC, p.name;
GO

-- 6) شهرهایی که بیشتر از 20 روستا دارند (group by + having)
SELECT c.cid, c.name AS city, p.name AS province, COUNT(v.vid) AS village_count
FROM city c
JOIN village v ON v.cid = c.cid
JOIN province p ON p.pid = c.pid
GROUP BY c.cid, c.name, p.name
HAVING COUNT(v.vid) > 20
ORDER BY village_count DESC;
GO

-- 7) نام شهرها به همراه تعداد روستاها (group by؛ شهرهای بدون روستا با عدد 0)
SELECT c.name AS city, COUNT(v.vid) AS village_count
FROM city c
LEFT JOIN village v ON v.cid = c.cid
GROUP BY c.cid, c.name
ORDER BY village_count DESC, c.name;
GO

-- 8) استان‌هایی که کمتر از 10 شهر دارند، از کمترین به بیشترین (group by + having)
SELECT p.name AS province, COUNT(c.cid) AS city_count
FROM province p
LEFT JOIN city c ON c.pid = p.pid
GROUP BY p.pid, p.name
HAVING COUNT(c.cid) < 10
ORDER BY city_count ASC, p.name;
GO

-- 9) (دلخواه) استان‌هایی که مجموع روستاهایشان بیش از 5000 است (join سه‌تایی + group by + having)
SELECT p.name AS province, COUNT(v.vid) AS village_count
FROM province p
JOIN city c ON c.pid = p.pid
JOIN village v ON v.cid = c.cid
GROUP BY p.pid, p.name
HAVING COUNT(v.vid) > 5000
ORDER BY village_count DESC;
GO

-- 10) (دلخواه) نام شهرهایی که در بیش از یک استان وجود دارند (group by + having)
SELECT c.name AS city, COUNT(DISTINCT c.pid) AS province_count
FROM city c
GROUP BY c.name
HAVING COUNT(DISTINCT c.pid) > 1
ORDER BY province_count DESC, c.name;
GO
