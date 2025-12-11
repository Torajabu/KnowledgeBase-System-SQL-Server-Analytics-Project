---------------------------------------------------------
-- KnowledgeBase System - Query Set (SQL Server)
---------------------------------------------------------

---------------------------------------------------------
-- 1. List all Premium members from Chennai.
---------------------------------------------------------
SELECT member_id, member_name, membership_type, city
FROM dbo.members
WHERE city = 'Chennai' AND membership_type = 'Premium';


---------------------------------------------------------
-- 2. Total number of books in the library.
---------------------------------------------------------
SELECT COUNT(*) AS total_books FROM dbo.books;


---------------------------------------------------------
-- 3. Books published after 2015.
---------------------------------------------------------
SELECT title, publish_year
FROM dbo.books
WHERE publish_year > 2015;


---------------------------------------------------------
-- 4. Borrowings that are not returned.
---------------------------------------------------------
SELECT transaction_id, member_id, book_id, borrow_date
FROM dbo.borrowings
WHERE status = 'Borrowed';


---------------------------------------------------------
-- 5. All distinct genres.
---------------------------------------------------------
SELECT DISTINCT genre FROM dbo.books;


---------------------------------------------------------
-- 6. Borrowings count per branch.
---------------------------------------------------------
SELECT branch_id, COUNT(*) AS total_borrowings
FROM dbo.borrowings
GROUP BY branch_id
ORDER BY total_borrowings DESC;


---------------------------------------------------------
-- 7. Top 5 most borrowed books.
---------------------------------------------------------
SELECT TOP 5 b.title, COUNT(*) AS times_borrowed
FROM dbo.borrowings br
JOIN dbo.books b ON br.book_id = b.book_id
GROUP BY b.title
ORDER BY times_borrowed DESC;


---------------------------------------------------------
-- 8. Members with more than 50 borrowings.
---------------------------------------------------------
SELECT m.member_id, m.member_name, COUNT(*) AS total_borrowings
FROM dbo.borrowings br
JOIN dbo.members m ON br.member_id = m.member_id
GROUP BY m.member_id, m.member_name
HAVING COUNT(*) > 50;


---------------------------------------------------------
-- 9. Overdue percentage branch-wise.
---------------------------------------------------------
SELECT branch_id,
       ROUND(SUM(CASE WHEN status='Overdue' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS overdue_pct
FROM dbo.borrowings
GROUP BY branch_id;


---------------------------------------------------------
-- 10. Average fine collected per year.
---------------------------------------------------------
SELECT YEAR(borrow_date) AS year, AVG(fine_amount) AS avg_fine
FROM dbo.borrowings
GROUP BY YEAR(borrow_date)
ORDER BY year;


---------------------------------------------------------
-- 11. Most popular genre overall.
---------------------------------------------------------
SELECT TOP 1 b.genre, COUNT(*) AS total_borrowed
FROM dbo.borrowings br
JOIN dbo.books b ON br.book_id = b.book_id
GROUP BY b.genre
ORDER BY total_borrowed DESC;


---------------------------------------------------------
-- 12. Yearly borrowing trend.
---------------------------------------------------------
SELECT YEAR(borrow_date) AS year, COUNT(*) AS total_borrowings
FROM dbo.borrowings
GROUP BY YEAR(borrow_date)
ORDER BY year;


---------------------------------------------------------
-- 13. Avg books borrowed by Premium vs Regular members.
---------------------------------------------------------
SELECT m.membership_type,
       ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT m.member_id), 2) AS avg_books_borrowed
FROM dbo.borrowings br
JOIN dbo.members m ON br.member_id = m.member_id
GROUP BY m.membership_type;


---------------------------------------------------------
-- 14. Members who borrowed books from more than 3 branches.
---------------------------------------------------------
SELECT member_id, COUNT(DISTINCT branch_id) AS branches_used
FROM dbo.borrowings
GROUP BY member_id
HAVING COUNT(DISTINCT branch_id) > 3;


---------------------------------------------------------
-- 15. Members with highest fines.
---------------------------------------------------------
SELECT TOP 10 m.member_name, SUM(br.fine_amount) AS total_fine
FROM dbo.borrowings br
JOIN dbo.members m ON br.member_id = m.member_id
GROUP BY m.member_name
ORDER BY total_fine DESC;


---------------------------------------------------------
-- 16. Top 5 authors by borrow count.
---------------------------------------------------------
SELECT TOP 5 a.author_name, COUNT(*) AS borrow_count
FROM dbo.borrowings br
JOIN dbo.books b ON br.book_id = b.book_id
JOIN dbo.authors a ON b.author_id = a.author_id
GROUP BY a.author_name
ORDER BY borrow_count DESC;


---------------------------------------------------------
-- 17. Average return delay in days.
---------------------------------------------------------
SELECT ROUND(AVG(DATEDIFF(DAY, due_date, return_date)),2) AS avg_delay_days
FROM dbo.borrowings
WHERE status = 'Overdue';


---------------------------------------------------------
-- 18. Device usage share (Web/Mobile/Kiosk).
---------------------------------------------------------
SELECT device_used,
       COUNT(*) AS total_usage,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dbo.borrowings), 2) AS pct_share
