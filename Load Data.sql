-- =============================================
-- KnowledgeBase System - Data Import Script
-- =============================================

USE knowledgebase_db;
GO

-- =======================================================
-- IMPORT AUTHORS
-- =======================================================
PRINT 'Loading authors data...';

BULK INSERT dbo.authors
FROM 'C:\sql projects\KnowledgeBase System\authors.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);

PRINT 'Authors loaded: ' + CAST((SELECT COUNT(*) FROM dbo.authors) AS VARCHAR(20));
GO


-- =======================================================
-- IMPORT BOOKS
-- =======================================================
PRINT 'Loading books data...';

BULK INSERT dbo.books
FROM 'C:\sql projects\KnowledgeBase System\books.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);

PRINT 'Books loaded: ' + CAST((SELECT COUNT(*) FROM dbo.books) AS VARCHAR(20));
GO


-- =======================================================
-- IMPORT MEMBERS
-- =======================================================
PRINT 'Loading members data...';

BULK INSERT dbo.members
FROM 'C:\sql projects\KnowledgeBase System\members.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);

PRINT 'Members loaded: ' + CAST((SELECT COUNT(*) FROM dbo.members) AS VARCHAR(20));
GO


-- =======================================================
-- IMPORT BRANCHES
-- =======================================================
PRINT 'Loading branches data...';

BULK INSERT dbo.branches
FROM 'C:\sql projects\KnowledgeBase System\branches.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);

PRINT 'Branches loaded: ' + CAST((SELECT COUNT(*) FROM dbo.branches) AS VARCHAR(20));
GO


-- =======================================================
-- IMPORT BORROWINGS  (Very large file — 100+ MB)
-- =======================================================
PRINT 'Loading borrowings data...';

BULK INSERT dbo.borrowings
FROM 'C:\sql projects\KnowledgeBase System\borrowings.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);

PRINT 'Borrowings loaded: ' + CAST((SELECT COUNT(*) FROM dbo.borrowings) AS VARCHAR(20));
GO


-- =======================================================
-- SUMMARY
-- =======================================================
PRINT '';
PRINT '============================================';
PRINT 'KnowledgeBase System - Data Import Summary';
PRINT '============================================';

SELECT 'Authors'    AS TableName, COUNT(*) AS Records FROM dbo.authors
UNION ALL
SELECT 'Books',        COUNT(*) FROM dbo.books
UNION ALL
SELECT 'Members',      COUNT(*) FROM dbo.members
UNION ALL
SELECT 'Branches',     COUNT(*) FROM dbo.branches
UNION ALL
SELECT 'Borrowings',   COUNT(*) FROM dbo.borrowings;

PRINT '';
PRINT 'Data import successfully completed!';
GO
