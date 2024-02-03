library(RMySQL)
library(RSQLite)
library(DBI)
db_user <- 'root'
db_password <- 'Password123'
db_name <- "5200_practicum2"
db_host <- 'localhost'
db_port <- 3306
mydb <-  dbConnect(MySQL(), user = db_user, password = db_password, host = db_host, port = db_port)
# dbSendQuery(mydb, "CREATE DATABASE 5200_practicum2;")
dbSendQuery(mydb, "USE 5200_practicum2")
mydb <-  dbConnect(MySQL(), user = db_user, password = db_password, dbname = db_name, host = db_host, port = db_port)
dbSendQuery(mydb, "SET GLOBAL local_infile = true;")
litedb <- dbConnect(RSQLite::SQLite(), "PubMedDB")
dbExecute(litedb, "PRAGMA foreign_keys = OFF;")

dbSendQuery(mydb, "DROP TABLE IF EXISTS AuthorFacts;")
dbSendQuery(mydb, "CREATE TABLE IF NOT EXISTS AuthorFacts (
            AID INT NOT NULL,
            ForeName TEXT NOT NULL,
            LastName TEXT NOT NULL,
            Initials TEXT NOT NULL,
            NumArticles INT NOT NULL,
            NumCoAuthors INT NOT NULL,
            PRIMARY KEY (AID));")

dbSendQuery(mydb, "drop table if exists JournalFacts;")
dbSendQuery(mydb, "CREATE TABLE IF NOT EXISTS JournalFacts (
            JID INT not null,
            Title TEXT NOT NULL,
            Yearly INT NOT NULL,
            Quarterly INT NOT NULL,
            Monthly INT NOT NULL,
            PRIMARY KEY (JID));")

AuthorFacts.df <- data.frame(AID = vector("integer", nrow(extractedData)),
                             LastName = vector("character", nrow(extractedData)), 
                             ForeName = vector("character", nrow(extractedData)),
                             Initials = vector("character", nrow(extractedData)),
                             NumArticles = vector("integer", nrow(extractedData)),
                             NumCoAuthors = vector("integer", nrow(extractedData)),
                             stringsAsFactors = FALSE)

AuthorFacts.df$AID = extractedData$AID
AuthorFacts.df$LastName = extractedData$LastName
AuthorFacts.df$ForeName = extractedData$ForeName
AuthorFacts.df$Initials = extractedData$Initials
AuthorFacts.df$NumArticles = extractedData$NumArticles
AuthorFacts.df$NumCoAuthors = extractedData$NumCoAuthors

dbWriteTable(mydb, "AuthorFacts", AuthorFacts.df, row.names = FALSE, overwrite = FALSE, append = TRUE)

extractedJournalData = dbGetQuery(litedb, 
                                  "SELECT j.JID, j.Title, COUNT(*) AS num_articles_year, 
    COUNT(*) / 4 AS num_articles_quarter, 
    COUNT(*) / 12 AS num_articles_month
FROM Article a
JOIN Journal j ON a.ISSN = j.ISSN
GROUP BY j.Title;")

JournalFacts.df <- data.frame(JID = vector("integer", nrow(extractedJournalData)), 
                              Title = vector("character", nrow(extractedJournalData)),
                              Yearly = vector("integer", nrow(extractedJournalData)),
                              Quarterly = vector("integer", nrow(extractedJournalData)),
                              Monthly = vector("integer", nrow(extractedJournalData)),
                              stringsAsFactors = FALSE)

JournalFacts.df$JID = extractedJournalData$JID
JournalFacts.df$Title = extractedJournalData$Title
JournalFacts.df$Yearly = extractedJournalData$num_articles_year
JournalFacts.df$Quarterly = extractedJournalData$num_articles_quarter
JournalFacts.df$Monthly = extractedJournalData$num_articles_monthD
JournalFacts.df
dbWriteTable(mydb, "JournalFacts", JournalFacts.df, row.names = FALSE, overwrite = FALSE, append = TRUE)