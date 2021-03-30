-- MySQL dump 10.13  Distrib 8.0.21, for Linux (x86_64)
--
-- Host: std-mysql    Database: std_1085
-- ------------------------------------------------------
-- Server version	5.7.26-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_films`
--

DROP TABLE IF EXISTS `exam_films`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_films` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `prod_year` year(4) NOT NULL,
  `country` varchar(50) NOT NULL,
  `producer` varchar(50) NOT NULL,
  `screenwriter` varchar(50) NOT NULL,
  `actors` varchar(255) NOT NULL,
  `duration` int(11) NOT NULL,
  `poster_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `poster_id` (`poster_id`),
  CONSTRAINT `exam_films_ibfk_1` FOREIGN KEY (`poster_id`) REFERENCES `exam_posters` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_films`
--

LOCK TABLES `exam_films` WRITE;
/*!40000 ALTER TABLE `exam_films` DISABLE KEYS */;
INSERT INTO `exam_films` VALUES (1,'Остров проклятых','#Заголовок',2016,'Сша','Не знаю','Не знаю','Ди каприо',180,1),(10,'Мстители','Очередной фильм Marvel',2015,'Сша','я','не знаю','Много',123,1),(11,'Астрал','Страшилка',2016,'USA','Джэймс Ван','Джэймс Ван','Много',100,1),(20,'Назад в будущее',')',1990,'Сша','я','я','я',100,1);
/*!40000 ALTER TABLE `exam_films` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_genre`
--

DROP TABLE IF EXISTS `exam_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_genre` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_genre`
--

LOCK TABLES `exam_genre` WRITE;
/*!40000 ALTER TABLE `exam_genre` DISABLE KEYS */;
INSERT INTO `exam_genre` VALUES (3,'Комедия'),(1,'Триллер'),(2,'Хоррор');
/*!40000 ALTER TABLE `exam_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_posters`
--

DROP TABLE IF EXISTS `exam_posters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_posters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) NOT NULL,
  `mime_type` varchar(255) NOT NULL,
  `md5_hash` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_posters`
--

LOCK TABLES `exam_posters` WRITE;
/*!40000 ALTER TABLE `exam_posters` DISABLE KEYS */;
INSERT INTO `exam_posters` VALUES (1,'1','1','1');
/*!40000 ALTER TABLE `exam_posters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_review`
--

DROP TABLE IF EXISTS `exam_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_review` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `film_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `rating` int(11) NOT NULL,
  `review_text` text NOT NULL,
  `review_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `film_id` (`film_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `exam_review_ibfk_1` FOREIGN KEY (`film_id`) REFERENCES `exam_films` (`id`),
  CONSTRAINT `exam_review_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `exam_users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_review`
--

LOCK TABLES `exam_review` WRITE;
/*!40000 ALTER TABLE `exam_review` DISABLE KEYS */;
INSERT INTO `exam_review` VALUES (1,1,2,5,'Атмосферный и интересный фильм','2021-01-23 16:08:39'),(2,11,2,3,'50\\50','2021-01-23 16:09:19'),(3,1,1,5,'Топ','2021-01-23 16:17:03'),(8,10,2,3,'3','2021-01-23 19:18:10'),(13,10,3,5,'dsa','2021-01-24 13:36:34'),(14,20,1,5,'Классика','2021-01-25 06:57:26');
/*!40000 ALTER TABLE `exam_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_roles`
--

DROP TABLE IF EXISTS `exam_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_roles`
--

LOCK TABLES `exam_roles` WRITE;
/*!40000 ALTER TABLE `exam_roles` DISABLE KEYS */;
INSERT INTO `exam_roles` VALUES (1,'Admin','Admin - can do all things'),(2,'Moder','Moder can edit'),(3,'user','just user LMAO');
/*!40000 ALTER TABLE `exam_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_users`
--

DROP TABLE IF EXISTS `exam_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(50) NOT NULL,
  `password_hash` varchar(256) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `exam_users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `exam_roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_users`
--

LOCK TABLES `exam_users` WRITE;
/*!40000 ALTER TABLE `exam_users` DISABLE KEYS */;
INSERT INTO `exam_users` VALUES (1,'ivanov','65e84be33532fb784c48129675f9eff3a682b27168c0ea744b2cf58ee02337c5','ivanov','ivan','ivanovich',1),(2,'ivan','65e84be33532fb784c48129675f9eff3a682b27168c0ea744b2cf58ee02337c5','ivan','ivanov','alexandrovich',3),(3,'moder','65e84be33532fb784c48129675f9eff3a682b27168c0ea744b2cf58ee02337c5','alex','alex','',2);
/*!40000 ALTER TABLE `exam_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `film_genre`
--

DROP TABLE IF EXISTS `film_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `film_genre` (
  `film_id` int(11) DEFAULT NULL,
  `genre_id` int(11) DEFAULT NULL,
  KEY `film_id` (`film_id`),
  KEY `genre_id` (`genre_id`),
  CONSTRAINT `film_genre_ibfk_1` FOREIGN KEY (`film_id`) REFERENCES `exam_films` (`id`),
  CONSTRAINT `film_genre_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `exam_genre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `film_genre`
--

LOCK TABLES `film_genre` WRITE;
/*!40000 ALTER TABLE `film_genre` DISABLE KEYS */;
INSERT INTO `film_genre` VALUES (1,1),(1,3),(11,3),(11,1),(11,2),(10,1),(20,3);
/*!40000 ALTER TABLE `film_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Admin','just Admin'),(2,'user','just user');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(25) NOT NULL,
  `last_name` varchar(25) NOT NULL,
  `first_name` varchar(25) NOT NULL,
  `middle_name` varchar(25) DEFAULT NULL,
  `password_hash` varchar(256) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `role_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login` (`login`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (4,'ivan','Lunina','Ivan','Alex','65e84be33532fb784c48129675f9eff3a682b27168c0ea744b2cf58ee02337c5','2020-12-20 17:02:14',1),(7,'nikita','Balduev','Nikita','Seg','65e84be33532fb784c48129675f9eff3a682b27168c0ea744b2cf58ee02337c5','2021-01-06 11:06:57',2);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visit_logs`
--

DROP TABLE IF EXISTS `visit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visit_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `path` varchar(100) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `visit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=149 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visit_logs`
--

LOCK TABLES `visit_logs` WRITE;
/*!40000 ALTER TABLE `visit_logs` DISABLE KEYS */;
INSERT INTO `visit_logs` VALUES (1,'/',NULL,'2021-01-10 11:43:19'),(2,'/static/main.js',NULL,'2021-01-10 11:43:19'),(3,'/favicon.ico',NULL,'2021-01-10 11:43:19'),(4,'/',NULL,'2021-01-11 10:24:37'),(5,'/static/main.js',NULL,'2021-01-11 10:24:37'),(6,'/favicon.ico',NULL,'2021-01-11 10:24:38'),(7,'/users',NULL,'2021-01-11 10:24:39'),(8,'/visits/logs',NULL,'2021-01-11 10:24:40'),(9,'/visits/logs',NULL,'2021-01-11 10:24:42'),(10,'/visits/stat/users',NULL,'2021-01-11 10:24:43'),(11,'/',NULL,'2021-01-11 10:25:19'),(12,'/users',NULL,'2021-01-11 10:25:22'),(13,'/visits/logs',NULL,'2021-01-11 10:25:22'),(14,'/',NULL,'2021-01-11 10:26:01'),(15,'/users',NULL,'2021-01-11 10:26:02'),(16,'/visits/logs',NULL,'2021-01-11 10:26:02'),(17,'/',NULL,'2021-01-11 10:26:38'),(18,'/users',NULL,'2021-01-11 10:26:40'),(19,'/visits/logs',NULL,'2021-01-11 10:26:41'),(20,'/visits/logs',NULL,'2021-01-11 10:26:45'),(21,'/visits/logs',NULL,'2021-01-11 10:26:46'),(22,'/visits/logs',NULL,'2021-01-11 10:26:47'),(23,'/visits/logs',NULL,'2021-01-11 10:26:48'),(24,'/visits/logs',NULL,'2021-01-11 10:26:49'),(25,'/visits/stat/pages',NULL,'2021-01-11 10:26:51'),(26,'/',NULL,'2021-01-11 10:27:05'),(27,'/users',NULL,'2021-01-11 10:27:06'),(28,'/visits/logs',NULL,'2021-01-11 10:27:06'),(29,'/visits/stat/pages',NULL,'2021-01-11 10:27:07'),(30,'/visits/stat/users',NULL,'2021-01-11 10:27:11'),(31,'/visits/stat/users',NULL,'2021-01-11 10:27:13'),(32,'/auth/login',NULL,'2021-01-11 10:27:28'),(33,'/auth/login',NULL,'2021-01-11 10:27:33'),(34,'/',4,'2021-01-11 10:27:33'),(35,'/users',4,'2021-01-11 10:27:36'),(36,'/visits/logs',4,'2021-01-11 10:27:37'),(37,'/visits/logs',4,'2021-01-11 10:27:39'),(38,'/visits/logs',4,'2021-01-11 10:27:40'),(39,'/visits/stat/users',4,'2021-01-11 10:27:41'),(40,'/visits/stat/users',4,'2021-01-11 10:28:18'),(41,'/visits/stat/users',4,'2021-01-11 10:28:19'),(42,'/visits/stat/users',4,'2021-01-11 10:28:19'),(43,'/visits/stat/users',4,'2021-01-11 10:28:19'),(44,'/visits/stat/users',4,'2021-01-11 10:28:20'),(45,'/visits/stat/users',4,'2021-01-11 10:28:20'),(46,'/visits/stat/users',4,'2021-01-11 10:28:21'),(47,'/visits/stat/users',4,'2021-01-11 10:28:21'),(48,'/visits/stat/users',4,'2021-01-11 10:28:21'),(49,'/visits/stat/users',4,'2021-01-11 10:28:22'),(50,'/visits/stat/users',4,'2021-01-11 10:28:22'),(51,'/visits/stat/users',4,'2021-01-11 10:28:22'),(52,'/visits/stat/users',4,'2021-01-11 10:28:23'),(53,'/visits/stat/users',4,'2021-01-11 10:28:23'),(54,'/visits/stat/users',4,'2021-01-11 10:28:23'),(55,'/visits/stat/users',4,'2021-01-11 10:28:24'),(56,'/visits/stat/users',4,'2021-01-11 10:28:24'),(57,'/visits/stat/users',4,'2021-01-11 10:28:25'),(58,'/visits/stat/users',4,'2021-01-11 10:28:25'),(59,'/visits/stat/users',4,'2021-01-11 10:28:25'),(60,'/visits/stat/users',4,'2021-01-11 10:28:26'),(61,'/visits/stat/users',4,'2021-01-11 10:28:26'),(62,'/visits/stat/users',4,'2021-01-11 10:28:26'),(63,'/visits/stat/users',4,'2021-01-11 10:28:26'),(64,'/visits/stat/users',4,'2021-01-11 10:28:27'),(65,'/visits/stat/users',4,'2021-01-11 10:28:27'),(66,'/visits/stat/users',4,'2021-01-11 10:28:27'),(67,'/visits/stat/users',4,'2021-01-11 10:28:28'),(68,'/visits/stat/pages',4,'2021-01-11 10:28:52'),(69,'/visits/logs',4,'2021-01-11 10:28:53'),(70,'/visits/stat/users',4,'2021-01-11 10:28:54'),(71,'/',4,'2021-01-11 10:29:10'),(72,'/visits/logs',4,'2021-01-11 10:29:12'),(73,'/visits/stat/users',4,'2021-01-11 10:29:14'),(74,'/visits/stat/pages',4,'2021-01-11 10:29:15'),(75,'/visits/stat/users',4,'2021-01-11 10:29:18'),(76,'/visits/stat/pages',4,'2021-01-11 10:35:35'),(77,'/visits/logs',4,'2021-01-11 10:35:36'),(78,'/visits/logs',4,'2021-01-11 10:35:39'),(79,'/visits/logs',4,'2021-01-11 10:35:39'),(80,'/visits/logs',4,'2021-01-11 10:35:40'),(81,'/visits/logs',4,'2021-01-11 10:35:41'),(82,'/visits/logs',4,'2021-01-11 10:35:41'),(83,'/visits/logs',4,'2021-01-11 10:35:42'),(84,'/visits/stat/pages',4,'2021-01-11 10:35:43'),(85,'/',4,'2021-01-11 10:35:44'),(86,'/users',4,'2021-01-11 10:35:45'),(87,'/visits/logs',4,'2021-01-11 10:35:49'),(88,'/users/4',4,'2021-01-11 10:35:53'),(89,'/visits/logs',4,'2021-01-11 10:35:55'),(90,'/visits/stat/users',4,'2021-01-11 10:35:56'),(91,'/visits/stat/pages',4,'2021-01-11 10:35:58'),(92,'/visits/stat/pages',4,'2021-01-11 10:35:59'),(93,'/',4,'2021-01-11 10:36:42'),(94,'/users',4,'2021-01-11 10:36:44'),(95,'/visits/logs',4,'2021-01-11 10:36:45'),(96,'/visits/stat/pages',4,'2021-01-11 10:36:46'),(97,'/visits/stat/users',4,'2021-01-11 10:38:02'),(98,'/',4,'2021-01-11 10:39:37'),(99,'/visits/logs',4,'2021-01-11 10:39:39'),(100,'/visits/stat/pages',4,'2021-01-11 10:39:40'),(101,'/visits/stat/users',4,'2021-01-11 10:39:42'),(102,'/visits/stat/pages',4,'2021-01-11 10:39:48'),(103,'/',4,'2021-01-11 10:44:33'),(104,'/visits/logs',4,'2021-01-11 10:44:34'),(105,'/visits/stat/pages',4,'2021-01-11 10:44:35'),(106,'/visits/stat/users',4,'2021-01-11 10:44:44'),(107,'/',4,'2021-01-11 10:50:26'),(108,'/users',4,'2021-01-11 10:50:27'),(109,'/visits/logs',4,'2021-01-11 10:50:27'),(110,'/visits/stat/pages',4,'2021-01-11 10:50:29'),(111,'/visits/stat/pages',4,'2021-01-11 10:50:36'),(112,'/visits/stat/pages',4,'2021-01-11 10:50:36'),(113,'/visits/stat/pages',4,'2021-01-11 10:50:37'),(114,'/visits/stat/pages',4,'2021-01-11 10:50:37'),(115,'/visits/stat/pages',4,'2021-01-11 10:50:37'),(116,'/visits/stat/pages',4,'2021-01-11 10:50:38'),(117,'/visits/stat/pages',4,'2021-01-11 10:50:38'),(118,'/visits/stat/pages',4,'2021-01-11 10:50:38'),(119,'/visits/stat/pages',4,'2021-01-11 10:50:39'),(120,'/visits/stat/pages',4,'2021-01-11 10:50:39'),(121,'/',NULL,'2021-01-15 09:09:47'),(122,'/static/main.js',NULL,'2021-01-15 09:09:48'),(123,'/favicon.ico',NULL,'2021-01-15 09:09:48'),(124,'/auth/login',NULL,'2021-01-15 09:10:01'),(125,'/auth/login',NULL,'2021-01-15 09:10:07'),(126,'/',4,'2021-01-15 09:10:07'),(127,'/users',4,'2021-01-15 09:10:10'),(128,'/users/4/edit',4,'2021-01-15 09:10:22'),(129,'/users/7/edit',4,'2021-01-15 09:11:04'),(130,'/users/7/update',4,'2021-01-15 09:11:09'),(131,'/',4,'2021-01-15 09:11:09'),(132,'/users',4,'2021-01-15 09:11:12'),(133,'/users/7/edit',4,'2021-01-15 09:11:17'),(134,'/users/7/update',4,'2021-01-15 09:11:19'),(135,'/',4,'2021-01-15 09:11:19'),(136,'/users',4,'2021-01-15 09:11:21'),(137,'/users/new',4,'2021-01-15 09:13:08'),(138,'/users/create',4,'2021-01-15 09:13:24'),(139,'/',4,'2021-01-15 09:13:24'),(140,'/users',4,'2021-01-15 09:13:26'),(141,'/users/4/edit',4,'2021-01-15 09:13:32'),(142,'/users/4/update',4,'2021-01-15 09:13:34'),(143,'/',4,'2021-01-15 09:13:34'),(144,'/',NULL,'2021-01-22 15:56:18'),(145,'/auth/login',NULL,'2021-01-22 15:56:20'),(146,'/auth/login',NULL,'2021-01-22 15:56:24'),(147,'/',4,'2021-01-22 15:56:24'),(148,'/users/4',4,'2021-01-22 15:56:31');
/*!40000 ALTER TABLE `visit_logs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-01-26 15:48:42
