library(RSQLite)
library(XML)
library(DBI)
con <- dbConnect(RSQLite::SQLite(), "PubMedDB")
dbExecute(con, "PRAGMA foreign_keys = OFF;")
dbExecute(con, "DROP TABLE if exists Author;")
dbExecute(con, "CREATE TABLE if not exists Author (AID INTEGER NOT NULL, LastName TEXT, ForeName TEXT, Initials TEXT, Suffix TEXT, AffiliationInfo TEXT, CollectiveName TEXT, CONSTRAINT PK_Author PRIMARY KEY (AID));")
dbExecute(con, "DROP TABLE if exists Journal;")
dbExecute(con, "CREATE TABLE if not exists Journal (JID TEXT NOT NULL, ISSN TEXT NOT NULL, Title TEXT NOT NULL, CONSTRAINT PK_Journal PRIMARY KEY (JID));")
dbExecute(con, "DROP TABLE if exists Article;")
dbExecute(con, "CREATE TABLE if not exists Article (PMID INTEGER NOT NULL, ISSN TEXT NOT NULL, ArticleTitle INTEGER NOT NULL, Year INTEGER, Month TEXT, CONSTRAINT PK_Article PRIMARY KEY (PMID), CONSTRAINT has FOREIGN KEY (ISSN) REFERENCES Journal (ISSN));")
dbExecute(con, "DROP TABLE if exists AuthorList;")
dbExecute(con, "CREATE TABLE if not exists AuthorList (PMID INTEGER NOT NULL, AID INTEGER NOT NULL, CONSTRAINT PK_AuthorList PRIMARY KEY (PMID, AID), CONSTRAINT has FOREIGN KEY (PMID) REFERENCES Article (PMID), CONSTRAINT has FOREIGN KEY (AID) REFERENCES Author (AID));")
xml_doc<-xmlParse("pubmed-tfm-xml/pubmed22n0001-tf.xml")
xml_tree <- xmlTreeParse("pubmed-tfm-xml/pubmed22n0001-tf.xml")
root = xmlRoot(xml_doc)
treeRoot = xmlRoot(xml_tree)
totalArticles = length(names(treeRoot))
author.df<- xmlToDataFrame(getNodeSet(xml_doc, "//Author"))
xmlGetValue <- function(x, node){
  a <- xpathSApply(x, node, xmlValue)
  ifelse(length(a) == 0, "NA",  a)
}
PMID <- xpathSApply(xml_doc, '//Article/@PMID')
ISSN <- xpathSApply(xml_doc, '//Article/PubDetails/Journal', xmlGetValue, "./ISSN")
ArticleTitle <- xpathSApply(xml_doc, '//Article/PubDetails/ArticleTitle', xmlValue)
Year <- xpathSApply(xml_doc, '//Article/PubDetails/Journal/JournalIssue/PubDate', xmlGetValue, "./Year")
Month <- xpathSApply(xml_doc, '//Article/PubDetails/Journal/JournalIssue/PubDate', xmlGetValue, "./Month")

#Journal table
#Use ISSN from previous extraction
Title<-xpathSApply(xml_doc, '//Article/PubDetails/Journal', xmlGetValue, "./Title")
#Article DataFrame
df.Article<-data.frame("PMID"=PMID,"ISSN"=ISSN,"ArticleTitle"=ArticleTitle,"Year"=Year,"Month"=Month)

#Journal DataFrame
df.Journal<-data.frame("ISSN"=ISSN, "Title"=Title)

df.Journal <- df.Journal[!duplicated(df.Journal),]
df.Article <- df.Article[!duplicated(df.Article),]
author.df <- author.df[!duplicated(author.df),]
df.Author<-tibble::rowid_to_column(author.df, "AID")
df.Journal<-tibble::rowid_to_column(df.Journal, "JID")

authorList.df <- data.frame(PMID = character(), lName = character(), fName = character(), stringsAsFactors = FALSE)

