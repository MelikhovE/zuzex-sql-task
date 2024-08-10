-- task 1

SELECT u.Id, u.DisplayName
FROM Users u
LEFT JOIN Posts p ON u.Id = p.OwnerUserId
LEFT JOIN Comments c ON u.Id = c.UserId
WHERE p.Id IS NULL AND c.Id IS NULL;

SELECT u.Id, u.DisplayName
FROM Users u
WHERE u.Id NOT IN (SELECT OwnerUserId FROM Posts)
  AND u.Id NOT IN (SELECT UserId FROM Comments);

SELECT u.Id, u.DisplayName
FROM Users u
WHERE NOT EXISTS (SELECT 1 FROM Posts p WHERE p.OwnerUserId = u.Id)
  AND NOT EXISTS (SELECT 1 FROM Comments c WHERE c.UserId = u.Id);
  
-- task 2

SELECT YEAR(p.CreationDate) AS Year, 
       COUNT(DISTINCT p.Id) AS PostCount, 
       COUNT(c.Id) AS CommentCount
FROM Posts p
LEFT JOIN Comments c ON p.Id = c.PostId AND YEAR(c.CreationDate) = YEAR(p.CreationDate)
WHERE YEAR(p.CreationDate) = 2024 -- Any year to choose
GROUP BY YEAR(p.CreationDate);

-- task 3

SELECT u.DisplayName, COUNT(c.Id) AS comment_count
FROM Users u
JOIN Comments c ON u.Id = c.UserId
GROUP BY u.DisplayName
ORDER BY comment_count DESC
LIMIT 3;

-- task 4

WITH CommentCounts AS (
    SELECT u.DisplayName, COUNT(c.Id) AS CommentCount
    FROM Users u
    JOIN Comments c ON u.Id = c.UserId
    GROUP BY u.DisplayName
),
TotalComments AS (
    SELECT SUM(CommentCount) AS TotalCommentCount
    FROM CommentCounts
)
SELECT cc.DisplayName as display_name, 
       cc.CommentCount as comment_count, 
       CONCAT(ROUND((cc.CommentCount / tc.TotalCommentCount) * 100), '%') AS percentage_total
FROM CommentCounts cc, TotalComments tc
ORDER BY cc.CommentCount DESC
LIMIT 3;