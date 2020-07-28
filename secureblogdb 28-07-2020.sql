-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: secureblogdb
-- ------------------------------------------------------
-- Server version	8.0.19

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `AdminID` tinyint NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  PRIMARY KEY (`AdminID`),
  UNIQUE KEY `AdminID_UNIQUE` (`AdminID`),
  KEY `fk_admin_UserID_idx` (`UserID`),
  CONSTRAINT `fk_admin_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,102939),(2,283287),(4,437954),(3,734752);
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `CommentID` smallint NOT NULL AUTO_INCREMENT,
  `PostID` smallint NOT NULL,
  `UserID` int NOT NULL,
  `DatetimePosted` datetime NOT NULL,
  `Content` mediumtext NOT NULL,
  `Upvotes` mediumint NOT NULL,
  `Downvotes` mediumint NOT NULL,
  PRIMARY KEY (`CommentID`),
  UNIQUE KEY `DatetimePosted_UNIQUE` (`DatetimePosted`),
  UNIQUE KEY `CommentID_UNIQUE` (`CommentID`),
  KEY `fk_comment_PostID_idx` (`PostID`),
  KEY `fk_comment_UserID_idx` (`UserID`),
  CONSTRAINT `fk_comment_PostID` FOREIGN KEY (`PostID`) REFERENCES `post` (`PostID`) ON DELETE CASCADE,
  CONSTRAINT `fk_comment_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (1,3,437954,'2020-06-22 17:59:18','I prefer using single quotes as it saves me effort from pressing the \'Shift\' button hahhaha. The only time I use double quotes is when I wish to print out single quotes. For example, print(\"I\'m using single quotes in this sentence, hence I\'ve to use double quotes to surround it.\")',0,0),(2,3,193006,'2020-06-22 18:18:29','Just use whichever you want. It doesn\'t make a difference. It does annoy me tho when working with others on the same project and everyone doesn\'t standardise the use of quotations....',0,0);
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_votes`
--

DROP TABLE IF EXISTS `comment_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment_votes` (
  `UserID` int NOT NULL,
  `CommentID` smallint NOT NULL,
  `Vote` tinyint NOT NULL,
  PRIMARY KEY (`UserID`,`CommentID`),
  KEY `fk_comment_votes_CommentID_idx` (`CommentID`),
  CONSTRAINT `fk_coment_votes_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_comment_votes_CommentID` FOREIGN KEY (`CommentID`) REFERENCES `comment` (`CommentID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_votes`
--

LOCK TABLES `comment_votes` WRITE;
/*!40000 ALTER TABLE `comment_votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `FeedbackID` tinyint NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `Reason` tinytext NOT NULL,
  `Content` mediumtext NOT NULL,
  `DatetimePosted` datetime NOT NULL,
  PRIMARY KEY (`FeedbackID`),
  UNIQUE KEY `FeedbackID_UNIQUE` (`FeedbackID`),
  UNIQUE KEY `DatetimePosted_UNIQUE` (`DatetimePosted`),
  KEY `fk_feedback_UserID_idx` (`UserID`),
  CONSTRAINT `fk_feedback_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (1,621235,'ZAP','XhZKfdujvPjYPGdaOMdybehjWbfuvkKrFmectyYRuMibWyuLiAxYXWexxkHjXWhRmmsNoptIgMcTqBwKkqlVyciPwBYfwOedYIoUSdjKSrKHlZgsqhxCWRtMnYgaGCCUaccwxTPVhoFXOKZFvwbkUMExHHoESuaZWSvxIjdHvEKdFAXyulkJOdvwPbWxjZjrtAVXDwvyPImNSSPWdOMUjnwZoFrNrfcrlZDOdKUoZcUtUCZRvWVwIweDwDhlRQplDFrXiZCfRNtCJActGtUTKNIFEYAsVNPbdrZwqvpEgPiGResABaCScIClXdpuVrmsNQAeJyKlSgGZHrinuWLqhtapGWIZvmYTcDSSOBWbTfAJOWVOrgoNCpPEqrRNHaIrlmDUEgtOZokXFFbtbXHifROLeqUrZNJMpaHOEKlHmCcQgExopyHxVhKCYgxiPliDibrCVdFvDgWHdtHESFAhdCTmuRtmbuQlODKgxVbndoOjdtMIXLuyJWvioBvOUMoYXRRYhgXMhOfjbZLKETQJFtYGYYkcfkyXGmXyxbwWZuOUmuZejYMwtMEvCgJoSXseTxGnjwEYOEFiVQZPQDBhBwWRZoknXZSsWSCiDOcAwWTyDgylAhBsLdDRCGdiiANyKAtUHFHBLQNejjsZeCfuHxSfAHJbeKOsexnaUhhIQpqplsFgKLAKGKTXcyOcHmvNqMbHAqbmIhKmbVUNQFfcqFaFMEiaTwtcNCTNpeuCpBqKgNkbYGfOZtYotPZfedeVkXfseFWRddjiRBCNPSLMkkaglxQWopsjbLtRDnwMNNpkovtHFchOijwbbaxJkjDywMKicHuLedXTYCqadEyxOIcxPRnkAhGLDTAHkGyEQKihPDBkIoLDZZikeEveinobqgCBNTBMFZqnyjNciavWSopbZWDkupYCdnMHmruwVhhqssnMvVLEGhuogWLIBduMFcMgOngZImRLWRjVgjvDQhnRRvnuWBsSSgwQLFinxQySFJxjvdsWxCMfDVHnsQKceWshXFfxUoXwLxdHaHZnWrenOeutKCZvRAHGWNlNRKUyrHwDSwHAoEGqUAbikMuAVkhPEWyZgSCPJVNRwvntfWxDvgGitVUTTwwArynPsyJXfVeLCBiZaTBRXISqGaDUPBkVbtkWDQZnydCTxJvIQHMQVpUEDFSdjtZDeBTFNTFlHVswtGxnxMGIKlIQUEsAPcqrdutEEmhydmJbGYkUBHZZpWxbHqVTAvpauuiyuSkIqKMIILWpWdrNkNomWuYjfREYmPdlFnAIWdPeZPoRoeSQwtwHDZeWptVygeoSiJnLCDIOGTGxesTNtGCjFghRPrVdswBdmYrawEacKkyljbptKDrofNhAKRdaIeHJZrIvtsjwRDpaipreEXqsooDZnNXveJmtQmURAAjXUReMtTjHEkPsNgDQroUGrOFqdJSHsEfTKVhdpahIsaZDyiNsFjWsZvDxupJqQnQDBemlKihyXAJBLDtZRvpOKsjAXPJGxwGUOguvNUlLmdwCDQpiSJGYdGFKoQcdHddWmQHddfLVGeaQgEmNiouoXoDrXRWcaTsTrOYcthtNgZrKeghwHgxqQrNpXeaweYlrRQRcEgTvIJHysEedoliAmeDIeIfuYxJaPLUFAESGljEptXaGWFaBNCOHAQtAcriwFwtYhxmfVpGkOnkarViPlNNPTGMKBfiDXMegXgcfWADRpEHCGXkrbfWWrOXBKbnNQgtmqvfOrUPqpCCGiEORmZEeTgPSqGlWFNANpSGMsXsCwuaQcgaLgVnQFMiFLYnIUEwgPgPnooRDyhZNmpIXDwXNpiPHAiTeqdetKbLLywlxQHirTChMeIomIjokqCpXncqkuSLWTHOGVELZmPbroKZshvxYGtpYjebgyMkoYQpmyqTOcZjpjBkBFHqJSHMIYOxtudIEEbsyQIqVkegCuBSjHZXQyAssCiUhZWLDlJbugTdfiXyBQEkMSjvqELIEYbrmSZFCbSvyRNrjtdRsKKobcbPkYdTJuebirKIyXcZKectcawmpVUANhwjCGFJoMecMnlWfJqvfJWOQgByNEVojDZZZvZfWHwZZ','2020-07-06 12:47:12'),(2,621235,'ZAP','ZAP','2020-07-06 12:47:18'),(5,621235,'ZAP','Set-cookie: Tamper=703ef080-3556-4337-8239-338b08f9807d','2020-07-06 12:47:24'),(11,621235,'ZAP','@','2020-07-06 12:48:13');
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post` (
  `PostID` smallint NOT NULL AUTO_INCREMENT,
  `TopicID` tinyint NOT NULL,
  `UserID` int NOT NULL,
  `DatetimePosted` datetime NOT NULL,
  `Title` text NOT NULL,
  `Content` mediumtext NOT NULL,
  `Upvotes` mediumint NOT NULL,
  `Downvotes` mediumint NOT NULL,
  PRIMARY KEY (`PostID`),
  UNIQUE KEY `DatetimePosted_UNIQUE` (`DatetimePosted`),
  UNIQUE KEY `PostID_UNIQUE` (`PostID`),
  KEY `fk_post_TopicID_idx` (`TopicID`),
  KEY `fk_post_UserID_idx` (`UserID`),
  CONSTRAINT `fk_post_TopicID` FOREIGN KEY (`TopicID`) REFERENCES `topic` (`TopicID`) ON DELETE CASCADE,
  CONSTRAINT `fk_post_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post`
--

LOCK TABLES `post` WRITE;
/*!40000 ALTER TABLE `post` DISABLE KEYS */;
INSERT INTO `post` VALUES (1,17,274878,'2020-06-22 14:34:26','Regex to validate date format dd/mm/yyyy','I need to validate a date string for the format dd/mm/yyyy with a regular expresssion.\r\n\r\nThis regex validates dd/mm/yyyy, but not the invalid dates like 31/02/4500:\r\n^(0?[1-9]|[12][0-9]|3[01])[\\/\\-](0?[1-9]|1[012])[\\/\\-]\\d{4}$\r\n\r\nWhat is a valid regex to validate dd/mm/yyyy format with leap year support?',3,0),(2,1,927312,'2020-06-22 15:45:06','What does if __name__ == “__main__”: do?','As stated in the title, what does if __name__ == “__main__”: do? From what I have observed so far, the usage of it is to simply separate the rest of the code from the main code that runs upon the start of the program.',0,0),(3,1,823585,'2020-06-22 16:10:41','Single quotes VS Double quotes','According to the documentation, they\'re pretty much interchangeable. Is there a stylistic reason to use one over the other?',2,1);
/*!40000 ALTER TABLE `post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_votes`
--

DROP TABLE IF EXISTS `post_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_votes` (
  `UserID` int NOT NULL,
  `PostID` smallint NOT NULL,
  `Vote` tinyint NOT NULL,
  PRIMARY KEY (`UserID`,`PostID`),
  KEY `fk_post_votes_PostID_idx` (`PostID`),
  CONSTRAINT `fk_post_votes_PostID` FOREIGN KEY (`PostID`) REFERENCES `post` (`PostID`) ON DELETE CASCADE,
  CONSTRAINT `fk_post_votes_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_votes`
--

LOCK TABLES `post_votes` WRITE;
/*!40000 ALTER TABLE `post_votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reply`
--

DROP TABLE IF EXISTS `reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reply` (
  `ReplyID` smallint NOT NULL AUTO_INCREMENT,
  `CommentID` smallint NOT NULL,
  `UserID` int NOT NULL,
  `Content` mediumtext NOT NULL,
  `DatetimePosted` datetime NOT NULL,
  PRIMARY KEY (`ReplyID`),
  KEY `fk_reply_CommentID_idx` (`CommentID`),
  KEY `fk_reply_UserID_idx` (`UserID`),
  CONSTRAINT `fk_reply_CommentID` FOREIGN KEY (`CommentID`) REFERENCES `comment` (`CommentID`) ON DELETE CASCADE,
  CONSTRAINT `fk_reply_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reply`
--

LOCK TABLES `reply` WRITE;
/*!40000 ALTER TABLE `reply` DISABLE KEYS */;
INSERT INTO `reply` VALUES (1,1,621235,'same here!','2020-06-24 16:32:07');
/*!40000 ALTER TABLE `reply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `topic` (
  `TopicID` tinyint NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `Content` mediumtext NOT NULL,
  `DatetimePosted` datetime NOT NULL,
  PRIMARY KEY (`TopicID`),
  UNIQUE KEY `TopicID_UNIQUE` (`TopicID`),
  UNIQUE KEY `DatetimePosted_UNIQUE` (`DatetimePosted`),
  KEY `fk_topic_UserID_idx` (`UserID`),
  CONSTRAINT `fk_topic_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic`
--

LOCK TABLES `topic` WRITE;
/*!40000 ALTER TABLE `topic` DISABLE KEYS */;
INSERT INTO `topic` VALUES (1,102939,'Python','2020-06-20 10:05:00'),(2,102939,'Java','2020-06-20 10:05:10'),(3,102939,'JavaScript','2020-06-20 10:05:21'),(4,102939,'C','2020-06-20 10:05:30'),(5,102939,'C#','2020-06-20 10:05:37'),(6,102939,'C++','2020-06-20 10:05:54'),(7,102939,'Objective-C','2020-06-20 10:06:06'),(8,102939,'Ruby','2020-06-20 10:06:15'),(9,102939,'PHP','2020-06-20 10:06:25'),(10,102939,'SQL','2020-06-20 10:06:32'),(11,102939,'HTML','2020-06-20 10:10:03'),(12,102939,'CSS','2020-06-20 10:10:12'),(13,102939,'jQuery','2020-06-20 10:10:20'),(14,102939,'Perl','2020-06-20 10:10:30'),(15,102939,'XML','2020-06-20 10:10:41'),(16,283287,'Object-Oriented Programming','2020-06-20 12:48:20'),(17,437954,'RegEx','2020-06-21 13:01:18'),(18,437954,'Bootstrap','2020-06-21 13:01:30');
/*!40000 ALTER TABLE `topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `UserID` int NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Username` varchar(30) NOT NULL,
  `Password` varchar(60) NOT NULL,
  `Status` tinytext,
  `Birthday` date NOT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `UserID_UNIQUE` (`UserID`),
  UNIQUE KEY `Email_UNIQUE` (`Email`),
  UNIQUE KEY `Username_UNIQUE` (`Username`),
  UNIQUE KEY `Password_UNIQUE` (`Password`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (102939,'jams@lorem-ipsum.com','NotABot','pLs9w6UwgX45NXhDa5Ea/.5P9Sykpc1p5QkQYK716UcclceNCWODO','NotABot is too lazy to add a status','0000-00-00'),(193006,'coconutmak@gmail.com','theauthenticcoconut','J8NLbB5JoJwNE2dERDMWde0gv6VRubetdRMEqxKSV8IGs5YwZcWIq','theauthenticcoconut is too lazy to add a status','2001-02-28'),(274878,'marytan@gmail.com','MarySinceBirthButStillSingle','L1Uz7HI3E.BoX1lg6NzWceS2iHWklid3D0cdSLBIKeR6imXPeZ0hC','MarySinceBirthButStillSingle is too lazy to add a status','2000-08-10'),(283287,'sitisarah@lorem-ipsum.com','CoffeeGirl','R8bbir1PaD7q5DILiFkHtOC/DFfOgFBobknVI8PxCzRY4CRoMUJNa','CoffeeGirl is too lazy to add a status','2002-02-14'),(437954,'kojialing@lorem-ipsum.com','Kobot','dbaIhnhxhH/ubxDuwwEq/.LQn0Wt3qikMs4mtyRUndFsJiWlqROCe','Kobot is too lazy to add a status','2003-01-01'),(621235,'hansolo02@live.com','hanbaobao','eBymQcG3FonwnAqKHUuhNuTwm9R6rox17/pMn/7S/5MSw.BFAOe6e','hanbaobao is too lazy to add a status','1998-01-30'),(734752,'muhammad@lorem-ipsum.com','Mehxa','hV33ghtwfoIeVOajlcGBIOUzvYR/mwkaJ61epPTlId50wnx3caNeu','Mehxa is too lazy to add a status','2002-03-15'),(823585,'ameliajeff0206@yahoo.com','iamjeff','EZjbWWvlrsCOKnYQqLXjqOlt1cxHkzBF8OIil5So6WhrIsSqzal6O','iamjeff is too lazy to add a status','1997-11-10'),(927312,'john2004@gmail.com','johnnyjohnny','o3UZqnRtOvyvnBGT33mNRuLkkWd8Fi1TWvpELAevnVTRX1tcRvmh2','johnnyjohnny is too lazy to add a status','1997-10-03');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-07-28 22:16:46
