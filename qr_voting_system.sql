-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: qrvotingdb
-- ------------------------------------------------------
-- Server version	8.0.43

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
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES ('admin','admin123');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidates`
--

DROP TABLE IF EXISTS `candidates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `party` varchar(100) DEFAULT NULL,
  `votes_count` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidates`
--

LOCK TABLES `candidates` WRITE;
/*!40000 ALTER TABLE `candidates` DISABLE KEYS */;
INSERT INTO `candidates` VALUES (1,'Alice Johnson','Party A',5),(2,'Bob Smith','Party B',0),(3,'Charlie Lee','Party C',0),(4,'Diana Patel','Party D',0),(5,'Ethan Kumar','Party E',0),(6,'Ragaventhiran M','Tvk',3),(7,'dhilip','dmk',1),(8,'vicky','admk',1),(9,'dharani','nrk',0),(10,'manu','nne',0),(11,'','',0);
/*!40000 ALTER TABLE `candidates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `election_settings`
--

DROP TABLE IF EXISTS `election_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `election_settings` (
  `id` int NOT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `election_settings`
--

LOCK TABLES `election_settings` WRITE;
/*!40000 ALTER TABLE `election_settings` DISABLE KEYS */;
INSERT INTO `election_settings` VALUES (1,'CLOSED');
/*!40000 ALTER TABLE `election_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `qr_code` varchar(255) DEFAULT NULL,
  `has_voted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Ragav','ragav9760@gmail.com','$2b$10$o9/51dleqhXdREnzmwurR.rTXkVvOe9Cs/gVErjJXiYY4x54KTEtO','/uploads/qr_1770657515243.png',0),(2,'Dhilip','dhilip1505@gmail.com','$2b$10$wX/Y9WzGslhp6Zn/dhXSzuhLWhOvHFVEMcSKQxZwnTqj362F7UIkS','/uploads/qr_1770659531215.png',0),(3,'Dhilip','dhilip15051@gmail.com','$2b$10$dL7E0SpSmaRUOxKN92vIMuT29rXbIGJxBMhx9IsahHQRLLcpfN81i','/uploads/qr_1770661291132.png',0),(4,'githa','githa22@gmail.com','$2b$10$y3Ggdj6OtLqOuYRKSATiiOoltMUfD3xpZkWy87m6g5J5M2YE6IFEa','/uploads/qr_1770661496951.png',0),(6,'ragu','ragav9762@gmail.com','$2b$10$wNAxB7Lq53YSzDfWP2zyv.hcuyvXX0hrqff83.IOqAIdOMavHY.C.','/uploads/qr_1770661610502.png',0),(7,'manu','manu123@gmail.com','$2b$10$cy5xEYugy9VZpyGOYaG5Ju0WiMwSOSMkkpTlOb37JTgTq9WSAHIhK','/uploads/qr_1770662050027.png',0),(8,'magi','magi1234@gmail.com','$2b$10$B45o0rJTgyA3GGT5M.UaEelo5Pl7bCKY78jdGm71GBKKqAuVwUySe','/uploads/qr_1770669625841.png',0),(9,'Dhilip','dhilip00@gmail.com','$2b$10$BzKJ2gI/Nr1IoIKPs5AVX.jvWzJU1kKdCNxU/AQKjp6z4xB1y9Q4i','/uploads/qr_1770718516105.png',0),(10,NULL,'janu66@gmail.com','123456','/uploads/janu66@gmail.com.png',0),(11,'Manu','manu88@gmail.com','123456','/uploads/manu88@gmail.com.png',1),(12,'Esa','esa77@gmail.com','123456','/uploads/esa77@gmail.com.png',1),(13,'pavi','pavi007@gmail.com','123456','/uploads/pavi007@gmail.com.png',1),(14,'Dhilip','dhilipp223@gmail.com','1234567','/uploads/dhilipp223@gmail.com.png',0),(15,'isu','isu77@gmail.com','1234567','/uploads/isu77@gmail.com.png',1),(16,'kavi','kavi143@gmai.com','123456','/uploads/kavi143@gmai.com.png',0),(17,'kaviya','kaviya99@gmail.com','123456','/uploads/kaviya99@gmail.com.png',1),(18,'vicky','vicky66@gmail.com','123456','/uploads/vicky66@gmail.com.png',1),(19,'papu','papu223@gmail.com','123456','/uploads/papu223@gmail.com.png',1),(20,'navi','navi22@gmail.com','12345678','/uploads/navi22@gmail.com.png',0),(21,'sindhu','sindhu143@gmail.com','123456','/uploads/sindhu143@gmail.com.png',1),(22,'malu','malu22@gmail.com','123456','/uploads/malu22@gmail.com.png',1),(23,'sachin','sachin22@gmail.com','1234567','/uploads/sachin22@gmail.com.png',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `votes`
--

DROP TABLE IF EXISTS `votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `votes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `voter_id` int NOT NULL,
  `candidate_id` int NOT NULL,
  `voted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `voter_id` (`voter_id`),
  KEY `candidate_id` (`candidate_id`),
  CONSTRAINT `votes_ibfk_1` FOREIGN KEY (`voter_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `votes_ibfk_2` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `votes`
--

LOCK TABLES `votes` WRITE;
/*!40000 ALTER TABLE `votes` DISABLE KEYS */;
INSERT INTO `votes` VALUES (1,11,1,'2026-02-10 12:12:15'),(2,15,7,'2026-02-10 12:41:05'),(3,17,8,'2026-02-10 13:02:58'),(4,18,1,'2026-02-10 13:12:04'),(5,19,1,'2026-02-10 13:21:47'),(6,21,6,'2026-02-10 18:07:44'),(7,22,6,'2026-02-10 18:30:39'),(8,23,6,'2026-02-10 19:41:32');
/*!40000 ALTER TABLE `votes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-11  1:25:57
