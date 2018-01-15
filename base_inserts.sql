-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: ascii
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.17.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `valid_option`
--

LOCK TABLES `valid_option` WRITE;
/*!40000 ALTER TABLE `valid_option` DISABLE KEYS */;
INSERT INTO `valid_option` VALUES (1,'site',1,'INSTANT_BANNED'),(2,'site',2,'BANNED'),(3,'site',3,'REGISTRATION'),(4,'site',4,'OPEN'),(5,'connect',1,'CONNECT'),(6,'connect',2,'DISCONNECT');
/*!40000 ALTER TABLE `valid_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `flag_definition`
--

LOCK TABLES `flag_definition` WRITE;
/*!40000 ALTER TABLE `flag_definition` DISABLE KEYS */;
INSERT INTO `flag_definition` VALUES (-1,'ANYONE','+','Adrick','2016-09-30 12:09:52',NULL,NULL,-1,1000,1),(0,'GOD','G','Adrick','2016-09-30 11:40:55',NULL,NULL,1,100,1),(1,'WIZARD','W','Adrick','2016-04-23 12:14:38',NULL,NULL,1,101,1),(2,'PLAYER','P','Adrick','2016-04-23 12:14:38',NULL,NULL,1,1,1),(3,'ROOM','R','Adrick','2016-04-23 12:14:38',NULL,NULL,1,2,1),(4,'EXIT','e','Adrick','2016-04-23 12:14:38',NULL,NULL,1,3,1),(5,'OBJECT','o','Adrick','2016-04-25 10:29:37',NULL,NULL,1,4,1),(6,'LISTENER','M','Adrick',NULL,NULL,NULL,-1,200,1),(7,'SOCKET_PUPPET','S','Adrick','2016-09-30 11:41:30',NULL,NULL,1,201,1),(8,'PUPPET','p','Adrick','2016-10-12 08:40:42',NULL,NULL,-1,202,1),(10,'GUEST','g','Adrick','2016-11-03 21:34:03',NULL,NULL,1,102,1),(11,'SOCKET_INPUT','I','Adrick','2016-11-08 11:26:08',NULL,NULL,1,202,1),(12,'DARK','D','Adrick','2016-11-08 15:19:14',NULL,NULL,-1,203,1),(13,'CASE','C','Adrick','2016-11-08 16:35:12',NULL,NULL,-1,100,2),(14,'NOSPOOF','N','Adrick','2016-11-14 12:15:23',NULL,NULL,-1,204,1),(15,'VERBOSE','V','Adrick','2016-12-14 13:36:30',NULL,NULL,-1,205,1),(16,'MONITOR','M','Adrick','2017-06-06 08:16:17',NULL,NULL,1,206,1),(17,'SQL','Q','Adrick','2017-10-18 13:53:59',NULL,NULL,1,207,1),(18,'ABODE','A','Adrick','2017-11-09 10:31:29',NULL,NULL,-1,208,1),(19,'LINK_OK','L','Adrick','2017-11-10 09:05:55',NULL,NULL,-1,209,1),(20,'ENTER_OK','E','Adrick','2017-11-13 14:46:50',NULL,NULL,-1,210,1);
/*!40000 ALTER TABLE `flag_definition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `flag_permission`
--

LOCK TABLES `flag_permission` WRITE;
/*!40000 ALTER TABLE `flag_permission` DISABLE KEYS */;
INSERT INTO `flag_permission` VALUES (1,'ALL',1,2,99,'2016-11-07','Adrick',NULL,NULL),(2,'ALL',0,2,99,'2016-11-07','Adrick',NULL,NULL),(3,'DIG',10,1,20,'2016-11-07','Adrick',NULL,NULL),(4,'CLEAR',10,1,20,'2016-11-07','Adrick',NULL,NULL),(6,'CREATE',10,1,20,'2016-11-07','Adrick',NULL,NULL),(7,'DESTROY',10,1,20,'2016-11-07','Adrick',NULL,NULL),(8,'DOLIST',10,1,20,'2016-11-07','Adrick',NULL,NULL),(9,'EMIT',10,1,20,'2016-11-07','Adrick',NULL,NULL),(10,'FORCE',10,1,20,'2016-11-07','Adrick',NULL,NULL),(11,'HONEY',10,1,20,'2016-11-07','Adrick',NULL,NULL),(12,'KILL',10,1,20,'2016-11-07','Adrick',NULL,NULL),(13,'KILLPID',10,1,20,'2016-11-07','Adrick',NULL,NULL),(14,'LINK',10,1,20,'2016-11-07','Adrick',NULL,NULL),(15,'LIST',10,1,20,'2016-11-07','Adrick',NULL,NULL),(16,'NAME',10,1,20,'2016-11-07','Adrick',NULL,NULL),(17,'NEWPASSWORD',10,1,20,'2016-11-07','Adrick',NULL,NULL),(18,'OPEN',10,1,20,'2016-11-07','Adrick',NULL,NULL),(19,'PASSWORD',10,1,20,'2016-11-07','Adrick',NULL,NULL),(20,'PEMIT',10,1,20,'2016-11-07','Adrick',NULL,NULL),(21,'RESET',10,1,20,'2016-11-07','Adrick',NULL,NULL),(22,'SEND',10,1,20,'2016-11-07','Adrick',NULL,NULL),(23,'SWITCH',10,1,20,'2016-11-07','Adrick',NULL,NULL),(24,'TELNET',10,1,20,'2016-11-07','Adrick',NULL,NULL),(25,'TOAD',10,1,20,'2016-11-07','Adrick',NULL,NULL),(26,'WHILE',10,1,20,'2016-11-07','Adrick',NULL,NULL),(27,'COMMIT',10,1,20,'2016-11-07','Adrick',NULL,NULL),(28,'PRINT',10,1,20,'2016-11-07','Adrick',NULL,NULL),(29,'RELOAD',10,1,20,'2016-11-07','Adrick',NULL,NULL),(30,'TAKE',10,1,20,'2016-11-07','Adrick',NULL,NULL),(31,'DESCRIBE',10,1,20,'2016-11-07','Adrick',NULL,NULL),(32,'SET',10,-1,20,'2016-11-07','Adrick',NULL,NULL),(33,'PS',10,1,20,'2016-11-07','Adrick',NULL,NULL),(34,'DARK',2,1,20,'2016-11-08','Adrick',NULL,NULL),(35,'WHO',2,1,20,'2016-11-10','Adrick',NULL,NULL);
/*!40000 ALTER TABLE `flag_permission` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-15  2:00:02
