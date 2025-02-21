-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: secureblogdb
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
  CONSTRAINT `fk_admin_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
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
  CONSTRAINT `fk_comment_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
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
  CONSTRAINT `fk_coment_votes_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE,
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
-- Table structure for table `errorlog`
--

DROP TABLE IF EXISTS `errorlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `errorlog` (
  `logNo` int NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `route` varchar(100) NOT NULL,
  `errorCode` varchar(6) NOT NULL DEFAULT 'OTHERS',
  `details` mediumtext NOT NULL,
  PRIMARY KEY (`logNo`,`datetime`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `errorlog`
--

LOCK TABLES `errorlog` WRITE;
/*!40000 ALTER TABLE `errorlog` DISABLE KEYS */;
INSERT INTO `errorlog` VALUES (1,'2020-08-14 18:11:23','/adminHome','500','Internal Server Error'),(2,'2020-08-14 18:11:40','/adminHome','500','Internal Server Error'),(3,'2020-08-15 22:42:13','/errorLog','401','Unauthorized Access to Admin Page'),(4,'2020-08-15 22:42:40','/errorLog','401','Unauthorized Access to Admin Page'),(5,'2020-08-15 22:42:57','/errorLog','500','Internal Server Error'),(6,'2020-08-16 22:39:44','/errorLog','500','Internal Server Error'),(7,'2020-08-16 22:40:18','/errorLog','500','Internal Server Error'),(8,'2020-08-16 22:41:46','/errorLog','401','Unauthorized Access to Admin Page'),(9,'2020-08-17 00:20:33','/esese','404','Page not found'),(10,'2020-08-17 00:33:45','/errorLog','401','Unauthorized Access to Admin Page'),(11,'2020-08-17 22:07:57','/adminHome','401','Unauthorized Access to Admin Page'),(12,'2020-08-17 22:39:01','/errorLog','500','Internal Server Error'),(13,'2020-08-17 22:39:22','/errorLog','500','Internal Server Error'),(14,'2020-08-17 22:47:53','/errorLog','500','Internal Server Error'),(15,'2020-08-17 23:07:27','/errorLog','500','Internal Server Error'),(16,'2020-08-17 23:08:22','/errorLog','500','Internal Server Error'),(17,'2020-08-17 23:08:38','/errorLog','500','Internal Server Error'),(18,'2020-08-17 23:24:27','/errorLog','500','Internal Server Error'),(19,'2020-08-17 23:25:28','/errorLog','500','Internal Server Error'),(20,'2020-08-17 23:26:43','/errorLog','500','Internal Server Error'),(21,'2020-08-17 23:27:12','/errorLog','500','Internal Server Error'),(22,'2020-08-17 23:27:13','/errorLog','500','Internal Server Error'),(23,'2020-08-17 23:44:37','/errorLog','500','Internal Server Error'),(24,'2020-08-17 23:46:50','/favicon.ico','404','Page not found'),(25,'2020-08-17 23:48:25','/errorLog','500','Internal Server Error'),(26,'2020-08-18 00:25:47','/postVote','500','Internal Server Error'),(27,'2020-08-18 00:25:48','/commentVote','404','Page not found'),(28,'2020-08-18 00:25:50','/favicon.ico','404','Page not found'),(29,'2020-08-18 00:25:51','/favicon.ico','404','Page not found'),(30,'2020-08-18 00:25:52','/postVote','500','Internal Server Error'),(31,'2020-08-18 00:27:54','/favicon.ico','404','Page not found'),(32,'2020-08-18 00:27:56','/favicon.ico','404','Page not found'),(33,'2020-08-18 00:28:39','/favicon.ico','404','Page not found'),(34,'2020-08-18 00:28:40','/favicon.ico','404','Page not found'),(35,'2020-08-18 00:28:42','/postVote','500','Internal Server Error'),(36,'2020-08-18 00:30:44','/favicon.ico','404','Page not found'),(37,'2020-08-18 00:31:47','/main','404','Page not found'),(38,'2020-08-18 00:37:06','/favicon.ico','404','Page not found'),(39,'2020-08-18 00:37:08','/favicon.ico','404','Page not found'),(40,'2020-08-18 00:38:52','/adminFeedback','401','Unauthorized Access to Admin Page'),(41,'2020-08-18 00:38:54','/favicon.ico','404','Page not found'),(42,'2020-08-18 00:38:58','/favicon.ico','404','Page not found'),(43,'2020-08-18 00:39:02','/favicon.ico','404','Page not found'),(44,'2020-08-18 00:39:04','/favicon.ico','404','Page not found'),(45,'2020-08-18 01:31:19','/favicon.ico','404','Page not found'),(46,'2020-08-18 01:44:04','/favicon.ico','404','Page not found'),(47,'2020-08-18 01:44:11','/login','500','Internal Server Error'),(48,'2020-08-18 01:44:17','/login','500','Internal Server Error'),(49,'2020-08-18 13:45:02','/favicon.ico','404','Page not found'),(50,'2020-08-18 13:45:11','/favicon.ico','404','Page not found'),(51,'2020-08-18 13:45:17','/favicon.ico','404','Page not found'),(52,'2020-08-18 13:45:20','/admin','404','Page not found'),(53,'2020-08-18 13:45:20','/favicon.ico','404','Page not found'),(54,'2020-08-18 13:45:23','/users','404','Page not found'),(55,'2020-08-18 13:45:23','/favicon.ico','404','Page not found'),(56,'2020-08-18 13:45:26','/favicon.ico','404','Page not found'),(57,'2020-08-18 13:45:29','/home-admin','404','Page not found'),(58,'2020-08-18 13:45:29','/favicon.ico','404','Page not found'),(59,'2020-08-18 13:45:32','/admin-home','404','Page not found'),(60,'2020-08-18 13:45:32','/favicon.ico','404','Page not found'),(61,'2020-08-18 13:45:33','/favicon.ico','404','Page not found'),(62,'2020-08-18 13:45:34','/favicon.ico','404','Page not found'),(63,'2020-08-18 13:45:44','/adminpage','404','Page not found'),(64,'2020-08-18 13:45:44','/favicon.ico','404','Page not found'),(65,'2020-08-18 13:45:45','/adminHome','403','Forbidden Access to Admin Page by user hanbaobao'),(66,'2020-08-18 13:45:46','/favicon.ico','404','Page not found'),(67,'2020-08-18 13:45:52','/favicon.ico','404','Page not found'),(68,'2020-08-18 13:45:55','/adminTopics','403','Forbidden Access to Admin Page by user hanbaobao'),(69,'2020-08-18 13:45:55','/favicon.ico','404','Page not found'),(70,'2020-08-18 13:46:10','/adminHome','403','Forbidden Access to Admin Page by user hanbaobao'),(71,'2020-08-18 13:46:10','/favicon.ico','404','Page not found'),(72,'2020-08-18 13:46:15','/ADMIN','404','Page not found'),(73,'2020-08-18 13:46:15','/favicon.ico','404','Page not found'),(74,'2020-08-18 13:46:24','/adminHome','403','Forbidden Access to Admin Page by user hanbaobao'),(75,'2020-08-18 13:46:24','/favicon.ico','404','Page not found'),(76,'2020-08-18 13:46:53','/favicon.ico','404','Page not found'),(77,'2020-08-18 13:46:57','/favicon.ico','404','Page not found'),(78,'2020-08-18 13:47:01','/favicon.ico','404','Page not found'),(79,'2020-08-18 13:47:10','/favicon.ico','404','Page not found'),(80,'2020-08-18 13:47:25','/favicon.ico','404','Page not found'),(81,'2020-08-18 14:11:18','/favicon.ico','404','Page not found'),(82,'2020-08-18 14:11:21','/favicon.ico','404','Page not found'),(83,'2020-08-18 15:07:31','/postVote','500','Internal Server Error'),(84,'2020-08-18 15:07:31','/postVote','500','Internal Server Error');
/*!40000 ALTER TABLE `errorlog` ENABLE KEYS */;
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
  `Resolved` tinyint NOT NULL,
  PRIMARY KEY (`FeedbackID`),
  UNIQUE KEY `FeedbackID_UNIQUE` (`FeedbackID`),
  UNIQUE KEY `DatetimePosted_UNIQUE` (`DatetimePosted`),
  KEY `fk_feedback_UserID_idx` (`UserID`),
  CONSTRAINT `fk_feedback_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (1,621235,'ZAP','XhZKfdujvPjYPGdaOMdybehjWbfuvkKrFmectyYRuMibWyuLiAxYXWexxkHjXWhRmmsNoptIgMcTqBwKkqlVyciPwBYfwOedYIoUSdjKSrKHlZgsqhxCWRtMnYgaGCCUaccwxTPVhoFXOKZFvwbkUMExHHoESuaZWSvxIjdHvEKdFAXyulkJOdvwPbWxjZjrtAVXDwvyPImNSSPWdOMUjnwZoFrNrfcrlZDOdKUoZcUtUCZRvWVwIweDwDhlRQplDFrXiZCfRNtCJActGtUTKNIFEYAsVNPbdrZwqvpEgPiGResABaCScIClXdpuVrmsNQAeJyKlSgGZHrinuWLqhtapGWIZvmYTcDSSOBWbTfAJOWVOrgoNCpPEqrRNHaIrlmDUEgtOZokXFFbtbXHifROLeqUrZNJMpaHOEKlHmCcQgExopyHxVhKCYgxiPliDibrCVdFvDgWHdtHESFAhdCTmuRtmbuQlODKgxVbndoOjdtMIXLuyJWvioBvOUMoYXRRYhgXMhOfjbZLKETQJFtYGYYkcfkyXGmXyxbwWZuOUmuZejYMwtMEvCgJoSXseTxGnjwEYOEFiVQZPQDBhBwWRZoknXZSsWSCiDOcAwWTyDgylAhBsLdDRCGdiiANyKAtUHFHBLQNejjsZeCfuHxSfAHJbeKOsexnaUhhIQpqplsFgKLAKGKTXcyOcHmvNqMbHAqbmIhKmbVUNQFfcqFaFMEiaTwtcNCTNpeuCpBqKgNkbYGfOZtYotPZfedeVkXfseFWRddjiRBCNPSLMkkaglxQWopsjbLtRDnwMNNpkovtHFchOijwbbaxJkjDywMKicHuLedXTYCqadEyxOIcxPRnkAhGLDTAHkGyEQKihPDBkIoLDZZikeEveinobqgCBNTBMFZqnyjNciavWSopbZWDkupYCdnMHmruwVhhqssnMvVLEGhuogWLIBduMFcMgOngZImRLWRjVgjvDQhnRRvnuWBsSSgwQLFinxQySFJxjvdsWxCMfDVHnsQKceWshXFfxUoXwLxdHaHZnWrenOeutKCZvRAHGWNlNRKUyrHwDSwHAoEGqUAbikMuAVkhPEWyZgSCPJVNRwvntfWxDvgGitVUTTwwArynPsyJXfVeLCBiZaTBRXISqGaDUPBkVbtkWDQZnydCTxJvIQHMQVpUEDFSdjtZDeBTFNTFlHVswtGxnxMGIKlIQUEsAPcqrdutEEmhydmJbGYkUBHZZpWxbHqVTAvpauuiyuSkIqKMIILWpWdrNkNomWuYjfREYmPdlFnAIWdPeZPoRoeSQwtwHDZeWptVygeoSiJnLCDIOGTGxesTNtGCjFghRPrVdswBdmYrawEacKkyljbptKDrofNhAKRdaIeHJZrIvtsjwRDpaipreEXqsooDZnNXveJmtQmURAAjXUReMtTjHEkPsNgDQroUGrOFqdJSHsEfTKVhdpahIsaZDyiNsFjWsZvDxupJqQnQDBemlKihyXAJBLDtZRvpOKsjAXPJGxwGUOguvNUlLmdwCDQpiSJGYdGFKoQcdHddWmQHddfLVGeaQgEmNiouoXoDrXRWcaTsTrOYcthtNgZrKeghwHgxqQrNpXeaweYlrRQRcEgTvIJHysEedoliAmeDIeIfuYxJaPLUFAESGljEptXaGWFaBNCOHAQtAcriwFwtYhxmfVpGkOnkarViPlNNPTGMKBfiDXMegXgcfWADRpEHCGXkrbfWWrOXBKbnNQgtmqvfOrUPqpCCGiEORmZEeTgPSqGlWFNANpSGMsXsCwuaQcgaLgVnQFMiFLYnIUEwgPgPnooRDyhZNmpIXDwXNpiPHAiTeqdetKbLLywlxQHirTChMeIomIjokqCpXncqkuSLWTHOGVELZmPbroKZshvxYGtpYjebgyMkoYQpmyqTOcZjpjBkBFHqJSHMIYOxtudIEEbsyQIqVkegCuBSjHZXQyAssCiUhZWLDlJbugTdfiXyBQEkMSjvqELIEYbrmSZFCbSvyRNrjtdRsKKobcbPkYdTJuebirKIyXcZKectcawmpVUANhwjCGFJoMecMnlWfJqvfJWOQgByNEVojDZZZvZfWHwZZ','2020-07-06 12:47:12',0),(2,621235,'ZAP','ZAP','2020-07-06 12:47:18',0),(5,621235,'ZAP','Set-cookie: Tamper=703ef080-3556-4337-8239-338b08f9807d','2020-07-06 12:47:24',0),(11,621235,'ZAP','@','2020-07-06 12:48:13',0),(12,621235,'s','s','2020-08-16 20:13:26',0);
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp`
--

DROP TABLE IF EXISTS `otp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `otp` (
  `OtpID` smallint NOT NULL AUTO_INCREMENT,
  `link` varchar(50) NOT NULL,
  `otp` int NOT NULL,
  `Time_Created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`OtpID`),
  UNIQUE KEY `link_UNIQUE` (`link`),
  UNIQUE KEY `OtpID_UNIQUE` (`OtpID`),
  UNIQUE KEY `otp_UNIQUE` (`otp`),
  UNIQUE KEY `Time_Created_UNIQUE` (`Time_Created`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp`
--

LOCK TABLES `otp` WRITE;
/*!40000 ALTER TABLE `otp` DISABLE KEYS */;
INSERT INTO `otp` VALUES (1,'MPcVBoTD5BVIoxcP2ozRKZgwIrYL1CKgeqglgNS8FCU',656397,'2020-08-18 12:38:15');
/*!40000 ALTER TABLE `otp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_history`
--

DROP TABLE IF EXISTS `password_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_history` (
  `HistoryID` smallint NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `Date_Changed` date NOT NULL,
  `Password` varchar(60) NOT NULL,
  PRIMARY KEY (`HistoryID`),
  UNIQUE KEY `HistoryID_UNIQUE` (`HistoryID`),
  UNIQUE KEY `Password_UNIQUE` (`Password`),
  KEY `fk_password_history_UserID_idx` (`UserID`),
  CONSTRAINT `fk_password_history_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_history`
--

LOCK TABLES `password_history` WRITE;
/*!40000 ALTER TABLE `password_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_url`
--

DROP TABLE IF EXISTS `password_url`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_url` (
  `UrlID` smallint NOT NULL AUTO_INCREMENT,
  `Url` varchar(50) NOT NULL,
  `Time_Created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UrlID`),
  UNIQUE KEY `UrlID_UNIQUE` (`UrlID`),
  UNIQUE KEY `Url_UNIQUE` (`Url`),
  UNIQUE KEY `Expiry_time_UNIQUE` (`Time_Created`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_url`
--

LOCK TABLES `password_url` WRITE;
/*!40000 ALTER TABLE `password_url` DISABLE KEYS */;
INSERT INTO `password_url` VALUES (1,'FfglvkXAHNIk-6EKsXaTvvEe0xtNeARQSMdMr0jamP4','2020-07-29 07:45:18'),(2,'lOW_kYo4fkoRYdS2p0kaHrsVdk_NbsGwnDsFpRkdiSk','2020-07-29 07:47:43'),(3,'oEBQNvqCNA3_yxnzoW1PJbLhsDB1EO2d54nCd5OglL4','2020-07-29 07:50:18'),(4,'rGLirOvaOrlGfIV64rF7EBSYHgyli3hWWwDEr4eCOus','2020-07-29 13:29:43'),(5,'pnE7axJoPGrgOh9XoOCqAKN3ryGUtV_kLA7lpYrl0-E','2020-07-29 13:32:58'),(6,'wJ0qdfu1cuM9yh-pWHoFgzsgemwvyqT--16K5nZFD3c','2020-07-29 13:40:11'),(7,'d0GIFIklyEdoAFd9br48nODeXwl2dTEwe-q_1Xl5HmU','2020-07-29 14:22:37');
/*!40000 ALTER TABLE `password_url` ENABLE KEYS */;
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
  CONSTRAINT `fk_post_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  CONSTRAINT `fk_post_votes_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
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
-- Table structure for table `reactivate`
--

DROP TABLE IF EXISTS `reactivate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reactivate` (
  `Secret` varchar(60) NOT NULL,
  `DateIssued` datetime NOT NULL,
  `ExpiryTime` time NOT NULL,
  `UserID` int NOT NULL,
  PRIMARY KEY (`Secret`),
  KEY `fk_reactivate_UserID_idx` (`UserID`),
  CONSTRAINT `fk_reactivate_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reactivate`
--

LOCK TABLES `reactivate` WRITE;
/*!40000 ALTER TABLE `reactivate` DISABLE KEYS */;
/*!40000 ALTER TABLE `reactivate` ENABLE KEYS */;
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
  CONSTRAINT `fk_reply_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
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
  CONSTRAINT `fk_topic_UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
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
  `Active` int NOT NULL DEFAULT '1',
  `LoginAttempts` int NOT NULL DEFAULT '0',
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
INSERT INTO `user` VALUES (102939,'jams@lorem-ipsum.com','NotABot','pLs9w6UwgX45NXhDa5Ea/.5P9Sykpc1p5QkQYK716UcclceNCWODO','NotABot is too lazy to add a status','0000-00-00',1,0),(193006,'coconutmak@gmail.com','theauthenticcoconut','J8NLbB5JoJwNE2dERDMWde0gv6VRubetdRMEqxKSV8IGs5YwZcWIq','theauthenticcoconut is too lazy to add a status','2001-02-28',1,0),(274878,'marytan@gmail.com','MarySinceBirthButStillSingle','L1Uz7HI3E.BoX1lg6NzWceS2iHWklid3D0cdSLBIKeR6imXPeZ0hC','MarySinceBirthButStillSingle is too lazy to add a status','2000-08-10',1,0),(283287,'sitisarah@lorem-ipsum.com','CoffeeGirl','R8bbir1PaD7q5DILiFkHtOC/DFfOgFBobknVI8PxCzRY4CRoMUJNa','CoffeeGirl is too lazy to add a status','2002-02-14',1,0),(437954,'kojialing@lorem-ipsum.com','Kobot','dbaIhnhxhH/ubxDuwwEq/.LQn0Wt3qikMs4mtyRUndFsJiWlqROCe','Kobot is too lazy to add a status','2003-01-01',1,0),(621235,'hansolo02@live.com','hanbaobao','eBymQcG3FonwnAqKHUuhNuTwm9R6rox17/pMn/7S/5MSw.BFAOe6e','hanbaobao is too lazy to add a status','1998-01-30',1,0),(734752,'muhammad@lorem-ipsum.com','Mehxa','hV33ghtwfoIeVOajlcGBIOUzvYR/mwkaJ61epPTlId50wnx3caNeu','Mehxa is too lazy to add a status','2002-03-15',1,0),(823585,'ameliajeff0206@yahoo.com','iamjeff','EZjbWWvlrsCOKnYQqLXjqOlt1cxHkzBF8OIil5So6WhrIsSqzal6O','iamjeff is too lazy to add a status','1997-11-10',1,0),(927312,'john2004@gmail.com','johnnyjohnny','o3UZqnRtOvyvnBGT33mNRuLkkWd8Fi1TWvpELAevnVTRX1tcRvmh2','johnnyjohnny is too lazy to add a status','1997-10-03',1,0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `useractivitycode`
--

DROP TABLE IF EXISTS `useractivitycode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `useractivitycode` (
  `activityCode` int NOT NULL,
  `details` varchar(50) NOT NULL,
  `severity` int NOT NULL,
  PRIMARY KEY (`activityCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `useractivitycode`
--

LOCK TABLES `useractivitycode` WRITE;
/*!40000 ALTER TABLE `useractivitycode` DISABLE KEYS */;
INSERT INTO `useractivitycode` VALUES (1,'User sign up',1),(2,'User logged in',1),(3,'User logged out',1),(4,'User failed login attempt',1),(5,'User account locked out',2),(6,'User account reactivated',1),(7,'User tried to access admin page',3);
/*!40000 ALTER TABLE `useractivitycode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `useractivitylog`
--

DROP TABLE IF EXISTS `useractivitylog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `useractivitylog` (
  `logNo` int NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UserID` int DEFAULT NULL,
  `username` varchar(30) NOT NULL,
  `activityCode` int NOT NULL,
  PRIMARY KEY (`logNo`,`datetime`),
  KEY `fk_useractivitylog_user_idx` (`UserID`),
  KEY `fk_useractivitylog_useractivitycode_idx` (`activityCode`),
  CONSTRAINT `fk_useractivitylog_user` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`),
  CONSTRAINT `fk_useractivitylog_useractivitycode` FOREIGN KEY (`activityCode`) REFERENCES `useractivitycode` (`activityCode`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `useractivitylog`
--

LOCK TABLES `useractivitylog` WRITE;
/*!40000 ALTER TABLE `useractivitylog` DISABLE KEYS */;
INSERT INTO `useractivitylog` VALUES (1,'2020-08-16 01:45:41',437954,'Kobot',2),(2,'2020-08-16 01:45:48',437954,'Kobot',3),(3,'2020-08-16 01:45:59',437954,'Kobot',4),(5,'2020-08-16 01:48:23',NULL,'Kobae',4),(6,'2020-08-16 01:48:51',437954,'Kobot',4),(7,'2020-08-16 01:48:53',437954,'Kobot',4),(8,'2020-08-16 01:50:12',437954,'Kobot',2),(9,'2020-08-16 01:50:27',437954,'Kobot',3),(22,'2020-08-18 13:45:11',621235,'hanbaobao',4),(23,'2020-08-18 13:45:17',621235,'hanbaobao',2),(24,'2020-08-18 13:45:45',621235,'hanbaobao',7),(25,'2020-08-18 13:45:55',621235,'hanbaobao',7),(26,'2020-08-18 13:46:10',621235,'hanbaobao',7),(27,'2020-08-18 13:46:24',621235,'hanbaobao',7),(28,'2020-08-18 15:07:29',927312,'johnnyjohnny',2),(29,'2020-08-18 15:08:12',927312,'johnnyjohnny',2),(30,'2020-08-18 15:11:38',927312,'johnnyjohnny',2),(31,'2020-08-18 15:18:12',927312,'johnnyjohnny',2),(32,'2020-08-18 15:20:49',621235,'hanbaobao',2),(33,'2020-08-18 15:22:45',621235,'hanbaobao',2),(34,'2020-08-18 15:28:35',621235,'hanbaobao',4),(35,'2020-08-18 15:28:40',621235,'hanbaobao',2),(36,'2020-08-18 15:29:15',621235,'hanbaobao',2),(37,'2020-08-18 15:37:49',621235,'hanbaobao',2),(38,'2020-08-18 15:40:26',621235,'hanbaobao',2),(39,'2020-08-18 15:41:00',621235,'hanbaobao',2),(40,'2020-08-18 15:44:02',621235,'hanbaobao',2),(41,'2020-08-18 15:45:15',621235,'hanbaobao',2),(42,'2020-08-18 15:45:22',621235,'hanbaobao',3);
/*!40000 ALTER TABLE `useractivitylog` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-08-18 15:47:43