for (i in 1:5000){
  currentArt <- treeRoot[[ i ]]
  tempAuthList = currentArt[[1]][["AuthorList"]]
  for (j in 1:length(tempAuthList)){
    xmlLName = tempAuthList[[j]][["LastName"]]
    xmlFName = tempAuthList[[j]][["ForeName"]]
    lName <- ifelse(!is.null(xmlLName), xmlSApply(xmlLName, xmlValue), "")
    fName <- ifelse(!is.null(xmlFName), xmlSApply(xmlFName, xmlValue), "")
    authorList.df <- rbind(authorList.df, list(PMID = i, LName = lName, FName = fName))
  }
}

for (i in 5001:10000){
  currentArt <- treeRoot[[ i ]]
  tempAuthList = currentArt[[1]][["AuthorList"]]
  for (j in 1:length(tempAuthList)){
    xmlLName = tempAuthList[[j]][["LastName"]]
    xmlFName = tempAuthList[[j]][["ForeName"]]
    lName <- ifelse(!is.null(xmlLName), xmlSApply(xmlLName, xmlValue), "")
    fName <- ifelse(!is.null(xmlFName), xmlSApply(xmlFName, xmlValue), "")
    authorList.df <- rbind(authorList.df, list(PMID = i, LName = lName, FName = fName))
  }
}

for (i in 10001:15000){
  currentArt <- treeRoot[[ i ]]
  tempAuthList = currentArt[[1]][["AuthorList"]]
  for (j in 1:length(tempAuthList)){
    xmlLName = tempAuthList[[j]][["LastName"]]
    xmlFName = tempAuthList[[j]][["ForeName"]]
    lName <- ifelse(!is.null(xmlLName), xmlSApply(xmlLName, xmlValue), "")
    fName <- ifelse(!is.null(xmlFName), xmlSApply(xmlFName, xmlValue), "")
    authorList.df <- rbind(authorList.df, list(PMID = i, LName = lName, FName = fName))
  }
}

for (i in 15001:20000){
  currentArt <- treeRoot[[ i ]]
  tempAuthList = currentArt[[1]][["AuthorList"]]
  for (j in 1:length(tempAuthList)){
    xmlLName = tempAuthList[[j]][["LastName"]]
    xmlFName = tempAuthList[[j]][["ForeName"]]
    lName <- ifelse(!is.null(xmlLName), xmlSApply(xmlLName, xmlValue), "")
    fName <- ifelse(!is.null(xmlFName), xmlSApply(xmlFName, xmlValue), "")
    authorList.df <- rbind(authorList.df, list(PMID = i, LName = lName, FName = fName))
  }
}

for (i in 20001:25000){
  currentArt <- treeRoot[[ i ]]
  tempAuthList = currentArt[[1]][["AuthorList"]]
  for (j in 1:length(tempAuthList)){
    xmlLName = tempAuthList[[j]][["LastName"]]
    xmlFName = tempAuthList[[j]][["ForeName"]]
    lName <- ifelse(!is.null(xmlLName), xmlSApply(xmlLName, xmlValue), "")
    fName <- ifelse(!is.null(xmlFName), xmlSApply(xmlFName, xmlValue), "")
    authorList.df <- rbind(authorList.df, list(PMID = i, LName = lName, FName = fName))
  }
}

for (i in 25001:30000){
  currentArt <- treeRoot[[ i ]]
  tempAuthList = currentArt[[1]][["AuthorList"]]
  for (j in 1:length(tempAuthList)){
    xmlLName = tempAuthList[[j]][["LastName"]]
    xmlFName = tempAuthList[[j]][["ForeName"]]
    lName <- ifelse(!is.null(xmlLName), xmlSApply(xmlLName, xmlValue), "")
    fName <- ifelse(!is.null(xmlFName), xmlSApply(xmlFName, xmlValue), "")
    authorList.df <- rbind(authorList.df, list(PMID = i, LName = lName, FName = fName))
  }
}

tempAuthList.df <- merge(x=df.Author,y=authorList.df, by.x=c('LastName','ForeName'), by.y=c("LName","FName"))

df.AuthorList<-tempAuthList.df[, c('PMID', 'AID')]

dbWriteTable(con, "Author", df.Author, append = TRUE)
dbWriteTable(con, "Journal", df.Journal, append = TRUE)
dbWriteTable(con, "Article", df.Article, append = TRUE)
dbWriteTable(con, "AuthorList", df.AuthorList, overwrite = TRUE)

dbDisconnect(con)