FROM dbo.borrowings
GROUP BY device_used;


---------------------------------------------------------
-- 19. Monthly borrowing trend for last 2 years.
---------------------------------------------------------
SELECT YEAR(borrow_date) AS year,
       MONTH(borrow_date) AS month,
       COUNT(*) AS total_borrowings
FROM dbo.borrowings
WHERE borrow_date >= DATEADD(YEAR, -2, GETDATE())
GROUP BY YEAR(borrow_date), MONTH(borrow_date)
ORDER BY year, month;


---------------------------------------------------------
-- 20. Genre popularity by age group.
---------------------------------------------------------
SELECT 
    CASE 
        WHEN m.age < 18 THEN 'Under 18'
        WHEN m.age BETWEEN 18 AND 30 THEN '18-30'
        WHEN m.age BETWEEN 31 AND 50 THEN '31-50'
        ELSE '50+' 
    END AS age_group,
    b.genre,
    COUNT(*) AS total_borrowings
FROM dbo.borrowings br
JOIN dbo.members m ON br.member_id = m.member_id
JOIN dbo.books b ON br.book_id = b.book_id
GROUP BY 
    CASE 
        WHEN m.age < 18 THEN 'Under 18'
        WHEN m.age BETWEEN 18 AND 30 THEN '18-30'
        WHEN m.age BETWEEN 31 AND 50 THEN '31-50'
        ELSE '50+' 
    END,
    b.genre
ORDER BY age_group, total_borrowings DESC;


---------------------------------------------------------
-- 21. Members who rated more than 10 books.
---------------------------------------------------------
SELECT member_id, COUNT(rating) AS total_ratings
FROM dbo.borrowings
WHERE rating IS NOT NULL
GROUP BY member_id
HAVING COUNT(rating) > 10;


---------------------------------------------------------
-- 22. Top 5 cities with maximum borrowings.
---------------------------------------------------------
SELECT TOP 5 m.city, COUNT(*) AS borrowings
FROM dbo.borrowings br
JOIN dbo.members m ON br.member_id = m.member_id
GROUP BY m.city
ORDER BY borrowings DESC;


---------------------------------------------------------
-- 23. Top 3 branches by revenue from fines.
---------------------------------------------------------
SELECT TOP 3 branch_id, SUM(fine_amount) AS total_fine
FROM dbo.borrowings
GROUP BY branch_id
ORDER BY total_fine DESC;


---------------------------------------------------------
-- 24. Premium vs Regular borrowings per year.
---------------------------------------------------------
SELECT YEAR(br.borrow_date) AS year, m.membership_type, COUNT(*) AS borrowings
FROM dbo.borrowings br
JOIN dbo.members m ON br.member_id = m.member_id
GROUP BY YEAR(br.borrow_date), m.membership_type
ORDER BY year, m.membership_type;


---------------------------------------------------------
-- 25. Top 5 most loyal members.
---------------------------------------------------------
SELECT TOP 5 m.member_name, COUNT(*) AS total_borrowings
FROM dbo.borrowings br
JOIN dbo.members m ON br.member_id = m.member_id
GROUP BY m.member_name
ORDER BY total_borrowings DESC;


---------------------------------------------------------
-- 26. Books that were never borrowed.
---------------------------------------------------------
SELECT b.book_id, b.title
FROM dbo.books b
LEFT JOIN dbo.borrowings br ON b.book_id = br.book_id
WHERE br.book_id IS NULL;


---------------------------------------------------------
-- 27. Genre with highest overdue percentage.
---------------------------------------------------------
SELECT TOP 1 b.genre,
       ROUND(SUM(CASE WHEN br.status='Overdue' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS overdue_pct
FROM dbo.borrowings br
JOIN dbo.books b ON br.book_id = b.book_id
GROUP BY b.genre
ORDER BY overdue_pct DESC;


---------------------------------------------------------
-- 28. Avg borrowing frequency by occupation.
---------------------------------------------------------
SELECT m.occupation,
       ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT m.member_id), 2) AS avg_books_borrowed
FROM dbo.borrowings br
JOIN dbo.members m ON br.member_id = m.member_id
GROUP BY m.occupation
ORDER BY avg_books_borrowed DESC;


---------------------------------------------------------
-- 29. Most active borrowing month each year.
---------------------------------------------------------
SELECT year, month, borrowings
FROM (
    SELECT 
        YEAR(borrow_date) AS year,
        MONTH(borrow_date) AS month,
        COUNT(*) AS borrowings,
        ROW_NUMBER() OVER (
            PARTITION BY YEAR(borrow_date)
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM dbo.borrowings
    GROUP BY YEAR(borrow_date), MONTH(borrow_date)
) AS t
WHERE rn = 1;


---------------------------------------------------------
-- 30. Members with maximum renewals.
---------------------------------------------------------
SELECT TOP 5 m.member_name, SUM(br.renewals) AS total_renewals
FROM dbo.borrowings br
JOIN dbo.members m ON br.member_id = m.member_id
GROUP BY m.member_name
ORDER BY total_renewals DESC;
