-- MySQL dump 10.13  Distrib 8.0.32, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: karma8_test
-- ------------------------------------------------------
-- Server version	8.0.33

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
-- Table structure for table `mailing_queue`
--

DROP TABLE IF EXISTS `mailing_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mailing_queue` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) NOT NULL,
  `from_email` varchar(255) NOT NULL,
  `to_email` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `is_sent` tinyint(1) NOT NULL DEFAULT '0',
  `send_attempts` int NOT NULL DEFAULT '0',
  `hash` varchar(32) DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mailing_queue_hash_uindex` (`hash`),
  KEY `mailing_queue_is_sent_index` (`is_sent`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mailing_queue`
--

LOCK TABLES `mailing_queue` WRITE;
/*!40000 ALTER TABLE `mailing_queue` DISABLE KEYS */;
INSERT INTO `mailing_queue` VALUES (18,'Subscription notification reminder','noreply@karma8.io','DomoniqueTSauer@jourrapide.com','AnasosR1946, your subscription is expiring soon',0,0,'4aa259007492a0988fa324e498b49ffa','2023-05-05 22:21:29','2023-05-05 22:03:56'),(19,'Subscription notification reminder','noreply@karma8.io','CurtisMSmith@armyspy.com','Usight, your subscription is expiring soon',0,0,'e4c65385178000de549ff4dac62b8246','2023-05-05 22:21:29','2023-05-05 22:03:58'),(20,'Subscription notification reminder','noreply@karma8.io','LawrenceEKnudsen@armyspy.com','Facesoccat, your subscription is expiring soon',0,0,'d2bd3a87ed6671ce856777af476aecd3','2023-05-05 22:21:29','2023-05-05 22:03:58'),(21,'Subscription notification reminder','noreply@karma8.io','LesterRBrunk@teleworm.us','Sataked, your subscription is expiring soon',0,0,'593a2b8ecd1898b162e2dc229ab44d40','2023-05-05 22:21:29','2023-05-05 22:03:58'),(22,'Subscription notification reminder','noreply@karma8.io','RichardKRedding@armyspy.com','Dogese, your subscription is expiring soon',0,0,'4f64829c7afb51fb5496d23c8f23b017','2023-05-05 22:21:29','2023-05-05 22:03:58'),(23,'Subscription notification reminder','noreply@karma8.io','PatsyPPartida@teleworm.us','Vipinted, your subscription is expiring soon',0,0,'fa2621283447a74bff7d4e778be0a02c','2023-05-05 22:21:29','2023-05-05 22:03:58'),(24,'Subscription notification reminder','noreply@karma8.io','JustinMGodwin@dayrep.com','Themady, your subscription is expiring soon',0,0,'baf89e833f70839b83994ea7548738e8','2023-05-05 22:21:29','2023-05-05 22:03:58'),(25,'Subscription notification reminder','noreply@karma8.io','AndreaMNeary@armyspy.com','Conto2001, your subscription is expiring soon',0,0,'3681eaaba763b3724ef064c559a7819d','2023-05-05 22:21:29','2023-05-05 22:03:58'),(26,'Subscription notification reminder','noreply@karma8.io','DianeKBuchanan@dayrep.com','Wenty1998, your subscription is expiring soon',0,0,'0cd4cfeefb0c6580296ce13a91a616c7','2023-05-05 22:21:29','2023-05-05 22:03:58'),(27,'Subscription notification reminder','noreply@karma8.io','BettyEGonzalez@teleworm.us','Sekhas, your subscription is expiring soon',0,0,'ffa3768731d064541c310fd302204087','2023-05-05 22:21:29','2023-05-05 22:03:58'),(28,'Subscription notification reminder','noreply@karma8.io','JohnJSmith@jourrapide.com','Hicustant, your subscription is expiring soon',0,0,'e6ce16852b3cb78ad66534bede238ef5','2023-05-05 22:21:29','2023-05-05 22:03:58'),(29,'Subscription notification reminder','noreply@karma8.io','ErlindaCFlores@armyspy.com','Abeatice54, your subscription is expiring soon',0,0,'fef54ef588de43312c8dfbe50f7fe247','2023-05-05 22:21:29','2023-05-05 22:03:58'),(30,'Subscription notification reminder','noreply@karma8.io','JohnCAllen@rhyta.com','Wastre, your subscription is expiring soon',0,0,'8fdce1aa189ad092e0427b4f0457bf7f','2023-05-05 22:21:29','2023-05-05 22:03:58'),(31,'Subscription notification reminder','noreply@karma8.io','EarlHSmith@teleworm.us','Prostand, your subscription is expiring soon',0,0,'fadc1d8ffebfd494b259d57104dfdb10','2023-05-05 22:21:29','2023-05-05 22:03:58'),(32,'Subscription notification reminder','noreply@karma8.io','RuthSFernando@teleworm.us','Andming, your subscription is expiring soon',0,0,'8b55a02d831e0c170b45a4bae88be22d','2023-05-05 22:21:29','2023-05-05 22:03:58'),(33,'Subscription notification reminder','noreply@karma8.io','KarenDTurner@jourrapide.com','Prearp, your subscription is expiring soon',0,0,'be628ac40fc39992ee529860d44b3d85','2023-05-05 22:21:29','2023-05-05 22:03:58'),(34,'Subscription notification reminder','noreply@karma8.io','MicheleSGray@jourrapide.com','Kepis1950, your subscription is expiring soon',0,0,'6339fd50c59320d6ce6937a8bd661c0e','2023-05-05 22:21:29','2023-05-05 22:03:58'),(35,'Subscription notification reminder','noreply@karma8.io','RaulNBillings@dayrep.com','Sonfigh68, your subscription is expiring soon',0,0,'073eaa17a71589e59dd77ecc40db1112','2023-05-05 22:21:29','2023-05-05 22:03:58'),(36,'Subscription notification reminder','noreply@karma8.io','LeonardCMaldonado@teleworm.us','Nowityriet, your subscription is expiring soon',0,0,'8319dce08f7162418074192209f52755','2023-05-05 22:21:29','2023-05-05 22:03:58'),(37,'Subscription notification reminder','noreply@karma8.io','JerryKTierney@teleworm.us','Reares1997, your subscription is expiring soon',0,0,'14e943e087e909070194901a05952280','2023-05-05 22:21:29','2023-05-05 22:03:58'),(38,'Subscription notification reminder','noreply@karma8.io','DomoniqueTSauer@jourrapide.com','AnasosR1946, your subscription is expiring soon',0,0,'47e7f3ef418b7b336943db0ea2a50499','2023-05-05 22:22:00','2023-05-05 22:03:58'),(39,'Subscription notification reminder','noreply@karma8.io','CurtisMSmith@armyspy.com','Usight, your subscription is expiring soon',0,0,'470cdaaa6b5c0f769d82c51f842be41a','2023-05-05 22:22:00','2023-05-05 22:03:58'),(40,'Subscription notification reminder','noreply@karma8.io','LawrenceEKnudsen@armyspy.com','Facesoccat, your subscription is expiring soon',0,0,'6e5706ac4a7d70cdc65ef88107ce7c25','2023-05-05 22:22:00','2023-05-05 22:03:58'),(41,'Subscription notification reminder','noreply@karma8.io','LesterRBrunk@teleworm.us','Sataked, your subscription is expiring soon',0,0,'72d332e64ac04a4d010e5f6f3c9d62ff','2023-05-05 22:22:00','2023-05-05 22:03:58'),(42,'Subscription notification reminder','noreply@karma8.io','RichardKRedding@armyspy.com','Dogese, your subscription is expiring soon',0,0,'ee4bc6c7fed90010236a03e11f3781d0','2023-05-05 22:22:00','2023-05-05 22:03:58'),(43,'Subscription notification reminder','noreply@karma8.io','PatsyPPartida@teleworm.us','Vipinted, your subscription is expiring soon',0,0,'94a4cea9e7f59de7187cd1600fe338b9','2023-05-05 22:22:00','2023-05-05 22:03:58'),(44,'Subscription notification reminder','noreply@karma8.io','JustinMGodwin@dayrep.com','Themady, your subscription is expiring soon',0,0,'136b6468d243abf4451df885d9279279','2023-05-05 22:22:00','2023-05-05 22:03:58'),(45,'Subscription notification reminder','noreply@karma8.io','AndreaMNeary@armyspy.com','Conto2001, your subscription is expiring soon',0,0,'e6f3831c4cd55276031ddc5d34bf5aed','2023-05-05 22:22:00','2023-05-05 22:03:58'),(46,'Subscription notification reminder','noreply@karma8.io','DianeKBuchanan@dayrep.com','Wenty1998, your subscription is expiring soon',0,0,'fd28b65da87cd46a416e6f9da04153a5','2023-05-05 22:22:00','2023-05-05 22:03:58'),(47,'Subscription notification reminder','noreply@karma8.io','BettyEGonzalez@teleworm.us','Sekhas, your subscription is expiring soon',0,0,'fe64aae1327c978490526dbdcea9e398','2023-05-05 22:22:00','2023-05-05 22:03:58'),(48,'Subscription notification reminder','noreply@karma8.io','JohnJSmith@jourrapide.com','Hicustant, your subscription is expiring soon',0,0,'c407bbe49d27afb80ec80fdef3367d93','2023-05-05 22:22:00','2023-05-05 22:03:58'),(49,'Subscription notification reminder','noreply@karma8.io','ErlindaCFlores@armyspy.com','Abeatice54, your subscription is expiring soon',0,0,'3d18862eb20d822025787c4c21f14da8','2023-05-05 22:22:00','2023-05-05 22:03:58'),(50,'Subscription notification reminder','noreply@karma8.io','JohnCAllen@rhyta.com','Wastre, your subscription is expiring soon',0,0,'a64167dd21f534eaa7864183671c9312','2023-05-05 22:22:00','2023-05-05 22:03:58'),(51,'Subscription notification reminder','noreply@karma8.io','EarlHSmith@teleworm.us','Prostand, your subscription is expiring soon',0,0,'666e8708a52ce78dd4b8e9cbbf766dfc','2023-05-05 22:22:00','2023-05-05 22:03:58'),(52,'Subscription notification reminder','noreply@karma8.io','RuthSFernando@teleworm.us','Andming, your subscription is expiring soon',0,0,'87cc9a242a8ace908c805771423d8929','2023-05-05 22:22:00','2023-05-05 22:03:58'),(53,'Subscription notification reminder','noreply@karma8.io','KarenDTurner@jourrapide.com','Prearp, your subscription is expiring soon',0,0,'0bd275c662ae9cdc3336d317454ff2d0','2023-05-05 22:22:00','2023-05-05 22:03:58'),(54,'Subscription notification reminder','noreply@karma8.io','MicheleSGray@jourrapide.com','Kepis1950, your subscription is expiring soon',0,0,'1751fa1a79df76cc1fde93394c8a9c31','2023-05-05 22:22:00','2023-05-05 22:03:58'),(55,'Subscription notification reminder','noreply@karma8.io','RaulNBillings@dayrep.com','Sonfigh68, your subscription is expiring soon',0,0,'27696bcffaa2b1071cfe8c56f7eb6e0a','2023-05-05 22:22:00','2023-05-05 22:03:58'),(56,'Subscription notification reminder','noreply@karma8.io','LeonardCMaldonado@teleworm.us','Nowityriet, your subscription is expiring soon',0,0,'eb07e564242da26dde6a563dfef21fa9','2023-05-05 22:22:00','2023-05-05 22:03:58'),(57,'Subscription notification reminder','noreply@karma8.io','JerryKTierney@teleworm.us','Reares1997, your subscription is expiring soon',0,0,'bedc92ae8911c660b42e4a60967af4cf','2023-05-05 22:22:00','2023-05-05 22:03:58');
/*!40000 ALTER TABLE `mailing_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `valid_ts` int NOT NULL,
  `confirmed` tinyint NOT NULL DEFAULT '0',
  `checked` tinyint NOT NULL DEFAULT '0',
  `valid` tinyint NOT NULL DEFAULT '0',
  `expired_notified_1day` tinyint NOT NULL DEFAULT '0',
  `expired_notified_3day` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_unique` (`email`),
  KEY `notify_1day_index` (`valid_ts`,`confirmed`,`checked`,`valid`,`expired_notified_1day`),
  KEY `notify_3day_index` (`valid_ts`,`confirmed`,`checked`,`valid`,`expired_notified_3day`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Kepis1950','MicheleSGray@jourrapide.com',1683211882,1,1,1,0,0),(4,'Sekhas','BettyEGonzalez@teleworm.us',1683211812,1,1,1,0,0),(5,'Hicustant','JohnJSmith@jourrapide.com',1683211822,1,1,1,0,0),(6,'Abeatice54','ErlindaCFlores@armyspy.com',1683211832,1,1,1,0,0),(7,'Wastre','JohnCAllen@rhyta.com',1683211842,1,1,1,0,0),(8,'Prostand','EarlHSmith@teleworm.us',1683211852,1,1,1,0,0),(9,'Andming','RuthSFernando@teleworm.us',1683211862,1,1,1,0,0),(10,'Prearp','KarenDTurner@jourrapide.com',1683211872,1,1,1,0,0),(11,'Reares1997','JerryKTierney@teleworm.us',1683211892,1,1,1,0,0),(12,'AnasosR1946','DomoniqueTSauer@jourrapide.com',1683211182,1,1,1,0,0),(13,'Facesoccat','LawrenceEKnudsen@armyspy.com',1683211282,1,1,1,0,0),(14,'Sataked','LesterRBrunk@teleworm.us',1683211382,1,1,1,0,0),(15,'Dogese','RichardKRedding@armyspy.com',1683211482,1,1,1,0,0),(16,'Vipinted','PatsyPPartida@teleworm.us',1683211582,1,1,1,0,0),(17,'Themady','JustinMGodwin@dayrep.com',1683211682,1,1,1,0,0),(18,'Conto2001','AndreaMNeary@armyspy.com',1683211782,1,1,1,0,0),(19,'Sonfigh68','RaulNBillings@dayrep.com',1683211882,1,1,1,0,0),(20,'Wenty1998','DianeKBuchanan@dayrep.com',1683211782,1,1,1,0,0),(21,'Usight','CurtisMSmith@armyspy.com',1683211182,1,1,1,0,0),(22,'Nowityriet','LeonardCMaldonado@teleworm.us',1683211882,1,1,1,0,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-05-06  2:05:51
