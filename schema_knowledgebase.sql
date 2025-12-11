-- =============================================
-- KnowledgeBase System
-- Database Schema Script (SQL Server)
-- =============================================

-- =============================================
-- Create Database
-- =============================================
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'knowledgebase_db')
BEGIN
    CREATE DATABASE knowledgebase_db;
END
GO

USE knowledgebase_db;
GO


-- =============================================
-- Drop Tables if they exist (clean start)
-- =============================================
IF OBJECT_ID('dbo.borrowings', 'U') IS NOT NULL DROP TABLE dbo.borrowings;
IF OBJECT_ID('dbo.books', 'U') IS NOT NULL DROP TABLE dbo.books;
IF OBJECT_ID('dbo.authors', 'U') IS NOT NULL DROP TABLE dbo.authors;
IF OBJECT_ID('dbo.members', 'U') IS NOT NULL DROP TABLE dbo.members;
IF OBJECT_ID('dbo.branches', 'U') IS NOT NULL DROP TABLE dbo.branches;
GO


-- =============================================
-- TABLE: dbo.authors
-- =============================================
CREATE TABLE dbo.authors (
    author_id       INT NOT NULL PRIMARY KEY,
    author_name     VARCHAR(200) NULL,
    author_country  VARCHAR(100) NULL
);
GO


-- =============================================
-- TABLE: dbo.books
-- =============================================
CREATE TABLE dbo.books (
    book_id       INT NOT NULL PRIMARY KEY,
    title         VARCHAR(500) NULL,
    author_id     INT NULL,
    genre         VARCHAR(100) NULL,
    publish_year  INT NULL,
    isbn          BIGINT NULL,
    pages         INT NULL,
    language      VARCHAR(50) NULL,

    CONSTRAINT FK_books_authors
        FOREIGN KEY (author_id) REFERENCES dbo.authors(author_id)
);
GO

CREATE INDEX IX_books_author_id ON dbo.books(author_id);
GO


-- =============================================
-- TABLE: dbo.members
-- =============================================
CREATE TABLE dbo.members (
    member_id              INT NOT NULL PRIMARY KEY,
    member_name            VARCHAR(200) NULL,
    gender                 VARCHAR(20) NULL,
    age                    INT NULL,
    city                   VARCHAR(100) NULL,
    membership_type        VARCHAR(50) NULL,
    membership_start_date  DATE NULL,
    occupation             VARCHAR(100) NULL,
    phone                  VARCHAR(20) NULL,
    email                  VARCHAR(200) NULL
);
GO


-- =============================================
-- TABLE: dbo.branches
-- =============================================
CREATE TABLE dbo.branches (
    branch_id    INT NOT NULL PRIMARY KEY,
    branch_name  VARCHAR(200) NULL,
    city         VARCHAR(100) NULL,
    state        VARCHAR(100) NULL,
    opened_date  DATE NULL
);
GO


-- =============================================
-- TABLE: dbo.borrowings
-- =============================================
CREATE TABLE dbo.borrowings (
    transaction_id  BIGINT NOT NULL PRIMARY KEY,
    book_id         INT NULL,
    member_id       INT NULL,
    branch_id       INT NULL,
    borrow_date     DATETIME NULL,
    due_date        DATETIME NULL,
    return_date     DATETIME NULL,
    fine_amount     DECIMAL(10,2) NULL,
    status          VARCHAR(50) NULL,
    renewals        INT NULL,
    device_used     VARCHAR(50) NULL,
    rating          INT NULL,

    CONSTRAINT FK_borrowings_books
        FOREIGN KEY (book_id) REFERENCES dbo.books(book_id),

    CONSTRAINT FK_borrowings_members
        FOREIGN KEY (member_id) REFERENCES dbo.members(member_id),

    CONSTRAINT FK_borrowings_branches
        FOREIGN KEY (branch_id) REFERENCES dbo.branches(branch_id)
);
GO

CREATE INDEX IX_borrowings_book_id ON dbo.borrowings(book_id);
CREATE INDEX IX_borrowings_member_id ON dbo.borrowings(member_id);
CREATE INDEX IX_borrowings_branch_id ON dbo.borrowings(branch_id);
GO


-- =============================================
-- Schema Creation Completed
-- =============================================
PRINT 'KnowledgeBase System schema created successfully with dbo. prefixes!';
GO
