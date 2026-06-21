-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: itrac_db
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `activity_logs`
--

DROP TABLE IF EXISTS `activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_logs` (
  `log_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `log_admin_id` bigint unsigned NOT NULL,
  `log_action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `log_short_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `log_full_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `log_created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `fk_admin_id` (`log_admin_id`),
  CONSTRAINT `fk_admin_id` FOREIGN KEY (`log_admin_id`) REFERENCES `admins_tbl` (`admin_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_logs`
--

LOCK TABLES `activity_logs` WRITE;
/*!40000 ALTER TABLE `activity_logs` DISABLE KEYS */;
INSERT INTO `activity_logs` VALUES (3,1,'ROLE_RENAME','Renamed Role: ADAA','Updated role name from \'Assistant Director for Academic Affairs\' to \'ADAA\'','2026-05-12 15:34:53'),(4,1,'ROLE_RENAME','Renamed Role: Assistant Director for Academic Affairs','Updated role name from \'ADAA\' to \'Assistant Director for Academic Affairs\'','2026-05-13 01:16:38'),(5,1,'DEPT_ADD','Jayyy  added to Extension Services','Added Jayyy  to additional department: \'Extension Services\' as \'No Role\'','2026-05-13 01:27:10'),(6,1,'ROLE_ASSIGN','Jayyy  is now Head - Extension Services','Assigned Jayyy  to \'Head - Extension Services\' in Extension Services','2026-05-13 01:27:18'),(7,1,'DEPT_CREATE','New Dept: Sample','Added new department \'Sample\' without any roles yet','2026-05-13 02:37:28'),(8,1,'DEPT_RENAME','Renamed Dept: Office Of The Budget','Updated department name from \'Budget Office\' to \'Office Of The Budget\'','2026-05-13 05:24:41'),(9,1,'DEPT_ADD','Ivan Ray Ancero added to Gender and Development','Added Ivan Ray Ancero to additional department: \'Gender and Development\' as \'No Role\'','2026-05-14 00:38:52'),(10,1,'DEPT_ADD','Ramil Leonardo Africa added to Director\'s Office','Added Ramil Leonardo Africa to additional department: \'Director\'s Office\' as \'No Role\'','2026-05-14 00:43:32'),(11,1,'DEPT_ADD','Mitchie Caurel added to Admission, Guidance and Counseling','Added Mitchie Caurel to additional department: \'Admission, Guidance and Counseling\' as \'Head - Admission, Guidance and Counseling\'','2026-05-14 01:04:53'),(12,1,'ROLE_ASSIGN','Mitchie Caurel is now Head - Admission, Guidance and Counseling','Assigned Mitchie Caurel to \'Head - Admission, Guidance and Counseling\' in Admission, Guidance and Counseling','2026-05-14 01:04:53'),(13,1,'DEPT_ADD','Mitchie Caurel added to Office of Student Affairs','Added Mitchie Caurel to additional department: \'Office of Student Affairs\' as \'Head - Office of Student Affairs\'','2026-05-14 01:04:53'),(14,1,'ROLE_ASSIGN','Mitchie Caurel is now Head - Office of Student Affairs','Assigned Mitchie Caurel to \'Head - Office of Student Affairs\' in Office of Student Affairs','2026-05-14 01:04:53'),(15,1,'DEPT_ADD','Mitchie Caurel added to Admission, Guidance and Counseling','Added Mitchie Caurel to additional department: \'Admission, Guidance and Counseling\' as \'Head - Admission, Guidance and Counseling\'','2026-05-14 01:28:11'),(16,1,'ROLE_ASSIGN','Mitchie Caurel is now Head - Admission, Guidance and Counseling','Assigned Mitchie Caurel to \'Head - Admission, Guidance and Counseling\' in Admission, Guidance and Counseling','2026-05-14 01:28:11'),(17,1,'DEPT_ADD','Mitchie Caurel added to Office of Student Affairs','Added Mitchie Caurel to additional department: \'Office of Student Affairs\' as \'Head - Office of Student Affairs\'','2026-05-14 01:28:50'),(18,1,'ROLE_ASSIGN','Mitchie Caurel is now Head - Office of Student Affairs','Assigned Mitchie Caurel to \'Head - Office of Student Affairs\' in Office of Student Affairs','2026-05-14 01:28:50'),(19,1,'ROLE_REMOVED','Role removed: Head - Admission, Guidance and Counseling','Removed Mitchie Caurel from the role of \'Head - Admission, Guidance and Counseling\' in Unknown','2026-05-14 01:42:54'),(20,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Assistant Director for Academic Affairs','Assigned Emmanuel Ferrer to \'Assistant Director for Academic Affairs\' in Assistant Director for Academic Affairs Office','2026-05-14 02:21:11'),(21,1,'ROLE_ASSIGN','Ryunosuke Akutagawa is now Section Head - Bachelor of Technical-Vocational Teacher Education','Assigned Ryunosuke Akutagawa to \'Section Head - Bachelor of Technical-Vocational Teacher Education\' in Basic Arts and Sciences Department','2026-05-14 02:21:11'),(22,1,'DEPT_TRANSFER','John Rex Duran moved to Procurement','Transferred John Rex Duran from Basic Arts and Sciences Department to Procurement as \'Head - Procurement\'','2026-05-14 02:21:11'),(23,1,'DEPT_TRANSFER','Ramil Leonardo Africa moved to Human Resource Management','Transferred Ramil Leonardo Africa from Director\'s Office to Human Resource Management as \'Head - Human Resource Management\'','2026-05-14 02:21:11'),(24,1,'DEPT_REMOVED','Mitchie Caurel removed from Admission, Guidance and Counseling','Removed Mitchie Caurel from department: Admission, Guidance and Counseling and cleared associated role: None','2026-05-14 02:22:23'),(25,1,'DEPT_ADD','Mitchie Caurel added to Admission, Guidance and Counseling','Added Mitchie Caurel to additional department: \'Admission, Guidance and Counseling\' as \'Head - Admission, Guidance and Counseling\'','2026-05-14 02:25:25'),(26,1,'ROLE_ASSIGN','Mitchie Caurel is now Head - Admission, Guidance and Counseling','Assigned Mitchie Caurel to \'Head - Admission, Guidance and Counseling\' in Admission, Guidance and Counseling','2026-05-14 02:25:25'),(27,1,'ROLE_CREATE','New role: Campus Director','Added new role \'Campus Director\' under department \'Director\'s Office\'','2026-05-14 02:26:14'),(28,1,'ROLE_DELETE','Role deleted: Campus Director','Removed role \'Campus Director\' from department \'Director\'s Office\'','2026-05-14 02:28:35'),(29,1,'ROLE_CREATE','New role: Registration Officer','Added new role \'Registration Officer\' under department \'Registration\'','2026-05-14 02:35:00'),(30,1,'ROLE_CREATE','New role: Campus Director','Added new role \'Campus Director\' under department \'Director\'s Office\'','2026-05-14 02:35:00'),(31,1,'ROLE_DELETE','Role deleted: Campus Director','Removed role \'Campus Director\' from department \'Director\'s Office\'','2026-05-14 02:35:11'),(32,1,'ROLE_CREATE','New role: sadad','Added new role \'sadad\' under department \'Director\'s Office\'','2026-05-14 02:41:30'),(33,1,'ROLE_DELETE','Role deleted: sadad','Removed role \'sadad\' from department \'Director\'s Office\'','2026-05-14 02:41:39'),(34,1,'ROLE_CREATE','New role: Campus Director','Added new role \'Campus Director\' under department \'Director\'s Office\'','2026-05-14 03:17:59'),(35,1,'ROLE_DELETE','Role deleted: Campus Director','Removed role \'Campus Director\' from department \'Director\'s Office\'','2026-05-14 03:18:30'),(36,1,'ROLE_CREATE','New role: Campus Director','Added new role \'Campus Director\' under department \'Director\'s Office\'','2026-05-14 03:21:47'),(37,1,'ROLE_DELETE','Role deleted: Campus Director','Removed role \'Campus Director\' from department \'Director\'s Office\'','2026-05-14 03:21:56'),(38,3,'ROLE_ASSIGN','Patrick Justin Ariado is now Section Head - Bachelor of Technical-Vocational Teacher Education','Assigned Patrick Justin Ariado to \'Section Head - Bachelor of Technical-Vocational Teacher Education\' in Basic Arts and Sciences Department','2026-05-15 03:17:52'),(39,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Department Head - Basic Arts and Sciences Department','Assigned Emmanuel Ferrer to \'Department Head - Basic Arts and Sciences Department\' in Basic Arts and Sciences Department','2026-05-20 22:20:04'),(40,1,'ROLE_ASSIGN','Patrick Justin Ariado is now Section Head - Bachelor of Technical-Vocational Teacher Education','Assigned Patrick Justin Ariado to \'Section Head - Bachelor of Technical-Vocational Teacher Education\' in Basic Arts and Sciences Department','2026-05-20 22:20:04'),(41,1,'ROLE_ASSIGN','Heherson Ramos is now Department Head - Basic Arts and Sciences Department','Assigned Heherson Ramos to \'Department Head - Basic Arts and Sciences Department\' in Basic Arts and Sciences Department','2026-05-20 22:20:04'),(42,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Department Head - Basic Arts and Sciences Department','Assigned Emmanuel Ferrer to \'Department Head - Basic Arts and Sciences Department\' in Basic Arts and Sciences Department','2026-05-20 22:20:24'),(43,1,'ROLE_ASSIGN','Heherson Ramos is now Department Head - Basic Arts and Sciences Department','Assigned Heherson Ramos to \'Department Head - Basic Arts and Sciences Department\' in Basic Arts and Sciences Department','2026-05-20 22:20:24'),(44,1,'DEPT_TRANSFER','Emmanuel Ferrer moved to Admission, Guidance and Counseling','Transferred Emmanuel Ferrer from Basic Arts and Sciences Department to Admission, Guidance and Counseling as \'No Role\'','2026-05-20 22:21:01'),(45,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Head - Admission, Guidance and Counseling','Assigned Emmanuel Ferrer to \'Head - Admission, Guidance and Counseling\' in Admission, Guidance and Counseling','2026-05-20 22:21:01'),(46,1,'DEPT_ADD','Emmanuel Ferrer added to Office of Student Affairs','Added Emmanuel Ferrer to additional department: \'Office of Student Affairs\' as \'No Role\'','2026-05-20 22:21:55'),(47,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Head - Office of Student Affairs','Assigned Emmanuel Ferrer to \'Head - Office of Student Affairs\' in Office of Student Affairs','2026-05-20 22:21:55'),(48,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Head - Admission, Guidance and Counseling','Assigned Emmanuel Ferrer to \'Head - Admission, Guidance and Counseling\' in Admission, Guidance and Counseling','2026-05-20 22:22:45'),(49,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Head - Office of Student Affairs','Assigned Emmanuel Ferrer to \'Head - Office of Student Affairs\' in Office of Student Affairs','2026-05-20 22:24:26'),(50,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Head - Admission, Guidance and Counseling','Assigned Emmanuel Ferrer to \'Head - Admission, Guidance and Counseling\' in Admission, Guidance and Counseling','2026-05-20 22:27:45'),(51,1,'DEPT_REMOVED','Emmanuel Ferrer removed from Office of Student Affairs','Removed Emmanuel Ferrer from department: Office of Student Affairs and cleared associated role: Head - Office of Student Affairs','2026-05-20 22:36:35'),(52,1,'DEPT_TRANSFER','John Rex Duran moved to Office of Student Affairs','Transferred John Rex Duran from Procurement to Office of Student Affairs as \'No Role\'','2026-05-20 22:37:19'),(53,1,'ROLE_ASSIGN','John Rex Duran is now Head - Office of Student Affairs','Assigned John Rex Duran to \'Head - Office of Student Affairs\' in Office of Student Affairs','2026-05-20 22:37:19'),(54,1,'ROLE_ASSIGN','Patrick Justin Ariado is now Program Chair - Bachelor of Technical-Vocational Teacher Education','Assigned Patrick Justin Ariado to \'Program Chair - Bachelor of Technical-Vocational Teacher Education\' in College of Education and Scienecs','2026-05-20 23:08:48'),(55,1,'DEPT_ADD','Emmanuel Ferrer added to College of Engineering','Added Emmanuel Ferrer to additional department: \'College of Engineering\' as \'No Role\'','2026-05-21 04:29:20'),(56,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Dean - College of Engineering','Assigned Emmanuel Ferrer to \'Dean - College of Engineering\' in College of Engineering','2026-05-21 04:29:20'),(57,1,'USER_PASSWORD_RESET','Password Reset: Emmanuel Peque Ferrer II','Administratively updated/reset the account password for user \'Emmanuel Peque Ferrer II\' (TUP ID: 230253).','2026-05-21 20:54:13'),(58,1,'USER_DELETE','Deleted User: Annaline C. Tanto','Permanently deleted the account of user \'Annaline C. Tanto\' (TUP ID: ) from the system.','2026-05-21 20:55:50'),(59,1,'ROLE_CREATE','New role: Sample Role','Added new role \'Sample Role\' under department \'Sample Department\'','2026-05-22 01:26:53'),(60,1,'ROLE_CREATE','New role: Campus Director','Added new role \'Campus Director\' under department \'Director\'s Office\'','2026-05-22 01:28:12'),(61,1,'DEPT_REASSIGN','Accounting reassigned to Director\'s Office','Reassigned department \'Accounting\' from \'Assistant Director For Administration And Finance Office\' to \'Director\'s Office\'','2026-05-22 02:12:12'),(62,1,'DEPT_REASSIGN','Accounting reassigned to Assistant Director For Administration And Finance Office','Reassigned department \'Accounting\' from \'Director\'s Office\' to \'Assistant Director For Administration And Finance Office\'','2026-05-22 02:12:27'),(63,1,'ROLE_DELETE','Role deleted: Head - Accounting','Removed role \'Head - Accounting\' from department \'Accounting\'','2026-05-22 02:35:55'),(64,1,'ROLE_CREATE','New role: Accountant','Added new role \'Accountant\' under department \'Accounting\'','2026-05-22 02:43:27'),(65,1,'ROLE_ASSIGN','Mitchie Caurel is now Head - Office of Student Affairs','Assigned Mitchie Caurel to \'Head - Office of Student Affairs\' (Previously: John Rex Duran)','2026-05-22 16:12:34'),(66,1,'USER_UPDATE','Updated User: Emmanuel Peque Ferrer','Updated account profile details for user \'Emmanuel Peque Ferrer\' (TUP ID: 234123).','2026-05-22 17:13:05'),(67,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Dean - College of Education and Sciences','Assigned Emmanuel Ferrer to \'Dean - College of Education and Sciences\' in College of Education and Scienecs','2026-05-22 17:13:15'),(68,1,'DEPT_TRANSFER','Emmanuel Ferrer moved to Assistant Director for Academic Affairs Office','Transferred Emmanuel Ferrer from College of Education and Scienecs to Assistant Director for Academic Affairs Office as \'No Role\'','2026-05-22 17:21:58'),(69,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Assistant Director for Academic Affairs','Assigned Emmanuel Ferrer to \'Assistant Director for Academic Affairs\' in Assistant Director for Academic Affairs Office','2026-05-22 17:21:58'),(70,1,'DEPT_TRANSFER','Emmanuel Ferrer moved to Assistant Director for Research and Extension Office','Transferred Emmanuel Ferrer from Assistant Director for Academic Affairs Office to Assistant Director for Research and Extension Office as \'No Role\'','2026-05-22 17:30:05'),(71,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Assistant Director in Research and Extension','Assigned Emmanuel Ferrer to \'Assistant Director in Research and Extension\' in Assistant Director for Research and Extension Office','2026-05-22 17:30:05'),(72,1,'DEPT_TRANSFER','Emmanuel Ferrer moved to Assistant Director for Academic Affairs Office','Transferred Emmanuel Ferrer from Assistant Director for Research and Extension Office to Assistant Director for Academic Affairs Office as \'No Role\'','2026-05-22 17:30:38'),(73,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Assistant Director for Academic Affairs','Assigned Emmanuel Ferrer to \'Assistant Director for Academic Affairs\' in Assistant Director for Academic Affairs Office','2026-05-22 17:30:38'),(74,1,'DEPT_TRANSFER','Emmanuel Ferrer moved to College of Education and Scienecs','Transferred Emmanuel Ferrer from Assistant Director for Academic Affairs Office to College of Education and Scienecs as \'No Role\'','2026-05-22 17:37:57'),(75,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Dean - College of Education and Sciences','Assigned Emmanuel Ferrer to \'Dean - College of Education and Sciences\' in College of Education and Scienecs','2026-05-22 17:37:57'),(76,1,'ROLE_CHANGE','Patrick Justin Ariado updated in College of Education and Scienecs','Changed Patrick Justin Ariado\'s role in College of Education and Scienecs from \'Program Chair - Bachelor of Technical-Vocational Teacher Education\' to \'Program Chair - Bachelor of Science in Environmental Science\'','2026-05-22 17:38:53'),(77,1,'ROLE_CHANGE','Emmanuel Ferrer updated in College of Education and Scienecs','Changed Emmanuel Ferrer\'s role in College of Education and Scienecs from \'Dean - College of Education and Sciences\' to \'Program Chair - Bachelor of Technical-Vocational Teacher Education\'','2026-05-22 17:38:59'),(78,1,'DEPT_TRANSFER','Emmanuel Ferrer moved to Extension Services','Transferred Emmanuel Ferrer from College of Education and Sciences to Extension Services as \'No Role\'','2026-05-22 17:54:17'),(79,2,'DEPT_TRANSFER','Patrick Justin Ariado moved to Property and Supply','Transferred Patrick Justin Ariado from College of Education and Sciences to Property and Supply as \'No Role\'','2026-05-22 19:38:56'),(80,2,'ROLE_ASSIGN','Patrick Justin Ariado is now Head - Property and Supply','Assigned Patrick Justin Ariado to \'Head - Property and Supply\' in Property and Supply','2026-05-22 19:38:56'),(81,2,'ROLE_ASSIGN','Heherson Ramos is now Dean - College of Education and Sciences','Assigned Heherson Ramos to \'Dean - College of Education and Sciences\' in College of Education and Sciences','2026-05-25 17:05:16'),(82,1,'DEPT_TRANSFER','Emmanuel Ferrer moved to Procurement','Transferred Emmanuel Ferrer from Extension Services to Procurement as \'No Role\'','2026-05-26 19:01:31'),(83,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Head - Procurement','Assigned Emmanuel Ferrer to \'Head - Procurement\' in Procurement','2026-05-26 19:01:31'),(84,1,'ROLE_REMOVED','Role removed: Head - Property and Supply','Removed Patrick Justin Ariado from the role of \'Head - Property and Supply\' in Property and Supply','2026-05-26 19:01:51'),(85,1,'DEPT_TRANSFER','John Rex Duran moved to Property and Supply','Transferred John Rex Duran from Office of Student Affairs to Property and Supply as \'No Role\'','2026-05-26 19:01:51'),(86,1,'ROLE_ASSIGN','John Rex Duran is now Head - Property and Supply','Assigned John Rex Duran to \'Head - Property and Supply\' in Property and Supply','2026-05-26 19:01:58'),(87,1,'ROLE_REMOVED','Role removed: Head - Property and Supply','Removed John Rex Duran from the role of \'Head - Property and Supply\' in Property and Supply','2026-05-27 05:37:17'),(88,1,'DEPT_TRANSFER','John Rex Duran moved to Procurement','Transferred John Rex Duran from Property and Supply to Procurement as \'No Role\'','2026-05-27 06:39:04'),(89,1,'DEPT_TRANSFER','Emmanuel Ferrer moved to Property and Supply','Transferred Emmanuel Ferrer from Procurement to Property and Supply as \'No Role\'','2026-05-27 19:17:51'),(90,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Head - Property and Supply','Assigned Emmanuel Ferrer to \'Head - Property and Supply\' in Property and Supply','2026-05-27 19:17:51'),(91,1,'DEPT_TRANSFER','Emmanuel Ferrer moved to College of Engineering','Transferred Emmanuel Ferrer from Property and Supply to College of Engineering as \'No Role\'','2026-05-30 02:23:54'),(92,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Dean - College of Engineering','Assigned Emmanuel Ferrer to \'Dean - College of Engineering\' in College of Engineering','2026-05-30 02:23:54'),(93,1,'ROLE_REMOVED','Role removed: Dean - College of Engineering','Removed Emmanuel Ferrer from the role of \'Dean - College of Engineering\' in College of Engineering','2026-05-30 02:36:01'),(94,1,'DEPT_TRANSFER','Emmanuel Ferrer moved to Property and Supply','Transferred Emmanuel Ferrer from College of Engineering to Property and Supply as \'No Role\'','2026-05-30 02:54:47'),(95,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Head - Property and Supply','Assigned Emmanuel Ferrer to \'Head - Property and Supply\' in Property and Supply','2026-05-30 02:54:47'),(96,1,'DEPT_TRANSFER','John Rex Duran moved to Property and Supply','Transferred John Rex Duran from Procurement to Property and Supply as \'No Role\'','2026-05-30 02:56:24'),(97,1,'DEPT_TRANSFER','Emmanuel Ferrer moved to Procurement','Transferred Emmanuel Ferrer from Property and Supply to Procurement as \'No Role\'','2026-05-30 03:17:34'),(98,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Head - Procurement','Assigned Emmanuel Ferrer to \'Head - Procurement\' in Procurement','2026-05-30 03:17:34'),(99,1,'ROLE_ASSIGN','John Rex Duran is now Head - Property and Supply','Assigned John Rex Duran to \'Head - Property and Supply\' in Property and Supply','2026-05-30 03:18:27'),(100,1,'DEPT_TRANSFER','Emmanuel Ferrer moved to Property and Supply','Transferred Emmanuel Ferrer from Procurement to Property and Supply as \'No Role\'','2026-05-30 03:26:18'),(101,1,'DEPT_TRANSFER','John Rex Duran moved to Procurement','Transferred John Rex Duran from Property and Supply to Procurement as \'No Role\'','2026-06-01 06:20:08'),(102,1,'ROLE_ASSIGN','John Rex Duran is now Head - Procurement','Assigned John Rex Duran to \'Head - Procurement\' in Procurement','2026-06-01 06:20:08'),(103,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Head - Property and Supply','Assigned Emmanuel Ferrer to \'Head - Property and Supply\' in Property and Supply','2026-06-01 06:31:55'),(104,1,'DEPT_TRANSFER','Heherson Ramos moved to Property and Supply','Transferred Heherson Ramos from College of Education and Sciences to Property and Supply as \'No Role\'','2026-06-03 21:30:59'),(105,1,'DEPT_REMOVED','Mitchie Caurel removed from Admission, Guidance and Counseling','Removed Mitchie Caurel from department: Admission, Guidance and Counseling and cleared associated role: None','2026-06-03 23:32:11'),(106,1,'DEPT_TRANSFER','John Rex Duran moved to College of Engineering','Transferred John Rex Duran from Procurement to College of Engineering as \'No Role\'','2026-06-03 23:32:23'),(107,1,'ROLE_ASSIGN','John Rex Duran is now Dean - College of Engineering','Assigned John Rex Duran to \'Dean - College of Engineering\' in College of Engineering','2026-06-03 23:32:23'),(108,1,'USER_PASSWORD_RESET','Password Reset: Angelica Feliziano Olivar','Administratively updated/reset the account password for user \'Angelica Feliziano Olivar\' (TUP ID: 312341).','2026-06-05 03:35:52'),(109,1,'USER_PASSWORD_RESET','Password Reset: John Rex Bautista Duran','Administratively updated/reset the account password for user \'John Rex Bautista Duran\' (TUP ID: 230265).','2026-06-05 03:39:14'),(110,1,'ROLE_REMOVED','Role removed: Head - Property and Supply','Removed Emmanuel Ferrer from the role of \'Head - Property and Supply\' in Property and Supply','2026-06-05 03:39:33'),(111,1,'DEPT_ADD','John Rex Duran added to Property and Supply','Added John Rex Duran to additional department: \'Property and Supply\' as \'No Role\'','2026-06-05 03:40:07'),(112,1,'ROLE_ASSIGN','John Rex Duran is now Head - Property and Supply','Assigned John Rex Duran to \'Head - Property and Supply\' in Property and Supply','2026-06-05 03:40:07'),(113,1,'DEPT_REMOVED','John Rex Duran removed from College of Engineering','Removed John Rex Duran from department: College of Engineering and cleared associated role: Dean - College of Engineering','2026-06-05 03:41:03'),(114,1,'DEPT_ADD','John Rex Duran added to College of Education and Sciences','Added John Rex Duran to additional department: \'College of Education and Sciences\' as \'No Role\'','2026-06-05 03:54:16'),(115,1,'ROLE_ASSIGN','John Rex Duran is now Dean - College of Education and Sciences','Assigned John Rex Duran to \'Dean - College of Education and Sciences\' in College of Education and Sciences','2026-06-05 03:54:16'),(116,1,'USER_PASSWORD_RESET','Password Reset: Emmanuel Peque Ferrer','Administratively updated/reset the account password for user \'Emmanuel Peque Ferrer\' (TUP ID: 234123).','2026-06-05 04:16:11'),(117,1,'DEPT_TRANSFER','Emmanuel Ferrer moved to Procurement','Transferred Emmanuel Ferrer from Property and Supply to Procurement as \'No Role\'','2026-06-05 04:16:27'),(118,1,'ROLE_ASSIGN','Emmanuel Ferrer is now Head - Procurement','Assigned Emmanuel Ferrer to \'Head - Procurement\' in Procurement','2026-06-05 04:16:27'),(119,2,'ROLE_REMOVED','Role removed: Head - Procurement','Removed Emmanuel Ferrer from the role of \'Head - Procurement\' in Procurement','2026-06-08 17:55:59'),(120,2,'DEPT_TRANSFER','Kimberlie Crissel Porteria moved to Procurement','Transferred Kimberlie Crissel Porteria from Property and Supply to Procurement as \'No Role\'','2026-06-08 17:56:37'),(121,2,'ROLE_ASSIGN','Kimberlie Crissel Porteria is now Head - Procurement','Assigned Kimberlie Crissel Porteria to \'Head - Procurement\' in Procurement','2026-06-08 17:56:37'),(122,2,'ROLE_REMOVED','Role removed: Head - Procurement','Removed Kimberlie Crissel Porteria from the role of \'Head - Procurement\' in Procurement','2026-06-11 21:59:26'),(123,2,'ROLE_REMOVED','Role removed: Head - Property and Supply','Removed John Rex Duran from the role of \'Head - Property and Supply\' in Property and Supply','2026-06-11 22:00:10'),(124,2,'ROLE_ASSIGN','John Brix Coronejo is now Head - Property and Supply','Assigned John Brix Coronejo to \'Head - Property and Supply\' in Property and Supply','2026-06-11 22:00:28'),(125,2,'DEPT_TRANSFER','John Rex Duran moved to Procurement','Transferred John Rex Duran from College of Education and Sciences to Procurement as \'No Role\'','2026-06-11 22:25:06'),(126,2,'ROLE_ASSIGN','John Rex Duran is now Head - Procurement','Assigned John Rex Duran to \'Head - Procurement\' in Procurement','2026-06-11 22:25:06'),(127,2,'DEPT_TRANSFER','Heherson Ramos moved to College of Education and Sciences','Transferred Heherson Ramos from Property and Supply to College of Education and Sciences as \'No Role\'','2026-06-11 22:32:24'),(128,2,'ROLE_ASSIGN','Heherson Ramos is now Dean - College of Education and Sciences','Assigned Heherson Ramos to \'Dean - College of Education and Sciences\' in College of Education and Sciences','2026-06-11 22:32:24'),(129,1,'USER_PASSWORD_RESET','Password Reset: Emmanuel Peque Ferrer','Administratively updated/reset the account password for user \'Emmanuel Peque Ferrer\' (TUP ID: 234123).','2026-06-12 21:46:40'),(130,1,'USER_DELETE','Deleted User: Emmanuel Peque Ferrer','Permanently deleted the account of user \'Emmanuel Peque Ferrer\' (TUP ID: 234123) from the system.','2026-06-14 15:32:13');
/*!40000 ALTER TABLE `activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admins_tbl`
--

DROP TABLE IF EXISTS `admins_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins_tbl` (
  `admin_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `admin_username` varchar(100) DEFAULT NULL,
  `admin_password` varchar(100) DEFAULT NULL,
  `admin_key` bigint DEFAULT NULL,
  PRIMARY KEY (`admin_id`),
  KEY `admin_key` (`admin_key`),
  CONSTRAINT `admins_tbl_ibfk_1` FOREIGN KEY (`admin_key`) REFERENCES `master_keys_tbl` (`master_key_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins_tbl`
--

LOCK TABLES `admins_tbl` WRITE;
/*!40000 ALTER TABLE `admins_tbl` DISABLE KEYS */;
INSERT INTO `admins_tbl` VALUES (1,'emmanadmin','$2y$12$2Fx3A90/xuLsrZvdjjcgi.hU04aYOQx38s1bifn5Lk35Qms6Ky5z.',5),(2,'jayadmin','$2y$12$elHZlibMlyli563qqafXNu9d.4eMU5VbOlNm3zsP14d3NYxkcvvuq',2),(3,'uitc_web_admin','$2y$12$kWkTL0BSVI4c5wt6YWwlxutEWROBRk.y4oNNKbEDcU1fyFjt8KR7O',3);
/*!40000 ALTER TABLE `admins_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_items_tbl`
--

DROP TABLE IF EXISTS `app_items_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_items_tbl` (
  `app_item_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `app_id_fk` bigint unsigned DEFAULT NULL,
  `app_item_proj_title` varchar(100) DEFAULT NULL,
  `app_items_end_user` varchar(100) DEFAULT NULL,
  `app_items_gen_desc` varchar(50) DEFAULT NULL,
  `app_items_mode` varchar(100) DEFAULT NULL,
  `app_items_covered` enum('Yes','No') DEFAULT NULL,
  `app_items_criteria` varchar(45) DEFAULT NULL,
  `app_items_start` datetime DEFAULT NULL,
  `app_items_end` varchar(45) DEFAULT NULL,
  `app_items_source` varchar(45) DEFAULT NULL,
  `app_items_esti_budget` bigint DEFAULT NULL,
  `app_items_tools` varchar(45) DEFAULT NULL,
  `app_items_remarks` varchar(50) DEFAULT NULL,
  `app_items_assigned_to` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`app_item_id`),
  KEY `fk_app_items_app` (`app_id_fk`),
  CONSTRAINT `fk_app_items_app` FOREIGN KEY (`app_id_fk`) REFERENCES `app_tbl` (`app_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_items_tbl`
--

LOCK TABLES `app_items_tbl` WRITE;
/*!40000 ALTER TABLE `app_items_tbl` DISABLE KEYS */;
INSERT INTO `app_items_tbl` VALUES (35,24,'Sample sample','Sample sample','Sample sample','Sample sample','Yes','Sample sample','2026-06-05 00:00:00','2026-06-12','Sample sample',23233,'Sample sample','Sample sample',2),(38,26,'Office Supplies for Academic Staff','CES Academic Staff','Various office papers, pens, and binders','Shopping','Yes','Lowest price','2026-03-01 08:00:00','2026-03-15 17:00:00','Fid. Fund',25000,'Office administrative tools','Standard quarterly replenishment',74),(39,26,'Science Laboratory Equipment Upgrade','Chemistry and Physics Lab','Microscopes and calibration kits','Public Bidding','No','Quality and technical specifications','2026-04-10 09:00:00','2026-05-10 17:00:00','GAA',350000,'Laboratory instructional tools','Required for accreditation',74),(40,26,'Reference Books and E-Journals','College Library Department','Educational reference books and e-journal subs','Direct Contracting','No','Sole distributor validation','2026-06-01 08:00:00','2026-06-30 17:00:00','Special Trust Fund',120000,'Research and reference tools','Annual subscription renewal',74),(41,26,'Ergonomic Chairs for Faculty Rooms','CES Faculty Members','High-back ergonomic office chairs','Shopping','Yes','Lowest compliant quotation','2026-07-01 08:00:00','2026-07-20 17:00:00','Income',65000,'Faculty office furniture','Replacement of damaged chairs',74),(42,26,'Multimedia Projectors for Classrooms','CES Lecture Classrooms','Full HD smart projectors with mounts','Negotiated Procurement','Yes','Technical compliance and cost','2026-08-15 08:00:00','2026-09-05 17:00:00','GAA',180000,'Multimedia teaching tools','Smart classroom initiative phase 2',74),(43,27,'For todaysss','Basic Arts and Science Department',NULL,'Small Value Procurement','No','LCRB','2026-06-19 00:00:00','2026-06-24','Fund 05',250000,NULL,NULL,74),(44,28,'HAHAHAHHAHA','Basic Arts and Science Department',NULL,'Small Value Procurement','No','LCRB','2026-06-13 00:00:00','2026-06-14','Fund 05',250000,NULL,NULL,74),(45,28,'HAHAHHAHAH1','BSADwe',NULL,'SMall procuuremkj','No',NULL,'2026-06-20 00:00:00','2026-07-03','Found 09',121324234,NULL,NULL,74),(46,29,'HAHAHAHHAHA','Basic Arts and Science Department',NULL,'Small Value Procurement','No','LCRB','2026-06-11 00:00:00','2026-06-19','Fund 05',250000,NULL,NULL,74),(47,29,'kajdiowqhjdioqwhjdnklqwn','jsbcdjsakdujwbjkwqbd',NULL,'jsadjwqdjqw jdujhqwudhqwioud','No',NULL,'2026-06-25 00:00:00','2026-07-02','Found 6',1213141242,NULL,NULL,74),(48,30,'Sample only','Sample only','Sample only','Sample only','Yes','Sample only','2026-06-14 00:00:00','2026-06-18','Sample only',20000,'Sample only','Sample only',81),(52,31,'chairs and tables','BTVTED','Furniture','Small amount','No','Not Applicable','2026-06-16 00:00:00','2026-06-17','Fund 5',30000,NULL,NULL,74),(53,31,'Appliances','BTVTED','Appliances','Big amount','Yes',NULL,'2026-06-16 00:00:00','2026-06-17','Government Fund',500000,'Digital','Maangas',74),(54,31,'Office Supplies','BTVTED','Goods','Small amount','Yes',NULL,'2026-06-17 00:00:00','2026-06-19','Fund 1',10000,'Face-to-face','High quality dapat',NULL);
/*!40000 ALTER TABLE `app_items_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_tbl`
--

DROP TABLE IF EXISTS `app_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_tbl` (
  `app_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `app_unique_code` varchar(50) DEFAULT NULL,
  `app_title` varchar(150) DEFAULT NULL,
  `saved_by_user_id_fk` bigint unsigned DEFAULT NULL,
  `app_prepared_by_name` bigint unsigned DEFAULT NULL,
  `app_prepared_by_designation` varchar(100) DEFAULT NULL,
  `app_recommending_by_name` bigint unsigned DEFAULT NULL,
  `app_recommending_by_designation` varchar(100) DEFAULT NULL,
  `app_approved_by_name` bigint unsigned DEFAULT NULL,
  `app_approved_by_designation` varchar(100) DEFAULT NULL,
  `app_dep_id_fk` bigint DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `app_status` enum('Draft','Done') DEFAULT 'Draft',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `app_total` decimal(12,2) DEFAULT '0.00',
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`app_id`),
  UNIQUE KEY `uq_app_dept_code` (`app_unique_code`,`app_dep_id_fk`),
  KEY `fk_app_saved_by` (`saved_by_user_id_fk`),
  KEY `fk_app_prepared_by` (`app_prepared_by_name`),
  KEY `fk_app_recommending_by` (`app_recommending_by_name`),
  KEY `fk_app_approved_by` (`app_approved_by_name`),
  KEY `fk_app_department` (`app_dep_id_fk`),
  CONSTRAINT `fk_app_approved_by` FOREIGN KEY (`app_approved_by_name`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_app_department` FOREIGN KEY (`app_dep_id_fk`) REFERENCES `departments_tbl` (`dep_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_app_prepared_by` FOREIGN KEY (`app_prepared_by_name`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_app_recommending_by` FOREIGN KEY (`app_recommending_by_name`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_app_saved_by` FOREIGN KEY (`saved_by_user_id_fk`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_tbl`
--

LOCK TABLES `app_tbl` WRITE;
/*!40000 ALTER TABLE `app_tbl` DISABLE KEYS */;
INSERT INTO `app_tbl` VALUES (24,'APP-2026-01','Annual Procurement Plan for Fiscal Year 2026',NULL,NULL,NULL,NULL,NULL,NULL,NULL,15,'2026-06-04 17:21:36','Done','2026-06-04 18:08:34',33232.00,0),(26,'APP-2026-01','Annual Procurement Plan for Fiscal Year 2026',5,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-06-07 22:08:17','Done','2026-06-14 22:25:43',740000.00,1),(27,'APP-2026-02','Annual Procurement Plan for Fiscal Year 2026 Version 2',2,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-06-12 00:08:59','Done','2026-06-12 00:24:36',250000.00,0),(28,'APP-2026-03','Annual Procurement Plan for Fiscal Year 2026 Version 3',2,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-06-12 00:24:21','Done','2026-06-12 02:27:54',121574234.00,0),(29,'APP-2026-04','Annual Procurement Plan for Fiscal Year 2026 Version 4',2,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-06-12 02:27:41','Done','2026-06-14 21:50:18',1213391242.00,0),(30,'APP-2026-01','Annual Procurement Plan for Fiscal Year 2026',5,NULL,NULL,NULL,NULL,NULL,NULL,16,'2026-06-12 22:16:49','Done','2026-06-12 22:16:54',20000.00,1),(31,'APP-2026-05','Annual Procurement Plan for Fiscal Year 2026 Version 5',2,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-06-14 21:49:08','Done','2026-06-14 22:25:43',540000.00,0);
/*!40000 ALTER TABLE `app_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments_tbl`
--

DROP TABLE IF EXISTS `departments_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments_tbl` (
  `dep_id` bigint NOT NULL AUTO_INCREMENT,
  `dep_name` varchar(255) NOT NULL,
  `dep_acronym` varchar(50) DEFAULT NULL,
  `parent_dep_id` bigint DEFAULT NULL,
  PRIMARY KEY (`dep_id`),
  KEY `fk_departments_parent` (`parent_dep_id`),
  CONSTRAINT `fk_departments_parent` FOREIGN KEY (`parent_dep_id`) REFERENCES `departments_tbl` (`dep_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments_tbl`
--

LOCK TABLES `departments_tbl` WRITE;
/*!40000 ALTER TABLE `departments_tbl` DISABLE KEYS */;
INSERT INTO `departments_tbl` VALUES (1,'College of Education and Sciences','CES',36),(2,'College of Engineering','COE',36),(3,'College of Engineering Technology','CET',36),(5,'Office of Student Affairs','OSA',36),(6,'Admission, Guidance and Counseling',NULL,36),(7,'Research and Development Services',NULL,38),(8,'Extension Services',NULL,38),(9,'Innovation and Technology Support Office',NULL,38),(10,'Technology Licensing Office Coordinator',NULL,38),(11,'Quality Assurance',NULL,35),(12,'University Information Technology Center','UITC',35),(13,'Gender and Development',NULL,35),(14,'Human Resource Management',NULL,40),(15,'Property and Supply',NULL,40),(16,'Procurement',NULL,40),(17,'Infrastructure Development',NULL,40),(18,'Building and Grounds Maintenance',NULL,40),(21,'Collecting and Disbursing',NULL,40),(22,'Medical Services',NULL,40),(23,'Dental Services',NULL,40),(24,'Records Management',NULL,40),(25,'BAC Secretariat',NULL,40),(26,'Campus Business Manager',NULL,40),(27,'Registration',NULL,36),(28,'Learning Resource Center',NULL,36),(29,'Sports and Cultural Development',NULL,36),(30,'Planning Office',NULL,35),(31,'National Service Training Program','NSTP',36),(35,'Director\'s Office',NULL,NULL),(36,'Assistant Director for Academic Affairs Office','',35),(38,'Assistant Director for Research and Extension Office',NULL,35),(39,'Project Management Committee',NULL,35),(40,'Assistant Director For Administration And Finance Office',NULL,35),(41,'Budget Office',NULL,40),(44,'Accounting',NULL,40);
/*!40000 ALTER TABLE `departments_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_verifications`
--

DROP TABLE IF EXISTS `email_verifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_verifications` (
  `email_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `verification_code` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`email_id`),
  KEY `email_verifications_email_index` (`email`),
  KEY `email_verifications_expires_at_index` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_verifications`
--

LOCK TABLES `email_verifications` WRITE;
/*!40000 ALTER TABLE `email_verifications` DISABLE KEYS */;
INSERT INTO `email_verifications` VALUES (54,'emmanuel.ferrer@tup.edu.ph','954071','2026-06-14 15:51:38','2026-06-14 15:36:38','2026-06-14 15:36:38');
/*!40000 ALTER TABLE `email_verifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iar_items_specs_tbl`
--

DROP TABLE IF EXISTS `iar_items_specs_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `iar_items_specs_tbl` (
  `iar_items_spec_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `iar_items_id_fk` bigint unsigned NOT NULL,
  `po_items_spec_id_fk` bigint unsigned DEFAULT NULL,
  `iar_spec_description` text,
  PRIMARY KEY (`iar_items_spec_id`),
  KEY `idx_iar_item_fk` (`iar_items_id_fk`),
  KEY `idx_po_spec_fk` (`po_items_spec_id_fk`),
  CONSTRAINT `fk_iar_specs_item_ref` FOREIGN KEY (`iar_items_id_fk`) REFERENCES `iar_items_tbl` (`iar_items_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_iar_specs_po_ref` FOREIGN KEY (`po_items_spec_id_fk`) REFERENCES `po_items_specs_tbl` (`po_items_spec_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iar_items_specs_tbl`
--

LOCK TABLES `iar_items_specs_tbl` WRITE;
/*!40000 ALTER TABLE `iar_items_specs_tbl` DISABLE KEYS */;
INSERT INTO `iar_items_specs_tbl` VALUES (10,11,94,'A4 Size, 70/80gs'),(11,12,95,'Long/Legal Size, 70/80gsm'),(16,18,102,'5 elesi, hanabishi, kulay black'),(17,19,103,'32inch, smart tv, may netflix');
/*!40000 ALTER TABLE `iar_items_specs_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iar_items_tbl`
--

DROP TABLE IF EXISTS `iar_items_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `iar_items_tbl` (
  `iar_items_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `iar_id_fk` bigint unsigned NOT NULL,
  `iar_po_items_id_fk` bigint unsigned DEFAULT NULL,
  `iar_stock_no` varchar(50) DEFAULT NULL,
  `iar_items_descrip` varchar(255) DEFAULT NULL,
  `iar_unit` varchar(20) DEFAULT NULL,
  `iar_quantity` int DEFAULT NULL,
  PRIMARY KEY (`iar_items_id`),
  KEY `idx_iar_header_fk` (`iar_id_fk`),
  KEY `idx_iar_po_items_fk` (`iar_po_items_id_fk`),
  CONSTRAINT `fk_iar_items_header` FOREIGN KEY (`iar_id_fk`) REFERENCES `iar_tbl` (`iar_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_iar_items_po_ref` FOREIGN KEY (`iar_po_items_id_fk`) REFERENCES `po_items_tbl` (`po_items_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iar_items_tbl`
--

LOCK TABLES `iar_items_tbl` WRITE;
/*!40000 ALTER TABLE `iar_items_tbl` DISABLE KEYS */;
INSERT INTO `iar_items_tbl` VALUES (11,6,87,NULL,'Bond Pape','ReamReam',1),(12,6,88,NULL,'Bond Paper','ReamReam',5),(13,7,93,'2','Arm char, matibay, kulay green, walang bubble gum sa ilalim','piece',70),(14,7,94,'2','Lamesa, square, sturdy','piece',100),(15,8,95,'1','sample','piece',2),(18,10,96,NULL,'Electric fan','piece',5),(19,10,97,NULL,'Television','piece',5);
/*!40000 ALTER TABLE `iar_items_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iar_tbl`
--

DROP TABLE IF EXISTS `iar_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `iar_tbl` (
  `iar_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `iar_po_id_fk` bigint unsigned DEFAULT NULL,
  `iar_fund_cluster` varchar(100) DEFAULT NULL,
  `iar_supplier` varchar(100) DEFAULT NULL,
  `iar_po_no` varchar(50) DEFAULT NULL,
  `iar_po_no_date` varchar(50) DEFAULT NULL,
  `iar_office` varchar(150) DEFAULT NULL,
  `iar_center_code` varchar(50) DEFAULT NULL,
  `iar_no` varchar(50) DEFAULT NULL,
  `iar_date` date DEFAULT NULL,
  `iar_invoice_no` varchar(50) DEFAULT NULL,
  `iar_invoice_date` date DEFAULT NULL,
  `iar_date_inspected` date DEFAULT NULL,
  `iar_inspected_by` varchar(50) DEFAULT NULL,
  `iar_date_accepted` date DEFAULT NULL,
  `iar_acceptance_type` enum('Complete','Partial') DEFAULT 'Complete',
  `iar_accepted_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`iar_id`),
  KEY `idx_iar_po_fk` (`iar_po_id_fk`),
  KEY `idx_iar_inspected_by` (`iar_inspected_by`),
  KEY `idx_iar_accepted_by` (`iar_accepted_by`),
  CONSTRAINT `fk_iar_accepted` FOREIGN KEY (`iar_accepted_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_iar_po` FOREIGN KEY (`iar_po_id_fk`) REFERENCES `po_tbl` (`po_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iar_tbl`
--

LOCK TABLES `iar_tbl` WRITE;
/*!40000 ALTER TABLE `iar_tbl` DISABLE KEYS */;
INSERT INTO `iar_tbl` VALUES (6,13,NULL,'ITRAC IT Innovation Inc.','14367','14367 / 2026-06-12','Collecting and Disbursing, College of Education and Sciences, College of Engineering, College of Engineering Technology',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Complete',5,'2026-06-12 03:30:04'),(7,14,'06','Sample only','0912301','0912301 / 2026-06-16','College of Education and Sciences','III','123123','2026-06-16','13213123','2026-06-16',NULL,'Maricel Ochoa','2026-06-17','Complete',82,'2026-06-15 06:52:00'),(8,15,NULL,'sample','23123','23123 / 2026-06-16','College of Education and Sciences',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Complete',82,'2026-06-15 07:10:29'),(10,17,NULL,'ITRAC IT Innovation Inc.','14367','14367 / 2026-06-17','College of Education and Sciences',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Complete',82,'2026-06-16 02:32:55');
/*!40000 ALTER TABLE `iar_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ics_items_specs_tbl`
--

DROP TABLE IF EXISTS `ics_items_specs_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ics_items_specs_tbl` (
  `ics_items_spec_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ics_items_id_fk` bigint unsigned NOT NULL,
  `po_items_spec_id_fk` bigint unsigned DEFAULT NULL,
  `ics_spec_description` text,
  PRIMARY KEY (`ics_items_spec_id`),
  KEY `idx_ics_item_fk` (`ics_items_id_fk`),
  KEY `idx_ics_po_spec_fk` (`po_items_spec_id_fk`),
  CONSTRAINT `fk_ics_specs_item_ref` FOREIGN KEY (`ics_items_id_fk`) REFERENCES `ics_items_tbl` (`ics_items_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ics_specs_po_ref` FOREIGN KEY (`po_items_spec_id_fk`) REFERENCES `po_items_specs_tbl` (`po_items_spec_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ics_items_specs_tbl`
--

LOCK TABLES `ics_items_specs_tbl` WRITE;
/*!40000 ALTER TABLE `ics_items_specs_tbl` DISABLE KEYS */;
INSERT INTO `ics_items_specs_tbl` VALUES (4,5,101,'square, sturdy'),(5,6,101,'square, sturdy');
/*!40000 ALTER TABLE `ics_items_specs_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ics_items_tbl`
--

DROP TABLE IF EXISTS `ics_items_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ics_items_tbl` (
  `ics_items_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ics_id_fk` bigint unsigned NOT NULL,
  `ics_quantity` int DEFAULT NULL,
  `ics_unit` varchar(20) DEFAULT NULL,
  `ics_unit_cost` decimal(10,2) DEFAULT NULL,
  `ics_total_cost` decimal(10,2) DEFAULT NULL,
  `ics_items_descrip` varchar(255) DEFAULT NULL,
  `ics_inventory_item_no` varchar(50) DEFAULT NULL,
  `ics_estimated_useful_life` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ics_items_id`),
  KEY `idx_ics_header_fk` (`ics_id_fk`),
  CONSTRAINT `fk_ics_items_header_ref` FOREIGN KEY (`ics_id_fk`) REFERENCES `ics_tbl` (`ics_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ics_items_tbl`
--

LOCK TABLES `ics_items_tbl` WRITE;
/*!40000 ALTER TABLE `ics_items_tbl` DISABLE KEYS */;
INSERT INTO `ics_items_tbl` VALUES (4,4,70,'piece',500.00,35000.00,'Arm char, matibay, kulay green, walang bubble gum sa ilalim','2','70 YEARS'),(5,5,50,'piece',2000.00,100000.00,'Lamesa','2',NULL),(6,6,50,'piece',2000.00,100000.00,'Lamesa','2',NULL);
/*!40000 ALTER TABLE `ics_items_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ics_tbl`
--

DROP TABLE IF EXISTS `ics_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ics_tbl` (
  `ics_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `po_id_fk` bigint unsigned DEFAULT NULL,
  `ics_fund_cluster` varchar(100) DEFAULT NULL,
  `ics_po_no` varchar(50) DEFAULT NULL,
  `ics_no` varchar(50) DEFAULT NULL,
  `ics_code_no` varchar(50) DEFAULT NULL,
  `ics_received_from` bigint unsigned DEFAULT NULL,
  `ics_received_from_pos` varchar(100) DEFAULT NULL,
  `ics_received_from_date` date DEFAULT NULL,
  `ics_received_by` bigint unsigned DEFAULT NULL,
  `ics_received_by_pos` varchar(100) DEFAULT NULL,
  `ics_received_by_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ics_id`),
  KEY `idx_ics_po_fk` (`po_id_fk`),
  KEY `idx_ics_received_from` (`ics_received_from`),
  KEY `idx_ics_received_by` (`ics_received_by`),
  CONSTRAINT `fk_ics_po_ref` FOREIGN KEY (`po_id_fk`) REFERENCES `po_tbl` (`po_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ics_received_by` FOREIGN KEY (`ics_received_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ics_received_from` FOREIGN KEY (`ics_received_from`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ics_tbl`
--

LOCK TABLES `ics_tbl` WRITE;
/*!40000 ALTER TABLE `ics_tbl` DISABLE KEYS */;
INSERT INTO `ics_tbl` VALUES (4,14,'05','0912301','19023','71309',82,'Supply Officer','2026-06-15',74,NULL,'2026-06-15','2026-06-15 06:52:00'),(5,14,NULL,'0912301',NULL,NULL,82,'Supply Officer',NULL,5,NULL,NULL,'2026-06-15 06:52:00'),(6,14,NULL,'0912301',NULL,NULL,82,'Supply Officer',NULL,78,NULL,NULL,'2026-06-15 06:52:00');
/*!40000 ALTER TABLE `ics_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_keys_tbl`
--

DROP TABLE IF EXISTS `master_keys_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_keys_tbl` (
  `master_key_id` bigint NOT NULL AUTO_INCREMENT,
  `master_key` varchar(100) NOT NULL,
  PRIMARY KEY (`master_key_id`),
  UNIQUE KEY `master_key` (`master_key`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_keys_tbl`
--

LOCK TABLES `master_keys_tbl` WRITE;
/*!40000 ALTER TABLE `master_keys_tbl` DISABLE KEYS */;
INSERT INTO `master_keys_tbl` VALUES (1,'6oYknwNzbC'),(2,'J54oN8U6p6'),(4,'MAjqqnoQK0'),(3,'rx0qnPiajP'),(5,'yz5QBm908y');
/*!40000 ALTER TABLE `master_keys_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `message_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sender_id` bigint unsigned NOT NULL,
  `receiver_id` bigint unsigned NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`),
  KEY `sender_id` (`sender_id`),
  KEY `receiver_id` (`receiver_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (8,5,2,'Pre','2026-06-04 18:14:50','2026-06-01 21:49:36','2026-06-04 18:14:50'),(9,5,2,'Paki-validate na ng questionnaire namin.','2026-06-04 18:14:50','2026-06-01 21:49:48','2026-06-04 18:14:50'),(10,2,5,'pre','2026-06-11 23:48:08','2026-06-11 23:31:14','2026-06-11 23:48:08'),(11,2,5,'ok po','2026-06-11 23:57:21','2026-06-11 23:56:23','2026-06-11 23:57:21'),(12,2,5,'ano na?','2026-06-12 00:14:49','2026-06-12 00:02:06','2026-06-12 00:14:49'),(13,74,2,'uy','2026-06-12 00:04:28','2026-06-12 00:03:56','2026-06-12 00:04:28'),(14,2,74,'pre','2026-06-12 00:04:37','2026-06-12 00:04:35','2026-06-12 00:04:37'),(15,2,74,'??','2026-06-12 00:04:55','2026-06-12 00:04:54','2026-06-12 00:04:55'),(16,74,2,'???','2026-06-12 00:06:20','2026-06-12 00:06:04','2026-06-12 00:06:20'),(17,2,74,'????','2026-06-12 00:15:01','2026-06-12 00:06:27','2026-06-12 00:15:01'),(18,2,74,'hoy babae','2026-06-12 02:18:25','2026-06-12 02:18:11','2026-06-12 02:18:25'),(19,74,2,'po?','2026-06-12 02:19:03','2026-06-12 02:19:01','2026-06-12 02:19:03'),(20,74,2,'po?','2026-06-12 02:19:28','2026-06-12 02:19:12','2026-06-12 02:19:28'),(21,2,74,'jdhiawohdiuoqwhdfiqwjhdfklqwnfkljwqnf','2026-06-12 02:38:18','2026-06-12 02:38:03','2026-06-12 02:38:18'),(22,2,74,'hiiiii',NULL,'2026-06-12 02:45:51','2026-06-12 02:45:51'),(23,2,74,'kJSDIWQJDKLJWDKL',NULL,'2026-06-12 02:45:53','2026-06-12 02:45:53');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2026_02_22_052530_create_personal_access_tokens_table',2),(5,'2026_05_01_115755_add_profile_photo_to_users_table',3);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mr_tbl`
--

DROP TABLE IF EXISTS `mr_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mr_tbl` (
  `mr_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `assigned_to` bigint unsigned DEFAULT NULL,
  `po_item_id_fk` bigint unsigned NOT NULL,
  `mr_qr_code` varchar(100) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `specification` text,
  `quantity` int NOT NULL,
  `unit` varchar(50) NOT NULL,
  `stock` varchar(100) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `item_image` varchar(255) DEFAULT NULL,
  `is_assigned` tinyint(1) NOT NULL DEFAULT '0',
  `date_scanned` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`mr_id`),
  KEY `fk_mr_user` (`assigned_to`),
  KEY `fk_mr_po_item` (`po_item_id_fk`),
  CONSTRAINT `fk_mr_po_item` FOREIGN KEY (`po_item_id_fk`) REFERENCES `po_items_tbl` (`po_items_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_mr_user` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mr_tbl`
--

LOCK TABLES `mr_tbl` WRITE;
/*!40000 ALTER TABLE `mr_tbl` DISABLE KEYS */;
INSERT INTO `mr_tbl` VALUES (1,NULL,94,'MR-1086-3025','Lamesa, square, sturdy','',2,'piece','2',NULL,NULL,0,NULL,'2026-06-16 00:43:23','2026-06-16 00:43:23'),(2,NULL,93,'MR-1942-2562','Arm char, matibay, kulay green, walang bubble gum sa ilalim','',1,'piece','2',NULL,NULL,0,NULL,'2026-06-16 00:47:35','2026-06-16 00:47:35'),(3,NULL,96,'MR-5686-1434','Electric fan','5 elesi, hanabishi, kulay black',2,'piece',NULL,NULL,NULL,0,NULL,'2026-06-16 02:30:35','2026-06-16 02:30:35'),(4,NULL,97,'MR-5686-1434','Television','32inch, smart tv, may netflix',3,'piece',NULL,NULL,NULL,0,NULL,'2026-06-16 02:30:35','2026-06-16 02:30:35');
/*!40000 ALTER TABLE `mr_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndr_items_specs_tbl`
--

DROP TABLE IF EXISTS `ndr_items_specs_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndr_items_specs_tbl` (
  `ndr_items_spec_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ndr_items_id_fk` bigint unsigned NOT NULL,
  `po_items_spec_id_fk` bigint unsigned DEFAULT NULL,
  `ndr_spec_description` text,
  PRIMARY KEY (`ndr_items_spec_id`),
  KEY `idx_ndr_spec_item_fk` (`ndr_items_id_fk`),
  KEY `idx_ndr_spec_po_spec_fk` (`po_items_spec_id_fk`),
  CONSTRAINT `fk_ndr_specs_item_ref` FOREIGN KEY (`ndr_items_id_fk`) REFERENCES `ndr_items_tbl` (`ndr_items_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ndr_specs_po_ref` FOREIGN KEY (`po_items_spec_id_fk`) REFERENCES `po_items_specs_tbl` (`po_items_spec_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndr_items_specs_tbl`
--

LOCK TABLES `ndr_items_specs_tbl` WRITE;
/*!40000 ALTER TABLE `ndr_items_specs_tbl` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndr_items_specs_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndr_items_tbl`
--

DROP TABLE IF EXISTS `ndr_items_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndr_items_tbl` (
  `ndr_items_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ndr_id_fk` bigint unsigned NOT NULL,
  `ndr_po_items_id_fk` bigint unsigned DEFAULT NULL,
  `ndr_stock_no` varchar(50) DEFAULT NULL,
  `ndr_unit` varchar(20) DEFAULT NULL,
  `ndr_items_descrip` varchar(255) DEFAULT NULL,
  `ndr_quantity` int DEFAULT NULL,
  PRIMARY KEY (`ndr_items_id`),
  KEY `idx_ndr_header_fk` (`ndr_id_fk`),
  KEY `idx_ndr_po_items_fk` (`ndr_po_items_id_fk`),
  CONSTRAINT `fk_ndr_items_header` FOREIGN KEY (`ndr_id_fk`) REFERENCES `ndr_tbl` (`ndr_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ndr_items_po_ref` FOREIGN KEY (`ndr_po_items_id_fk`) REFERENCES `po_items_tbl` (`po_items_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndr_items_tbl`
--

LOCK TABLES `ndr_items_tbl` WRITE;
/*!40000 ALTER TABLE `ndr_items_tbl` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndr_items_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndr_tbl`
--

DROP TABLE IF EXISTS `ndr_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndr_tbl` (
  `ndr_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `po_id_fk` bigint unsigned DEFAULT NULL,
  `ndr_no` varchar(50) DEFAULT NULL,
  `ndr_date` date DEFAULT NULL,
  `ndr_reported_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ndr_id`),
  KEY `idx_ndr_po_fk` (`po_id_fk`),
  KEY `idx_ndr_reported_by` (`ndr_reported_by`),
  CONSTRAINT `fk_ndr_po_ref` FOREIGN KEY (`po_id_fk`) REFERENCES `po_tbl` (`po_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ndr_reported_by` FOREIGN KEY (`ndr_reported_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndr_tbl`
--

LOCK TABLES `ndr_tbl` WRITE;
/*!40000 ALTER TABLE `ndr_tbl` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndr_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `par_items_specs_tbl`
--

DROP TABLE IF EXISTS `par_items_specs_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `par_items_specs_tbl` (
  `par_items_spec_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `par_items_id_fk` bigint unsigned NOT NULL,
  `po_items_spec_id_fk` bigint unsigned DEFAULT NULL,
  `par_spec_description` text,
  PRIMARY KEY (`par_items_spec_id`),
  KEY `idx_par_item_fk` (`par_items_id_fk`),
  KEY `idx_par_po_spec_fk` (`po_items_spec_id_fk`),
  CONSTRAINT `fk_par_specs_item_ref` FOREIGN KEY (`par_items_id_fk`) REFERENCES `par_items_tbl` (`par_items_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_par_specs_po_ref` FOREIGN KEY (`po_items_spec_id_fk`) REFERENCES `po_items_specs_tbl` (`po_items_spec_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `par_items_specs_tbl`
--

LOCK TABLES `par_items_specs_tbl` WRITE;
/*!40000 ALTER TABLE `par_items_specs_tbl` DISABLE KEYS */;
INSERT INTO `par_items_specs_tbl` VALUES (8,8,102,'5 elesi, hanabishi, kulay black'),(9,9,103,'32inch, smart tv, may netflix');
/*!40000 ALTER TABLE `par_items_specs_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `par_items_tbl`
--

DROP TABLE IF EXISTS `par_items_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `par_items_tbl` (
  `par_items_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `par_id_fk` bigint unsigned NOT NULL,
  `par_po_items_id_fk` bigint unsigned DEFAULT NULL,
  `par_quantity` int DEFAULT NULL,
  `par_unit` varchar(20) DEFAULT NULL,
  `par_items_descrip` varchar(255) DEFAULT NULL,
  `par_property_no` varchar(50) DEFAULT NULL,
  `par_date_acquired` date DEFAULT NULL,
  `par_amount` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`par_items_id`),
  KEY `idx_par_header_fk` (`par_id_fk`),
  KEY `idx_par_po_items_fk` (`par_po_items_id_fk`),
  CONSTRAINT `fk_par_items_header_ref` FOREIGN KEY (`par_id_fk`) REFERENCES `par_tbl` (`par_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_par_items_po_ref` FOREIGN KEY (`par_po_items_id_fk`) REFERENCES `po_items_tbl` (`po_items_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `par_items_tbl`
--

LOCK TABLES `par_items_tbl` WRITE;
/*!40000 ALTER TABLE `par_items_tbl` DISABLE KEYS */;
INSERT INTO `par_items_tbl` VALUES (6,4,96,3,'piece','Electric fan, 5 elesi, hanabishi, kulay black',NULL,NULL,4500.00),(7,4,97,3,'piece','Television, 32inch, smart tv, may netflix',NULL,NULL,45000.00),(8,5,96,2,'piece','Electric fan',NULL,NULL,3000.00),(9,5,97,2,'piece','Television',NULL,NULL,30000.00);
/*!40000 ALTER TABLE `par_items_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `par_tbl`
--

DROP TABLE IF EXISTS `par_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `par_tbl` (
  `par_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `po_id_fk` bigint unsigned DEFAULT NULL,
  `par_fund_cluster` varchar(100) DEFAULT NULL,
  `par_po_no` varchar(50) DEFAULT NULL,
  `par_no` varchar(50) DEFAULT NULL,
  `par_code` varchar(50) DEFAULT NULL,
  `par_received_by` bigint unsigned DEFAULT NULL,
  `par_received_by_pos` varchar(100) DEFAULT NULL,
  `par_received_by_date` date DEFAULT NULL,
  `par_issued_by` bigint unsigned DEFAULT NULL,
  `par_issued_by_pos` varchar(100) DEFAULT NULL,
  `par_issued_by_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`par_id`),
  KEY `idx_par_po_fk` (`po_id_fk`),
  KEY `idx_par_received_by` (`par_received_by`),
  KEY `idx_par_issued_by` (`par_issued_by`),
  CONSTRAINT `fk_par_issued_by` FOREIGN KEY (`par_issued_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_par_po_ref` FOREIGN KEY (`po_id_fk`) REFERENCES `po_tbl` (`po_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_par_received_by` FOREIGN KEY (`par_received_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `par_tbl`
--

LOCK TABLES `par_tbl` WRITE;
/*!40000 ALTER TABLE `par_tbl` DISABLE KEYS */;
INSERT INTO `par_tbl` VALUES (4,17,'DOST Fund','14367','PAR No eme','PAR Code eme',78,NULL,'2026-06-17',82,'Supply Officer','2026-06-17','2026-06-16 02:32:55'),(5,17,NULL,'14367',NULL,NULL,5,NULL,NULL,82,'Supply Officer',NULL,'2026-06-16 02:32:55');
/*!40000 ALTER TABLE `par_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES (1,'App\\Models\\User',5,'auth_token','23ad10ed23c217db573dfde80d8ff5246824d2aee53331487f2d53777aee7a23','[\"*\"]',NULL,NULL,'2026-02-21 21:29:25','2026-02-21 21:29:25'),(2,'App\\Models\\User',5,'auth_token','2b1a0814c158c8fde08341cba4b613358a9f10d251c0d210c8e51e4f1bea5739','[\"*\"]',NULL,NULL,'2026-02-23 05:13:22','2026-02-23 05:13:22'),(3,'App\\Models\\User',5,'auth_token','749eafeeb84a4908ee1f1e2a975103663a467e8ea568465d6fe795abbd1e65e4','[\"*\"]',NULL,NULL,'2026-02-24 05:32:20','2026-02-24 05:32:20'),(4,'App\\Models\\User',5,'auth_token','7a6964654214663570701fb67e7aa8ae0a60944a34f9de2f2b6dbe9d5b0f486b','[\"*\"]',NULL,NULL,'2026-02-24 05:33:13','2026-02-24 05:33:13'),(5,'App\\Models\\User',6,'auth_token','2f8d36be756883f37d2bc49f6f09659b85fc536113cceffcf533981b9e0b462d','[\"*\"]',NULL,NULL,'2026-02-24 06:00:18','2026-02-24 06:00:18'),(6,'App\\Models\\User',5,'auth_token','cc4844f96007d1e9fbc3a5d865b96745df6488ff29073a16625f7f8e6c58c816','[\"*\"]',NULL,NULL,'2026-02-26 05:07:05','2026-02-26 05:07:05'),(7,'App\\Models\\User',7,'auth_token','d9254edb9edbc3199d97442118a5223d9858c26de1f844eab141a914598c31b9','[\"*\"]',NULL,NULL,'2026-02-26 05:45:03','2026-02-26 05:45:03'),(8,'App\\Models\\User',7,'auth_token','6250fafbcadd01a876eb155c290a9f492e2ca91465cf87dccf8f3736f5ff0efd','[\"*\"]',NULL,NULL,'2026-02-26 15:35:04','2026-02-26 15:35:04'),(9,'App\\Models\\User',7,'auth_token','e0bc5c96ecf51e121fbe821b81c6a40294d1472a69ca74d0e193041ed59f5b86','[\"*\"]',NULL,NULL,'2026-02-26 20:46:54','2026-02-26 20:46:54'),(10,'App\\Models\\User',7,'auth_token','263278b93235e1af5e59a7b3a265a134a06dbcf22bafb9bb23931e24627104b2','[\"*\"]',NULL,NULL,'2026-02-27 06:05:19','2026-02-27 06:05:19'),(11,'App\\Models\\User',7,'auth_token','b12077d9b5817c447799bc19161040270491920264ffdf1d906fce06e20813d2','[\"*\"]',NULL,NULL,'2026-02-27 06:34:12','2026-02-27 06:34:12'),(12,'App\\Models\\User',7,'auth_token','c1f9ebae6e51af352f10f771139045f075cff44b5dc662d580a196c8dc8dd8af','[\"*\"]',NULL,NULL,'2026-02-27 13:38:44','2026-02-27 13:38:44'),(13,'App\\Models\\User',7,'auth_token','029eeed40c6ce816c2e98bc63c9220f4bbf9dfea031efa0b059a174bfae7fda5','[\"*\"]',NULL,NULL,'2026-02-27 17:56:01','2026-02-27 17:56:01'),(14,'App\\Models\\User',7,'auth_token','a74ddd3a5f3b3a22ec91679830b6d02f2b08e5f3d6b776eaa5ac9db192bd7d50','[\"*\"]',NULL,NULL,'2026-02-27 21:49:45','2026-02-27 21:49:45'),(15,'App\\Models\\User',7,'auth_token','ee91a9291b82f47b77b27b9062629aa96ad6a94d4842b2a21c0baa794c8f28b0','[\"*\"]',NULL,NULL,'2026-02-27 21:55:09','2026-02-27 21:55:09'),(16,'App\\Models\\User',7,'auth_token','d1a2001b88c1f55e8e341102477093c290ada11011499f44a818a6ea28b22890','[\"*\"]',NULL,NULL,'2026-02-27 22:37:04','2026-02-27 22:37:04'),(17,'App\\Models\\User',8,'auth_token','03b75973ff79c761139704ffacb3d75e06ee0388d0269988ecedfb3edfb03cd3','[\"*\"]',NULL,NULL,'2026-02-28 01:46:43','2026-02-28 01:46:43'),(18,'App\\Models\\User',8,'auth_token','37db8c613d397c3a42e0cd1f870b3530dc16484a6d4e7d2643239c49c5f9ead6','[\"*\"]',NULL,NULL,'2026-02-28 01:57:58','2026-02-28 01:57:58'),(19,'App\\Models\\User',73,'auth_token','ed67fe09339ff66df242f88476aa2b64112a802e770b64def9f0d99fe5dbef55','[\"*\"]',NULL,NULL,'2026-03-12 23:24:21','2026-03-12 23:24:21'),(20,'App\\Models\\User',5,'auth_token','46703944e320028fad3f842455c53123374f4181049412b50ee37e064976abbd','[\"*\"]',NULL,NULL,'2026-05-14 04:10:11','2026-05-14 04:10:11'),(21,'App\\Models\\User',80,'auth_token','cb944b8b89f39cd7d65986d76334acf10cd90aa76effb0616708335713f9d792','[\"*\"]',NULL,NULL,'2026-05-20 23:45:35','2026-05-20 23:45:35'),(22,'App\\Models\\User',81,'auth_token','2b47ec225c0da1a0d94041948cc316a28ac9afff9b4c022e3a41e112b58ae26d','[\"*\"]',NULL,NULL,'2026-06-01 21:26:31','2026-06-01 21:26:31'),(23,'App\\Models\\User',81,'auth_token','5cb834e7df5ed2a52680e4942f890d8b90bae5034ac3eb0d96af0f60d7fdcace','[\"*\"]',NULL,NULL,'2026-06-13 00:54:53','2026-06-13 00:54:53');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_items_specs_tbl`
--

DROP TABLE IF EXISTS `po_items_specs_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `po_items_specs_tbl` (
  `po_items_spec_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `po_items_id_fk` bigint unsigned NOT NULL,
  `po_spec_description` text,
  PRIMARY KEY (`po_items_spec_id`),
  KEY `idx_po_items_fk` (`po_items_id_fk`),
  CONSTRAINT `fk_po_specs_item` FOREIGN KEY (`po_items_id_fk`) REFERENCES `po_items_tbl` (`po_items_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_items_specs_tbl`
--

LOCK TABLES `po_items_specs_tbl` WRITE;
/*!40000 ALTER TABLE `po_items_specs_tbl` DISABLE KEYS */;
INSERT INTO `po_items_specs_tbl` VALUES (88,80,'A4 Size, 70/80gsm'),(89,81,'Long/Legal Size, 70/80gsm'),(90,82,'Infinity Plan optics, 40X–1000X magnification, LED illumination'),(91,84,'Advanced Engineering, Computer Science, or Medical Science reference volumes'),(92,85,'High-back, adjustable 3D armrests, lumbar support, and nylon base'),(93,86,'3,800 lumens brightness'),(94,87,'A4 Size, 70/80gs'),(95,88,'Long/Legal Size, 70/80gsm'),(100,93,'matibay, kulay green, walang bubble gum sa ilalim'),(101,94,'square, sturdy'),(102,96,'5 elesi, hanabishi, kulay black'),(103,97,'32inch, smart tv, may netflix');
/*!40000 ALTER TABLE `po_items_specs_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_items_tbl`
--

DROP TABLE IF EXISTS `po_items_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `po_items_tbl` (
  `po_items_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `po_id_fk` bigint unsigned NOT NULL,
  `po_pr_items_id_fk` bigint unsigned DEFAULT NULL,
  `po_items_stockno` bigint unsigned DEFAULT NULL,
  `po_items_unit` varchar(20) DEFAULT NULL,
  `po_items_descrip` varchar(255) DEFAULT NULL,
  `po_items_quantity` int DEFAULT NULL,
  `po_items_cost` decimal(10,2) DEFAULT NULL,
  `po_items_amount` decimal(10,2) DEFAULT NULL,
  `po_items_total` decimal(10,2) DEFAULT NULL,
  `po_items_category` enum('Supply and Materials','Semi-Expendable','Equipment','Not Delivered') DEFAULT NULL,
  PRIMARY KEY (`po_items_id`),
  KEY `idx_po_id_fk` (`po_id_fk`),
  KEY `idx_pr_items_fk` (`po_pr_items_id_fk`),
  CONSTRAINT `fk_po_items_po` FOREIGN KEY (`po_id_fk`) REFERENCES `po_tbl` (`po_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_po_items_pr_items` FOREIGN KEY (`po_pr_items_id_fk`) REFERENCES `pr_items_tbl` (`pr_items_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_items_tbl`
--

LOCK TABLES `po_items_tbl` WRITE;
/*!40000 ALTER TABLE `po_items_tbl` DISABLE KEYS */;
INSERT INTO `po_items_tbl` VALUES (80,12,NULL,NULL,'Ream','Bond Paper',1,242.00,NULL,242.00,NULL),(81,12,NULL,NULL,'Ream','Bond Paper',5,245.00,NULL,1225.00,NULL),(82,12,NULL,NULL,'Unit','Trinocular Compound Microscope',1,5700.00,NULL,5700.00,NULL),(83,12,NULL,NULL,'Copy','Hardcover International Reference Textbook',1,8500.00,NULL,8500.00,NULL),(84,12,NULL,NULL,'Subscription','Academic E-Journal',1,125000.00,NULL,125000.00,NULL),(85,12,NULL,NULL,'Piece','Ergonomic Mesh Office Chair',1,6850.00,NULL,6850.00,NULL),(86,12,NULL,NULL,'Unit','Epson EB-X51 XGA 3LCD Projector',1,8945.00,NULL,8945.00,NULL),(87,13,NULL,NULL,'ReamReam','Bond Pape',1,242.00,NULL,242.00,'Supply and Materials'),(88,13,NULL,NULL,'ReamReam','Bond Paper',5,245.00,NULL,1225.00,'Supply and Materials'),(93,14,NULL,2,'piece','Arm char',70,500.00,NULL,35000.00,'Semi-Expendable'),(94,14,NULL,2,'piece','Lamesa',100,2000.00,NULL,200000.00,'Semi-Expendable'),(95,15,NULL,1,'piece','sample',2,50000.00,NULL,100000.00,'Supply and Materials'),(96,17,NULL,NULL,'piece','Electric fan',5,1500.00,NULL,7500.00,'Equipment'),(97,17,NULL,NULL,'piece','Television',5,15000.00,NULL,75000.00,'Equipment');
/*!40000 ALTER TABLE `po_items_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_tbl`
--

DROP TABLE IF EXISTS `po_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `po_tbl` (
  `po_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pr_id_fk` bigint unsigned DEFAULT NULL,
  `po_title` varchar(45) DEFAULT NULL,
  `po_supplier` varchar(100) DEFAULT NULL,
  `po_no` varchar(50) DEFAULT NULL,
  `po_date` varchar(50) DEFAULT NULL,
  `po_address` varchar(200) DEFAULT NULL,
  `po_tele` varchar(60) DEFAULT NULL,
  `po_tin` varchar(60) DEFAULT NULL,
  `po_mode` varchar(50) DEFAULT NULL,
  `po_tuptin` varchar(60) DEFAULT NULL,
  `po_place_delivery` varchar(100) DEFAULT NULL,
  `po_delivery_term` varchar(50) DEFAULT NULL,
  `po_date_delivery` varchar(50) DEFAULT NULL,
  `po_payment_term` varchar(50) DEFAULT NULL,
  `po_signed_by_fk` bigint unsigned DEFAULT NULL,
  `po_fund_cluster` varchar(50) DEFAULT NULL,
  `po_fund_available` varchar(100) DEFAULT NULL,
  `po_orsburs` varchar(50) DEFAULT NULL,
  `po_date_orsburs` varchar(50) DEFAULT NULL,
  `po_amount` bigint unsigned DEFAULT NULL,
  `po_total_amount` decimal(10,2) DEFAULT NULL,
  `po_amount_in_words` varchar(100) DEFAULT NULL,
  `po_description` text,
  `po_remarks` text,
  `conforme_name_of_supplier` varchar(50) DEFAULT NULL,
  `conforme_date` varchar(55) DEFAULT NULL,
  `conforme_campus_director` varchar(50) DEFAULT NULL,
  `saved_by_user_id_fk` bigint unsigned DEFAULT NULL,
  `po_unique_code` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `po_status` enum('Draft','Done') DEFAULT 'Draft',
  `retrieved_by` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`po_id`),
  KEY `idx_po_signed_by` (`po_signed_by_fk`),
  KEY `idx_saved_by_user` (`saved_by_user_id_fk`),
  KEY `fk_po_pr` (`pr_id_fk`),
  KEY `fk_po_retrieved_by` (`retrieved_by`),
  KEY `idx_po_unique_code` (`po_unique_code`),
  CONSTRAINT `fk_po_pr` FOREIGN KEY (`pr_id_fk`) REFERENCES `pr_tbl` (`pr_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_po_retrieved_by` FOREIGN KEY (`retrieved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_po_saved_by` FOREIGN KEY (`saved_by_user_id_fk`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_po_signed_by` FOREIGN KEY (`po_signed_by_fk`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_tbl`
--

LOCK TABLES `po_tbl` WRITE;
/*!40000 ALTER TABLE `po_tbl` DISABLE KEYS */;
INSERT INTO `po_tbl` VALUES (12,23,'PO_Inno','ITRAC IT Innovation Inc.','14367','2026-06-12','Barangay Katuparan, Taguig City','09999999999','000-111-222-333','Competitive Bidding','444-555-666-777','TUP Taguig','30 Days Calendar','2026-06-11','UITC Fund',NULL,NULL,NULL,NULL,NULL,NULL,156462.00,NULL,NULL,NULL,NULL,NULL,NULL,78,'PO-1-202601001-001','2026-06-11 14:53:17','Done',5),(13,23,'PO_Sup_and_Mats','ITRAC IT Innovation Inc.','14367','2026-06-12','Barangay Katuparan, Taguig City','09999999999','000-111-222-333','Competitive Bidding','444-555-666-777','TUP Taguig','30 Days Calendar','2026-06-11','UITC Fund',NULL,NULL,NULL,NULL,NULL,NULL,1467.00,NULL,NULL,NULL,NULL,NULL,NULL,78,'PO-1-202601001-002','2026-06-11 15:03:21','Done',5),(14,26,'PO_Chairsandtables','Sample only','0912301','2026-06-16','Sample only','Sample only','234-234-234-234','Sample only','234-234-234-234','Sample only','Sample only','2026-06-17','Sample only',NULL,NULL,NULL,NULL,NULL,NULL,235000.00,NULL,NULL,NULL,NULL,NULL,NULL,5,'PO-1-202605001-001','2026-06-15 06:34:52','Done',82),(15,26,'po_asda','sample','23123','2026-06-16','sample','23123123','222-222-222-222','sample','123-123-123-123','sample','sample','2026-06-16','sample',NULL,NULL,NULL,NULL,NULL,NULL,100000.00,NULL,NULL,NULL,NULL,NULL,NULL,5,'PO-1-202605001-002','2026-06-15 07:08:25','Done',82),(16,26,'PO_equip',NULL,NULL,'2026-06-16',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,'PO-1-202605001-003','2026-06-16 02:00:32','Draft',NULL),(17,26,'PO_equip','ITRAC IT Innovation Inc.','14367','2026-06-17','Taguig City','09999999999','000-111-222-333','Competitive Bidding','444-555-666-777','TUP Taguig','30 Days Calendar','2026-06-16','UITC Fund',NULL,NULL,NULL,NULL,NULL,NULL,82500.00,NULL,NULL,NULL,NULL,NULL,NULL,5,'PO-1-202605001-004','2026-06-16 02:00:35','Done',82);
/*!40000 ALTER TABLE `po_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pr_items_specs_tbl`
--

DROP TABLE IF EXISTS `pr_items_specs_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pr_items_specs_tbl` (
  `pr_items_spec_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pr_items_id_fk` bigint unsigned NOT NULL,
  `pr_spec_spec` text NOT NULL,
  PRIMARY KEY (`pr_items_spec_id`),
  KEY `idx_pr_items_id_fk` (`pr_items_id_fk`),
  CONSTRAINT `fk_pr_specs_item` FOREIGN KEY (`pr_items_id_fk`) REFERENCES `pr_items_tbl` (`pr_items_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pr_items_specs_tbl`
--

LOCK TABLES `pr_items_specs_tbl` WRITE;
/*!40000 ALTER TABLE `pr_items_specs_tbl` DISABLE KEYS */;
INSERT INTO `pr_items_specs_tbl` VALUES (98,119,'A4 Size, 70/80gsm'),(99,120,'Long/Legal Size, 70/80gsm'),(100,121,'Infinity Plan optics, 40X–1000X magnification, LED illumination'),(101,123,'Advanced Engineering, Computer Science, or Medical Science reference volumes'),(102,124,'High-back, adjustable 3D armrests, lumbar support, and nylon base'),(103,125,'3,800 lumens brightness, 12,000 hours lamp life in Eco Mode, HDMI/USB/VGA connectivity, built-in wireless/moderator capability'),(134,164,'matibay, kulay green, walang bubble gum sa ilalim'),(135,165,'square, sturdy'),(136,166,'5 elesi, hanabishi, kulay black'),(137,167,'32inch, smart tv, may netflix'),(138,168,'JBL, malakas, hindi nalo-lowbatt');
/*!40000 ALTER TABLE `pr_items_specs_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pr_items_tbl`
--

DROP TABLE IF EXISTS `pr_items_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pr_items_tbl` (
  `pr_items_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pr_id_fk` bigint unsigned NOT NULL,
  `pr_app_item_id_fk` bigint unsigned NOT NULL,
  `pr_items_quantity` int DEFAULT NULL,
  `pr_items_unit` varchar(20) DEFAULT NULL,
  `pr_items_cost` decimal(10,2) DEFAULT NULL,
  `pr_items_descrip` varchar(255) DEFAULT NULL,
  `bidding_status` enum('pending','successful','unsuccessful') NOT NULL DEFAULT 'pending',
  `pr_items_total_cost` decimal(10,2) GENERATED ALWAYS AS ((`pr_items_quantity` * `pr_items_cost`)) STORED,
  PRIMARY KEY (`pr_items_id`),
  KEY `idx_pr_id_fk` (`pr_id_fk`),
  KEY `idx_app_item_fk` (`pr_app_item_id_fk`),
  CONSTRAINT `fk_pr_items_app_item` FOREIGN KEY (`pr_app_item_id_fk`) REFERENCES `app_items_tbl` (`app_item_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pr_items_pr` FOREIGN KEY (`pr_id_fk`) REFERENCES `pr_tbl` (`pr_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=170 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pr_items_tbl`
--

LOCK TABLES `pr_items_tbl` WRITE;
/*!40000 ALTER TABLE `pr_items_tbl` DISABLE KEYS */;
INSERT INTO `pr_items_tbl` (`pr_items_id`, `pr_id_fk`, `pr_app_item_id_fk`, `pr_items_quantity`, `pr_items_unit`, `pr_items_cost`, `pr_items_descrip`, `bidding_status`) VALUES (119,23,38,1,'Ream',242.00,'Bond Paper','pending'),(120,23,38,5,'Ream',245.00,'Bond Paper','pending'),(121,23,39,1,'Unit',57000.00,'Trinocular Compound Microscope','pending'),(122,23,40,1,'Copy',8500.00,'Hardcover International Reference Textbook','pending'),(123,23,40,1,'Subscription',125000.00,'Academic E-Journal','pending'),(124,23,41,1,'Piece',6850.00,'Ergonomic Mesh Office Chair','pending'),(125,23,42,1,'Unit',28945.00,'Epson EB-X51 XGA 3LCD Projector','pending'),(126,24,43,1,'PCS',60000.00,'HP Laptop','pending'),(127,25,45,2,'PCS',44.00,'HP Laptop','pending'),(164,26,52,70,'piece',500.00,'Arm char','pending'),(165,26,52,100,'piece',2000.00,'Lamesa','pending'),(166,26,53,5,'piece',1500.00,'Electric fan','pending'),(167,26,53,5,'piece',15000.00,'Television','pending'),(168,26,53,5,'piece',1000.00,'Bluetooth speaker','pending'),(169,26,53,8,'piece',5000.00,'projector','pending');
/*!40000 ALTER TABLE `pr_items_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pr_tbl`
--

DROP TABLE IF EXISTS `pr_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pr_tbl` (
  `pr_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `app_id_fk` bigint unsigned DEFAULT NULL,
  `pr_section` varchar(50) DEFAULT NULL,
  `pr_department` bigint DEFAULT NULL,
  `pr_no` varchar(20) DEFAULT NULL,
  `pr_date` varchar(20) DEFAULT NULL,
  `pr_purpose` varchar(50) DEFAULT NULL,
  `pr_name_of_requestor` bigint unsigned DEFAULT NULL,
  `pr_designation` varchar(100) DEFAULT NULL,
  `pr_approved_by` bigint unsigned DEFAULT NULL,
  `pr_approved_by_designation` varchar(100) DEFAULT NULL,
  `saved_by_user_id_fk` bigint unsigned DEFAULT NULL,
  `pr_unique_code` varchar(50) DEFAULT NULL,
  `pr_status` enum('Draft','Complete','Exported') NOT NULL DEFAULT 'Draft',
  `submitted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `pr_total` decimal(12,2) DEFAULT '0.00',
  `retrieved_by` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`pr_id`),
  KEY `fk_pr_department` (`pr_department`),
  KEY `fk_pr_name_of_requestor` (`pr_name_of_requestor`),
  KEY `fk_pr_approved_by` (`pr_approved_by`),
  KEY `fk_saved_by_user_id_pr` (`saved_by_user_id_fk`),
  KEY `fk_pr_retrieved_by` (`retrieved_by`),
  KEY `idx_pr_unique_code` (`pr_unique_code`),
  KEY `fk_pr_app` (`app_id_fk`),
  CONSTRAINT `fk_pr_app` FOREIGN KEY (`app_id_fk`) REFERENCES `app_tbl` (`app_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_pr_approved_by` FOREIGN KEY (`pr_approved_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_pr_department` FOREIGN KEY (`pr_department`) REFERENCES `departments_tbl` (`dep_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_pr_requested_by` FOREIGN KEY (`pr_name_of_requestor`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_pr_retrieved_by` FOREIGN KEY (`retrieved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_saved_by_user_id_pr` FOREIGN KEY (`saved_by_user_id_fk`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pr_tbl`
--

LOCK TABLES `pr_tbl` WRITE;
/*!40000 ALTER TABLE `pr_tbl` DISABLE KEYS */;
INSERT INTO `pr_tbl` VALUES (23,26,'UITC Room',1,'76123','2026-06-08','Innovation',74,NULL,5,'Dean - College of Education and Sciences',74,'PR-202601-001','Exported','2026-06-07 23:36:11','2026-06-08 07:36:11',227762.00,78),(24,27,'wdwdwmkmk',1,'1234563','2026-06-12','For CES Teacher',74,NULL,NULL,NULL,74,'PR-1-202602-001','Complete','2026-06-12 00:14:11','2026-06-12 08:14:11',60000.00,NULL),(25,28,'ilang ilang',1,'111111','2026-06-12','For CES Teacher',74,NULL,NULL,NULL,74,'PR-1-202603-001','Complete','2026-06-12 02:20:59','2026-06-12 10:20:59',88.00,NULL),(26,31,'BTVTE',1,NULL,'2026-06-15','For CES',74,NULL,2,'Dean - College of Education and Sciences',74,'PR-1-202605-001','Exported','2026-06-14 22:09:05','2026-06-15 06:05:28',362500.00,5);
/*!40000 ALTER TABLE `pr_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ris_items_specs_tbl`
--

DROP TABLE IF EXISTS `ris_items_specs_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ris_items_specs_tbl` (
  `ris_items_spec_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ris_items_id_fk` bigint unsigned NOT NULL,
  `po_items_spec_id_fk` bigint unsigned DEFAULT NULL,
  `ris_spec_description` text,
  PRIMARY KEY (`ris_items_spec_id`),
  KEY `idx_ris_item_fk` (`ris_items_id_fk`),
  KEY `idx_po_spec_ref` (`po_items_spec_id_fk`),
  CONSTRAINT `fk_ris_specs_item_ref` FOREIGN KEY (`ris_items_id_fk`) REFERENCES `ris_items_tbl` (`ris_items_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ris_specs_po_ref` FOREIGN KEY (`po_items_spec_id_fk`) REFERENCES `po_items_specs_tbl` (`po_items_spec_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ris_items_specs_tbl`
--

LOCK TABLES `ris_items_specs_tbl` WRITE;
/*!40000 ALTER TABLE `ris_items_specs_tbl` DISABLE KEYS */;
INSERT INTO `ris_items_specs_tbl` VALUES (13,14,94,'A4 Size, 70/80gs'),(14,15,95,'Long/Legal Size, 70/80gsm'),(15,16,95,'Long/Legal Size, 70/80gsm'),(16,17,95,'Long/Legal Size, 70/80gsm'),(19,20,101,'square, sturdy');
/*!40000 ALTER TABLE `ris_items_specs_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ris_items_tbl`
--

DROP TABLE IF EXISTS `ris_items_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ris_items_tbl` (
  `ris_items_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ris_id_fk` bigint unsigned NOT NULL,
  `ris_po_items_id_fk` bigint unsigned DEFAULT NULL,
  `ris_stock_no` varchar(50) DEFAULT NULL,
  `ris_unit` varchar(20) DEFAULT NULL,
  `ris_items_descrip` varchar(255) DEFAULT NULL,
  `ris_quantity` int DEFAULT NULL,
  `ris_stock_available` enum('Yes','No') DEFAULT NULL,
  `ris_issued_quantity` int DEFAULT NULL,
  `ris_issued_remarks` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ris_items_id`),
  KEY `idx_ris_header_fk` (`ris_id_fk`),
  KEY `idx_ris_po_items_fk` (`ris_po_items_id_fk`),
  CONSTRAINT `fk_ris_items_header` FOREIGN KEY (`ris_id_fk`) REFERENCES `ris_tbl` (`ris_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ris_items_po_ref` FOREIGN KEY (`ris_po_items_id_fk`) REFERENCES `po_items_tbl` (`po_items_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ris_items_tbl`
--

LOCK TABLES `ris_items_tbl` WRITE;
/*!40000 ALTER TABLE `ris_items_tbl` DISABLE KEYS */;
INSERT INTO `ris_items_tbl` VALUES (14,11,87,NULL,'ReamReam','Bond Pape',1,'Yes',1,NULL),(15,12,88,NULL,'ReamReam','Bond Paper',2,'Yes',2,NULL),(16,13,88,NULL,'ReamReam','Bond Paper',1,'Yes',1,NULL),(17,14,88,NULL,'ReamReam','Bond Paper',2,'Yes',2,NULL),(18,15,93,'2','piece','Arm char, matibay, kulay green, walang bubble gum sa ilalim',1,'Yes',70,'ASDA'),(19,16,94,'2','piece','Lamesa, square, sturdy',2,'No',50,'ada'),(20,17,94,'2','piece','Lamesa',NULL,NULL,50,NULL),(21,18,95,'1','piece','sample',2,'Yes',2,NULL);
/*!40000 ALTER TABLE `ris_items_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ris_tbl`
--

DROP TABLE IF EXISTS `ris_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ris_tbl` (
  `ris_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `po_id_fk` bigint unsigned DEFAULT NULL,
  `ris_fund_cluster` varchar(100) DEFAULT NULL,
  `ris_division` varchar(150) DEFAULT NULL,
  `ris_office` varchar(150) DEFAULT NULL,
  `ris_center_code` varchar(50) DEFAULT NULL,
  `ris_no` varchar(50) DEFAULT NULL,
  `ris_purpose` text,
  `ris_requested_by` bigint unsigned DEFAULT NULL,
  `ris_requested_designation` varchar(100) DEFAULT NULL,
  `ris_requested_date` date DEFAULT NULL,
  `ris_approved_by` bigint unsigned DEFAULT NULL,
  `ris_approved_designation` varchar(100) DEFAULT NULL,
  `ris_approved_date` date DEFAULT NULL,
  `ris_issued_by` bigint unsigned DEFAULT NULL,
  `ris_issued_designation` varchar(100) DEFAULT NULL,
  `ris_issued_date` date DEFAULT NULL,
  `ris_received_by` bigint unsigned DEFAULT NULL,
  `ris_received_designation` varchar(100) DEFAULT NULL,
  `ris_received_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ris_id`),
  KEY `idx_ris_po_fk` (`po_id_fk`),
  KEY `idx_ris_requested` (`ris_requested_by`),
  KEY `idx_ris_approved` (`ris_approved_by`),
  KEY `idx_ris_issued` (`ris_issued_by`),
  KEY `idx_ris_received` (`ris_received_by`),
  CONSTRAINT `fk_ris_approved` FOREIGN KEY (`ris_approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ris_issued` FOREIGN KEY (`ris_issued_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ris_po` FOREIGN KEY (`po_id_fk`) REFERENCES `po_tbl` (`po_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ris_received` FOREIGN KEY (`ris_received_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ris_requested` FOREIGN KEY (`ris_requested_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ris_tbl`
--

LOCK TABLES `ris_tbl` WRITE;
/*!40000 ALTER TABLE `ris_tbl` DISABLE KEYS */;
INSERT INTO `ris_tbl` VALUES (11,13,NULL,NULL,'Collecting and Disbursing',NULL,NULL,'Innovation',5,NULL,NULL,5,NULL,NULL,5,NULL,NULL,NULL,NULL,NULL,'2026-06-12 03:30:04'),(12,13,NULL,NULL,'College of Education and Sciences',NULL,NULL,'Innovation',5,NULL,NULL,5,NULL,NULL,5,NULL,NULL,NULL,NULL,NULL,'2026-06-12 03:30:04'),(13,13,NULL,NULL,'College of Engineering',NULL,NULL,'Innovation',5,NULL,NULL,5,NULL,NULL,5,NULL,NULL,NULL,NULL,NULL,'2026-06-12 03:30:04'),(14,13,NULL,NULL,'College of Engineering Technology',NULL,NULL,'Innovation',5,NULL,NULL,5,NULL,NULL,5,NULL,NULL,NULL,NULL,NULL,'2026-06-12 03:30:04'),(15,14,'07',NULL,'College of Education and Sciences','CIII','12903712','For CES',74,NULL,NULL,82,NULL,NULL,82,NULL,NULL,74,NULL,'2026-06-16','2026-06-15 06:52:00'),(16,14,'07',NULL,'Property and Supply',NULL,'12903712','For CES',5,NULL,NULL,82,NULL,NULL,82,NULL,NULL,5,NULL,'2026-06-20','2026-06-15 06:52:00'),(17,14,NULL,NULL,'Procurement',NULL,NULL,'For CES',78,NULL,NULL,82,NULL,NULL,82,NULL,NULL,78,NULL,NULL,'2026-06-15 06:52:00'),(18,15,NULL,'College of Education and Sciences','College of Education and Sciences',NULL,NULL,'For CES',82,NULL,NULL,82,NULL,NULL,82,NULL,NULL,NULL,NULL,NULL,'2026-06-15 07:10:29');
/*!40000 ALTER TABLE `ris_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_tbl`
--

DROP TABLE IF EXISTS `roles_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles_tbl` (
  `role_id` bigint NOT NULL AUTO_INCREMENT,
  `role_name` varchar(255) NOT NULL,
  `role_acronym` varchar(50) DEFAULT NULL,
  `role_dep_id_fk` bigint DEFAULT NULL,
  `role_parent_id` bigint DEFAULT NULL,
  `gen_role` enum('Head','Procurement','Supply','Unassigned') DEFAULT 'Unassigned',
  PRIMARY KEY (`role_id`),
  KEY `role_dep_id_fk` (`role_dep_id_fk`),
  KEY `role_parent_id` (`role_parent_id`),
  CONSTRAINT `roles_tbl_ibfk_1` FOREIGN KEY (`role_dep_id_fk`) REFERENCES `departments_tbl` (`dep_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `roles_tbl_ibfk_2` FOREIGN KEY (`role_parent_id`) REFERENCES `roles_tbl` (`role_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_tbl`
--

LOCK TABLES `roles_tbl` WRITE;
/*!40000 ALTER TABLE `roles_tbl` DISABLE KEYS */;
INSERT INTO `roles_tbl` VALUES (1,'Dean - College of Education and Sciences',NULL,1,NULL,'Head'),(3,'Assistant Director in Research and Extension','',38,NULL,'Head'),(5,'Dean - College of Engineering',NULL,2,NULL,'Head'),(6,'Dean - College of Engineering Technology',NULL,3,NULL,'Head'),(9,'Head - Human Resource Management',NULL,14,NULL,'Head'),(10,'Head - Property and Supply',NULL,15,NULL,'Supply'),(11,'Head - Procurement',NULL,16,NULL,'Procurement'),(12,'Head - Infrastructure Development',NULL,17,NULL,'Head'),(13,'Head - Building and Grounds Maintenance',NULL,18,NULL,'Head'),(16,'Head - Collecting and Disbursing',NULL,21,NULL,'Head'),(17,'Head - Medical Services',NULL,22,NULL,'Head'),(18,'Head - Dental Services',NULL,23,NULL,'Head'),(19,'Head - Records Management',NULL,24,NULL,'Head'),(21,'Head - Campus Business Manager',NULL,26,NULL,'Head'),(22,'Head - Office of Student Affairs',NULL,5,NULL,'Head'),(23,'Head - Admission, Guidance and Counseling',NULL,6,NULL,'Head'),(24,'Head - National Service Training Program',NULL,31,NULL,'Head'),(25,'Head - Learning Resource Center',NULL,28,NULL,'Head'),(26,'Head - Sports and Cultural Development',NULL,29,NULL,'Head'),(27,'Program Chair - Bachelor of Engineering Technology Major in Chemical Technology','Program Chair - BETCHT',3,NULL,'Head'),(28,'Program Chair - Bachelor of Science in Environmental Science','Program Chair - BSES',1,NULL,'Head'),(29,'Program Chair - Bachelor of Science in Civil Engineering','Program Chair - BSCE',2,NULL,'Head'),(30,'Program Chair - Bachelor of Engineering Technology Major in Civil Technology','Program Chair - BETCT',3,NULL,'Head'),(38,'Program Chair - Bachelor of Science in Mechanical Engineering','Program Chair - BSME',2,NULL,'Head'),(39,'Program Chair - Bachelor of Engineering Technology Major in Heating, Ventilation and Air Conditioning, and Refrigeration Technology','Program Chair - BETHVAC/RT',3,NULL,'Head'),(40,'Program Chair - Bachelor of Engineering Technology Major in Dies and Moulds Technology','Program Chair - BETDMT',3,NULL,'Head'),(41,'Program Chair - Bachelor of Engineering Technology Major in Non-Destructive Testing Technology','Program Chair - BETNDT',3,NULL,'Head'),(42,'Program Chair - Bachelor of Engineering Technology Major in Electromechanical Technology','Program Chair - BETEMT',3,NULL,'Head'),(43,'Program Chair - Bachelor of Engineering Technology Major in Automotive Technology','Program Chair - BETAT',3,NULL,'Head'),(44,'Program Chair - Bachelor of Engineering Technology Major in Mechanical Technology','Program Chair - BETMT',3,NULL,'Head'),(45,'Head - Research and Development Services',NULL,7,NULL,'Head'),(46,'Head - Extension Services',NULL,8,NULL,'Head'),(47,'Head - Innovation Technology Support Office',NULL,9,NULL,'Head'),(48,'Head - Technology Licensing Office Coordinator',NULL,10,NULL,'Head'),(49,'Head - Quality Assurance',NULL,11,NULL,'Head'),(50,'Head - University Information Technology Center',NULL,12,NULL,'Head'),(51,'Head - Gender and Development',NULL,13,NULL,'Head'),(52,'Head - Project Management Committee',NULL,39,NULL,'Head'),(53,'Program Chair - Bachelor of Technical-Vocational Teacher Education','Program Chair - BTVTE',1,NULL,'Head'),(55,'Assistant Director for Administration and Finance',NULL,40,NULL,'Head'),(56,'Planning Officer',NULL,30,NULL,'Head'),(57,'Budget Officer',NULL,41,NULL,'Head'),(59,'Head - BAC Secretariat',NULL,25,NULL,'Head'),(60,'Assistant Director for Academic Affairs',NULL,36,NULL,'Head'),(62,'Registration Officer',NULL,27,NULL,'Head'),(68,'Campus Director',NULL,35,NULL,'Head'),(69,'Accountant',NULL,44,NULL,'Head');
/*!40000 ALTER TABLE `roles_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rsmi_items_specs_tbl`
--

DROP TABLE IF EXISTS `rsmi_items_specs_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rsmi_items_specs_tbl` (
  `rsmi_items_spec_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `rsmi_items_id_fk` bigint unsigned NOT NULL,
  `po_items_spec_id_fk` bigint unsigned DEFAULT NULL,
  `rsmi_spec_description` text,
  PRIMARY KEY (`rsmi_items_spec_id`),
  KEY `idx_rsmi_item_fk` (`rsmi_items_id_fk`),
  KEY `idx_rsmi_po_spec_fk` (`po_items_spec_id_fk`),
  CONSTRAINT `fk_rsmi_specs_item_ref` FOREIGN KEY (`rsmi_items_id_fk`) REFERENCES `rsmi_items_tbl` (`rsmi_items_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rsmi_specs_po_ref` FOREIGN KEY (`po_items_spec_id_fk`) REFERENCES `po_items_specs_tbl` (`po_items_spec_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rsmi_items_specs_tbl`
--

LOCK TABLES `rsmi_items_specs_tbl` WRITE;
/*!40000 ALTER TABLE `rsmi_items_specs_tbl` DISABLE KEYS */;
INSERT INTO `rsmi_items_specs_tbl` VALUES (11,11,94,'A4 Size, 70/80gs'),(12,12,95,'Long/Legal Size, 70/80gsm'),(13,13,95,'Long/Legal Size, 70/80gsm'),(14,14,95,'Long/Legal Size, 70/80gsm');
/*!40000 ALTER TABLE `rsmi_items_specs_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rsmi_items_tbl`
--

DROP TABLE IF EXISTS `rsmi_items_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rsmi_items_tbl` (
  `rsmi_items_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `rsmi_id_fk` bigint unsigned NOT NULL,
  `rsmi_ris_no` varchar(50) DEFAULT NULL,
  `rsmi_center_code` varchar(50) DEFAULT NULL,
  `rsmi_stock_no` varchar(50) DEFAULT NULL,
  `rsmi_items_descrip` varchar(255) DEFAULT NULL,
  `rsmi_unit` varchar(20) DEFAULT NULL,
  `rsmi_quantity` int DEFAULT NULL,
  `rsmi_unit_cost` decimal(10,2) DEFAULT NULL,
  `rsmi_amount` decimal(12,2) DEFAULT NULL,
  `recap_stock_no` varchar(50) DEFAULT NULL,
  `recap_quantity` int DEFAULT NULL,
  `recap_unit_cost` decimal(10,2) DEFAULT NULL,
  `recap_total_cost` decimal(12,2) DEFAULT NULL,
  `recap_uacs_code` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`rsmi_items_id`),
  KEY `idx_rsmi_header_fk` (`rsmi_id_fk`),
  CONSTRAINT `fk_rsmi_items_header_ref` FOREIGN KEY (`rsmi_id_fk`) REFERENCES `rsmi_tbl` (`rsmi_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rsmi_items_tbl`
--

LOCK TABLES `rsmi_items_tbl` WRITE;
/*!40000 ALTER TABLE `rsmi_items_tbl` DISABLE KEYS */;
INSERT INTO `rsmi_items_tbl` VALUES (11,4,NULL,NULL,NULL,'Bond Pape','ReamReam',1,242.00,242.00,NULL,NULL,NULL,NULL,NULL),(12,4,NULL,NULL,NULL,'Bond Paper','ReamReam',2,245.00,490.00,NULL,NULL,NULL,NULL,NULL),(13,4,NULL,NULL,NULL,'Bond Paper','ReamReam',1,245.00,245.00,NULL,NULL,NULL,NULL,NULL),(14,4,NULL,NULL,NULL,'Bond Paper','ReamReam',2,245.00,490.00,NULL,NULL,NULL,NULL,NULL),(15,5,NULL,NULL,'1','sample','piece',2,50000.00,100000.00,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `rsmi_items_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rsmi_tbl`
--

DROP TABLE IF EXISTS `rsmi_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rsmi_tbl` (
  `rsmi_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `po_id_fk` bigint unsigned DEFAULT NULL,
  `rsmi_fund_cluster` varchar(100) DEFAULT NULL,
  `rsmi_po_no` varchar(50) DEFAULT NULL,
  `rsmi_serial_no` varchar(50) DEFAULT NULL,
  `rsmi_date` date DEFAULT NULL,
  `rsmi_user_id_fk` bigint unsigned DEFAULT NULL,
  `rsmi_designation` varchar(100) DEFAULT NULL,
  `rsmi_posted_by` varchar(100) DEFAULT NULL,
  `rsmi_posted_date` date DEFAULT NULL,
  `rsmi_total` decimal(12,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rsmi_id`),
  KEY `idx_rsmi_po_fk` (`po_id_fk`),
  KEY `idx_rsmi_user_fk` (`rsmi_user_id_fk`),
  CONSTRAINT `fk_rsmi_po_ref` FOREIGN KEY (`po_id_fk`) REFERENCES `po_tbl` (`po_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_rsmi_user_ref` FOREIGN KEY (`rsmi_user_id_fk`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rsmi_tbl`
--

LOCK TABLES `rsmi_tbl` WRITE;
/*!40000 ALTER TABLE `rsmi_tbl` DISABLE KEYS */;
INSERT INTO `rsmi_tbl` VALUES (4,13,NULL,'14367',NULL,NULL,5,NULL,NULL,NULL,1467.00,'2026-06-12 03:30:04'),(5,15,NULL,'23123',NULL,NULL,82,NULL,NULL,NULL,100000.00,'2026-06-15 07:10:29');
/*!40000 ALTER TABLE `rsmi_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rspi_items_specs_tbl`
--

DROP TABLE IF EXISTS `rspi_items_specs_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rspi_items_specs_tbl` (
  `rspi_items_spec_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `rspi_items_id_fk` bigint unsigned NOT NULL,
  `po_items_spec_id_fk` bigint unsigned DEFAULT NULL,
  `rspi_spec_description` text,
  PRIMARY KEY (`rspi_items_spec_id`),
  KEY `idx_rspi_item_fk` (`rspi_items_id_fk`),
  KEY `idx_rspi_po_spec_fk` (`po_items_spec_id_fk`),
  CONSTRAINT `fk_rspi_specs_item_ref` FOREIGN KEY (`rspi_items_id_fk`) REFERENCES `rspi_items_tbl` (`rspi_items_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rspi_specs_po_ref` FOREIGN KEY (`po_items_spec_id_fk`) REFERENCES `po_items_specs_tbl` (`po_items_spec_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rspi_items_specs_tbl`
--

LOCK TABLES `rspi_items_specs_tbl` WRITE;
/*!40000 ALTER TABLE `rspi_items_specs_tbl` DISABLE KEYS */;
INSERT INTO `rspi_items_specs_tbl` VALUES (3,4,100,'matibay, kulay green, walang bubble gum sa ilalim'),(4,5,101,'square, sturdy'),(5,6,101,'square, sturdy');
/*!40000 ALTER TABLE `rspi_items_specs_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rspi_items_tbl`
--

DROP TABLE IF EXISTS `rspi_items_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rspi_items_tbl` (
  `rspi_items_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `rspi_id_fk` bigint unsigned NOT NULL,
  `rspi_ics_no` varchar(50) DEFAULT NULL,
  `rspi_center_code` varchar(50) DEFAULT NULL,
  `rspi_property_no` varchar(50) DEFAULT NULL,
  `rspi_items_descrip` varchar(255) DEFAULT NULL,
  `rspi_unit` varchar(20) DEFAULT NULL,
  `rspi_quantity` int DEFAULT NULL,
  `rspi_unit_cost` decimal(10,2) DEFAULT NULL,
  `rspi_amount` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`rspi_items_id`),
  KEY `idx_rspi_header_fk` (`rspi_id_fk`),
  CONSTRAINT `fk_rspi_items_header_ref` FOREIGN KEY (`rspi_id_fk`) REFERENCES `rspi_tbl` (`rspi_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rspi_items_tbl`
--

LOCK TABLES `rspi_items_tbl` WRITE;
/*!40000 ALTER TABLE `rspi_items_tbl` DISABLE KEYS */;
INSERT INTO `rspi_items_tbl` VALUES (4,2,NULL,NULL,'2','Arm char','piece',70,500.00,35000.00),(5,2,NULL,NULL,'2','Lamesa','piece',50,2000.00,100000.00),(6,2,NULL,NULL,'2','Lamesa','piece',50,2000.00,100000.00);
/*!40000 ALTER TABLE `rspi_items_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rspi_tbl`
--

DROP TABLE IF EXISTS `rspi_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rspi_tbl` (
  `rspi_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `po_id_fk` bigint unsigned DEFAULT NULL,
  `rspi_fund_cluster` varchar(100) DEFAULT NULL,
  `rspi_po_no` varchar(50) DEFAULT NULL,
  `rspi_serial_no` varchar(50) DEFAULT NULL,
  `rspi_date` date DEFAULT NULL,
  `rspi_user_id_fk` bigint unsigned DEFAULT NULL,
  `rspi_designation` varchar(100) DEFAULT NULL,
  `rspi_posted_by` varchar(100) DEFAULT NULL,
  `rspi_posted_date` date DEFAULT NULL,
  `rspi_total` decimal(12,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rspi_id`),
  KEY `idx_rspi_po_fk` (`po_id_fk`),
  KEY `idx_rspi_user_fk` (`rspi_user_id_fk`),
  CONSTRAINT `fk_rspi_po_ref` FOREIGN KEY (`po_id_fk`) REFERENCES `po_tbl` (`po_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_rspi_user_ref` FOREIGN KEY (`rspi_user_id_fk`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rspi_tbl`
--

LOCK TABLES `rspi_tbl` WRITE;
/*!40000 ALTER TABLE `rspi_tbl` DISABLE KEYS */;
INSERT INTO `rspi_tbl` VALUES (2,14,NULL,'0912301',NULL,NULL,82,NULL,NULL,NULL,235000.00,'2026-06-15 06:52:00');
/*!40000 ALTER TABLE `rspi_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('8Vsgye1aJOdWeoy8a4dPFSeEP80CKgKnlKKht9VV',82,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','YTo1OntzOjY6Il90b2tlbiI7czo0MDoiZnNNdnVGbk9IMURkTzcyUTFuQmZQWWFoNmxsMjBQUGk1WFhYa0l1eSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9ub3RpZmljYXRpb25zL3VucmVhZC1jb3VudCI7czo1OiJyb3V0ZSI7czoyNjoibm90aWZpY2F0aW9ucy51bnJlYWQuY291bnQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTo4MjtzOjE0OiJhY3RpdmVfcm9sZV9pZCI7aToxMDt9',1781577613),('ibLG1GIVBptUatdY8DOFdZ6INgb5a1oSAe1dUHwn',5,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','YTo2OntzOjY6Il90b2tlbiI7czo0MDoiQ1JVYk53RkEzNjV2eVhQeTZKWkxWRVJuMHJmR2NiWklETnVRVTFNdyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9ub3RpZmljYXRpb25zL3VucmVhZC1jb3VudCI7czo1OiJyb3V0ZSI7czoyNjoibm90aWZpY2F0aW9ucy51bnJlYWQuY291bnQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTo1O3M6MTQ6ImFjdGl2ZV9yb2xlX2lkIjtpOjExO3M6MTY6ImFjdGl2ZV9hcHBfaWRfMTYiO2k6MzA7fQ==',1781577193);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_items_tbl`
--

DROP TABLE IF EXISTS `task_items_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_items_tbl` (
  `task_item_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `task_id_fk` bigint unsigned NOT NULL,
  `app_item_id_fk` bigint unsigned NOT NULL,
  PRIMARY KEY (`task_item_id`),
  KEY `fk_task_items_task` (`task_id_fk`),
  KEY `fk_task_items_app_item` (`app_item_id_fk`),
  CONSTRAINT `fk_task_items_app_item` FOREIGN KEY (`app_item_id_fk`) REFERENCES `app_items_tbl` (`app_item_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_task_items_task` FOREIGN KEY (`task_id_fk`) REFERENCES `tasks_tbl` (`task_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_items_tbl`
--

LOCK TABLES `task_items_tbl` WRITE;
/*!40000 ALTER TABLE `task_items_tbl` DISABLE KEYS */;
INSERT INTO `task_items_tbl` VALUES (33,34,38),(34,34,39),(35,34,40),(36,34,41),(37,34,42),(38,35,43),(40,37,45),(41,38,46),(42,39,47),(43,40,48),(44,41,52),(45,41,53);
/*!40000 ALTER TABLE `task_items_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks_tbl`
--

DROP TABLE IF EXISTS `tasks_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks_tbl` (
  `task_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `assigned_by` bigint unsigned DEFAULT NULL,
  `assigned_to` bigint unsigned DEFAULT NULL,
  `task_description` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pr_id_fk` bigint unsigned DEFAULT NULL,
  `task_type` varchar(50) NOT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `task_status` enum('Pending','Complete','Exported') DEFAULT 'Pending',
  `read_at` timestamp NULL DEFAULT NULL,
  `task_dep_id_fk` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`task_id`),
  KEY `fk_tasks_submitted_by` (`assigned_by`),
  KEY `fk_tasks_submitted_to` (`assigned_to`),
  KEY `fk_tasks_pr` (`pr_id_fk`),
  CONSTRAINT `fk_tasks_pr` FOREIGN KEY (`pr_id_fk`) REFERENCES `pr_tbl` (`pr_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_tasks_submitted_by` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_tasks_submitted_to` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks_tbl`
--

LOCK TABLES `tasks_tbl` WRITE;
/*!40000 ALTER TABLE `tasks_tbl` DISABLE KEYS */;
INSERT INTO `tasks_tbl` VALUES (34,5,74,NULL,'2026-06-08 06:10:17',23,'Purchase Request',0,'Exported','2026-06-12 02:17:40',1),(35,2,74,NULL,'2026-06-12 08:09:42',24,'Purchase Request',0,'Complete','2026-06-12 02:17:40',1),(37,2,74,NULL,'2026-06-12 09:46:17',25,'Purchase Request',0,'Complete','2026-06-12 01:59:45',1),(38,2,74,NULL,'2026-06-12 10:28:14',NULL,'Purchase Request',0,'Pending','2026-06-12 02:28:22',1),(39,2,74,NULL,'2026-06-12 10:35:14',NULL,'Purchase Request',0,'Pending','2026-06-12 02:35:27',1),(40,5,NULL,NULL,'2026-06-13 06:17:04',NULL,'Purchase Request',0,'Pending','2026-06-12 22:17:42',16),(41,2,74,'Heherson Ramos has assigned you to create a Purchase Request for: chairs and tables, Appliances','2026-06-15 05:54:22',26,'Purchase Request',0,'Exported','2026-06-14 21:56:34',1),(42,74,2,'Ryunosuke Akutagawa has submitted a Purchase Request.','2026-06-14 22:09:05',26,'PR Submitted',0,'Pending',NULL,1),(43,74,2,'Heherson Ramos has submitted a Purchase Request.','2026-06-14 22:09:51',26,'PR Submitted',0,'Pending',NULL,1),(44,5,74,'John Rex Duran has submitted a Purchase Order for PR #PR-1-202605-001.','2026-06-14 22:42:38',26,'PO Submitted',0,'Pending',NULL,1),(45,5,74,'John Rex Duran has submitted a Purchase Order for PR #PR-1-202605-001.','2026-06-14 23:09:11',26,'PO Submitted',0,'Pending',NULL,1),(46,5,74,'John Rex Duran has submitted a Purchase Order for PR #PR-1-202605-001.','2026-06-15 18:03:05',26,'PO Submitted',0,'Pending',NULL,1);
/*!40000 ALTER TABLE `tasks_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `user_assignments`
--

DROP TABLE IF EXISTS `user_assignments`;
/*!50001 DROP VIEW IF EXISTS `user_assignments`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `user_assignments` AS SELECT 
 1 AS `Mapping ID`,
 1 AS `User PK`,
 1 AS `User Full Name`,
 1 AS `User Email`,
 1 AS `User Type`,
 1 AS `Dept PK`,
 1 AS `Department Name`,
 1 AS `Role PK`,
 1 AS `Role Name`,
 1 AS `General Role`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `user_departments_tbl`
--

DROP TABLE IF EXISTS `user_departments_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_departments_tbl` (
  `user_department_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id_fk` bigint unsigned NOT NULL,
  `department_id_fk` bigint NOT NULL,
  `role_id_fk` bigint DEFAULT NULL,
  PRIMARY KEY (`user_department_id`),
  KEY `user_id_fk` (`user_id_fk`),
  KEY `department_id_fk` (`department_id_fk`),
  KEY `fk_user_departments_role` (`role_id_fk`),
  CONSTRAINT `fk_user_departments_department` FOREIGN KEY (`department_id_fk`) REFERENCES `departments_tbl` (`dep_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_departments_role` FOREIGN KEY (`role_id_fk`) REFERENCES `roles_tbl` (`role_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_user_departments_user` FOREIGN KEY (`user_id_fk`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_departments_tbl`
--

LOCK TABLES `user_departments_tbl` WRITE;
/*!40000 ALTER TABLE `user_departments_tbl` DISABLE KEYS */;
INSERT INTO `user_departments_tbl` VALUES (2,74,1,NULL),(6,78,16,NULL),(7,19,14,NULL),(13,79,15,NULL),(14,2,1,1),(15,59,2,NULL),(21,22,5,22),(22,5,15,NULL),(23,5,16,11),(24,82,15,10);
/*!40000 ALTER TABLE `user_departments_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles_tbl`
--

DROP TABLE IF EXISTS `user_roles_tbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles_tbl` (
  `user_role_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id_fk` bigint unsigned NOT NULL,
  `role_id_fk` bigint DEFAULT NULL,
  PRIMARY KEY (`user_role_id`),
  KEY `user_id_fk` (`user_id_fk`),
  KEY `role_id_fk` (`role_id_fk`),
  CONSTRAINT `user_roles_tbl_ibfk_1` FOREIGN KEY (`user_id_fk`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_roles_tbl_ibfk_2` FOREIGN KEY (`role_id_fk`) REFERENCES `roles_tbl` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles_tbl`
--

LOCK TABLES `user_roles_tbl` WRITE;
/*!40000 ALTER TABLE `user_roles_tbl` DISABLE KEYS */;
INSERT INTO `user_roles_tbl` VALUES (1,2,1),(4,59,5),(6,77,6),(7,5,11),(12,22,22),(13,77,60),(14,74,53),(15,19,9),(16,22,23),(17,79,53),(18,79,11),(19,79,10);
/*!40000 ALTER TABLE `user_roles_tbl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_firstname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `user_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_middlename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_lastname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_suffix` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_fullname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci GENERATED ALWAYS AS (concat(_utf8mb4'user_firstname',_utf8mb4' ',_utf8mb4'user_middlename',_utf8mb4' ',_utf8mb4'user_lastname',_utf8mb4' ',_utf8mb4'user_suffix',_utf8mb4' ')) VIRTUAL,
  `user_type` enum('Faculty','Staff') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_tupid` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_contactno` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_profile_photo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `users_email_unique` (`user_email`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`user_id`, `user_firstname`, `user_email`, `email_verified_at`, `user_password`, `remember_token`, `created_at`, `updated_at`, `user_middlename`, `user_lastname`, `user_suffix`, `user_type`, `user_tupid`, `user_contactno`, `user_profile_photo`) VALUES (1,'Jayyy','jay@example.com',NULL,'$2y$12$gfqnw/WR71DZfUyzMOJGR.rm4Zn.oMdQgotZhgWZlTOWuPH1fqiHu',NULL,'2026-01-22 18:43:31','2026-01-22 18:43:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'Heherson','heherson.ramos@tup.edu.ph',NULL,'$2y$12$g7dV5ss/lO6KdWXPf3epa.hev8lv4f3gwazPoLS8C8MJiw8Q.4ODa',NULL,NULL,'2026-06-14 23:03:25','Pagulayan','Ramos',NULL,NULL,NULL,NULL,'img/profiles/user_2_1781507005.jpg'),(5,'John Rex','johnrex.duran@tup.edu.ph','2026-02-12 22:07:39','$2y$12$g0LymKo6o0tOEW7TsRdqiO5L3qYqzUE3xqIBqG9C.QbH.o0FqyRAm',NULL,'2026-02-12 22:07:40','2026-06-12 22:07:55','Bautista','Duran',NULL,'Staff','230265',NULL,'img/profiles/user_5_1781330875.jpg'),(9,'Rexmelle',NULL,NULL,NULL,NULL,NULL,NULL,'F.','Decapia',NULL,NULL,NULL,NULL,NULL),(10,'Ruby',NULL,NULL,NULL,NULL,NULL,NULL,'T.','Villanueva',NULL,NULL,NULL,NULL,NULL),(11,'Glenn',NULL,NULL,NULL,NULL,NULL,NULL,'N.','Ortiz',NULL,NULL,NULL,NULL,NULL),(12,'Ivan Ray',NULL,NULL,NULL,NULL,NULL,NULL,'G.','Ancero',NULL,NULL,NULL,NULL,NULL),(13,'Krystel May',NULL,NULL,NULL,NULL,NULL,NULL,'R.','Alvarado',NULL,NULL,NULL,NULL,NULL),(14,'Christian',NULL,NULL,NULL,NULL,NULL,NULL,'C.','Calingasan',NULL,NULL,NULL,NULL,NULL),(15,'Corazon',NULL,NULL,NULL,NULL,NULL,NULL,'C.','Dela Rosa',NULL,NULL,NULL,NULL,NULL),(16,'Hector',NULL,NULL,NULL,NULL,NULL,NULL,'M.','Tibo',NULL,NULL,NULL,NULL,NULL),(17,'Lieda',NULL,NULL,NULL,NULL,NULL,NULL,'A.','Sobida',NULL,NULL,NULL,NULL,NULL),(18,'Jane',NULL,NULL,NULL,NULL,NULL,NULL,'E.','Morgado',NULL,NULL,NULL,NULL,NULL),(19,'Ramil Leonardo',NULL,NULL,NULL,NULL,NULL,NULL,'H.','Africa',NULL,NULL,NULL,NULL,NULL),(20,'Maureen',NULL,NULL,NULL,NULL,NULL,NULL,'A.','Salve',NULL,NULL,NULL,NULL,NULL),(21,'Cindy',NULL,NULL,NULL,NULL,NULL,NULL,'Q.','Maldecir',NULL,NULL,NULL,NULL,NULL),(22,'Mitchie',NULL,NULL,NULL,NULL,NULL,NULL,'M.','Caurel',NULL,NULL,NULL,NULL,NULL),(23,'Christopher Mitchel',NULL,NULL,NULL,NULL,NULL,NULL,'I.','Azuelo',NULL,NULL,NULL,NULL,NULL),(24,'Mary Rose Gabrielle',NULL,NULL,NULL,NULL,NULL,NULL,'F.','Habla',NULL,NULL,NULL,NULL,NULL),(25,'Menerva',NULL,NULL,NULL,NULL,NULL,NULL,'Pesito','Doctor',NULL,NULL,NULL,NULL,NULL),(26,'Grace',NULL,NULL,NULL,NULL,NULL,NULL,'D.','Usana',NULL,NULL,NULL,NULL,NULL),(27,'Jenneth',NULL,NULL,NULL,NULL,NULL,NULL,'L.','Yu',NULL,NULL,NULL,NULL,NULL),(28,'Roselle',NULL,NULL,NULL,NULL,NULL,NULL,'L.','Honorio',NULL,NULL,NULL,NULL,NULL),(29,'Neizzel Joy',NULL,NULL,NULL,NULL,NULL,NULL,'T.','Labro-Azuelo',NULL,NULL,NULL,NULL,NULL),(30,'Ma. Clowee Anne',NULL,NULL,NULL,NULL,NULL,NULL,'M.','Sarmiento',NULL,NULL,NULL,NULL,NULL),(31,'Vivian',NULL,NULL,NULL,NULL,NULL,NULL,'T.','Pangan',NULL,NULL,NULL,NULL,NULL),(32,'Normita',NULL,NULL,NULL,NULL,NULL,NULL,'M.','Mata',NULL,NULL,NULL,NULL,NULL),(33,'Maria Carina',NULL,NULL,NULL,NULL,NULL,NULL,'V.','Silvino',NULL,NULL,NULL,NULL,NULL),(34,'Jim',NULL,NULL,NULL,NULL,NULL,NULL,'A.','Linda',NULL,NULL,NULL,NULL,NULL),(36,'Lizette',NULL,NULL,NULL,NULL,NULL,NULL,'P.','Terania',NULL,NULL,NULL,NULL,NULL),(37,'Roy',NULL,NULL,NULL,NULL,NULL,NULL,'J.','Garbin',NULL,NULL,NULL,NULL,NULL),(38,'Leilani',NULL,NULL,NULL,NULL,NULL,NULL,'G.','Oledan',NULL,NULL,NULL,NULL,NULL),(39,'Anna Marie',NULL,NULL,NULL,NULL,NULL,NULL,'A.','Dalaguit',NULL,NULL,NULL,NULL,NULL),(40,'Rogelio',NULL,NULL,NULL,NULL,NULL,NULL,'C.','Mercurio',NULL,NULL,NULL,NULL,NULL),(42,'Norway',NULL,NULL,NULL,NULL,NULL,NULL,'J.','Pangan',NULL,NULL,NULL,NULL,NULL),(43,'Raymund',NULL,NULL,NULL,NULL,NULL,NULL,'M.','Lozada',NULL,NULL,NULL,NULL,NULL),(44,'June Raymond',NULL,NULL,NULL,NULL,NULL,NULL,'L.','Mariano',NULL,NULL,NULL,NULL,NULL),(45,'Ma. Lizette',NULL,NULL,NULL,NULL,NULL,NULL,'G.','Peña',NULL,NULL,NULL,NULL,NULL),(46,'Juliet',NULL,NULL,NULL,NULL,NULL,NULL,'T.','Narez',NULL,NULL,NULL,NULL,NULL),(47,'Ronnie',NULL,NULL,NULL,NULL,NULL,NULL,'A.','Ramos',NULL,NULL,NULL,NULL,NULL),(48,'Flordeliza',NULL,NULL,NULL,NULL,NULL,NULL,'Y.','Valdez',NULL,NULL,NULL,NULL,NULL),(49,'Enrique',NULL,NULL,NULL,NULL,NULL,NULL,'A.','Silvino',NULL,NULL,NULL,NULL,NULL),(50,'Roilene',NULL,NULL,NULL,NULL,NULL,NULL,'C.','Pagatpat',NULL,NULL,NULL,NULL,NULL),(51,'Janiel Mico',NULL,NULL,NULL,NULL,NULL,NULL,'D.','Panganiban',NULL,NULL,NULL,NULL,NULL),(52,'Sanjie Dutt',NULL,NULL,NULL,NULL,NULL,NULL,'A.','Kumar',NULL,NULL,NULL,NULL,NULL),(54,'Cesar',NULL,NULL,NULL,NULL,NULL,NULL,'S.','Mendoza',NULL,NULL,NULL,NULL,NULL),(55,'Reginald',NULL,NULL,NULL,NULL,NULL,NULL,'B.','Cutanda',NULL,NULL,NULL,NULL,NULL),(56,'Clinton',NULL,NULL,NULL,NULL,NULL,NULL,'P.','Icuspit',NULL,NULL,NULL,NULL,NULL),(57,'Maria Gena',NULL,NULL,NULL,NULL,NULL,NULL,'C.','Cruz',NULL,NULL,NULL,NULL,NULL),(58,'Christopher',NULL,NULL,NULL,NULL,NULL,NULL,'B.','Parmis',NULL,NULL,NULL,NULL,NULL),(59,'Maricel',NULL,NULL,NULL,NULL,NULL,NULL,'S.','Ochoa',NULL,NULL,NULL,NULL,NULL),(60,'Marcelo',NULL,NULL,NULL,NULL,NULL,NULL,'V.','Rivera',NULL,NULL,NULL,NULL,NULL),(61,'Julius Delfin',NULL,NULL,NULL,NULL,NULL,NULL,'A.','Silang',NULL,NULL,NULL,NULL,NULL),(62,'Edwin',NULL,NULL,NULL,NULL,NULL,NULL,'P.','Roldan',NULL,NULL,NULL,NULL,NULL),(63,'Renante',NULL,NULL,NULL,NULL,NULL,NULL,'D.','Junto',NULL,NULL,NULL,NULL,NULL),(64,'Rica Jane',NULL,NULL,NULL,NULL,NULL,NULL,'Y.','Kosca',NULL,NULL,NULL,NULL,NULL),(65,'Triztan',NULL,NULL,NULL,NULL,NULL,NULL,'S.','Dela Cruz',NULL,NULL,NULL,NULL,NULL),(67,'Nemalyn',NULL,NULL,NULL,NULL,NULL,NULL,'P.','Decapia',NULL,NULL,NULL,NULL,NULL),(68,'Teodoro',NULL,NULL,NULL,NULL,NULL,NULL,'M.','Nimuan',NULL,NULL,NULL,NULL,NULL),(69,'Eugene',NULL,NULL,NULL,NULL,NULL,NULL,'C.','Singson',NULL,NULL,NULL,NULL,NULL),(70,'Jediah',NULL,NULL,NULL,NULL,NULL,NULL,'P.','Puertollano',NULL,NULL,NULL,NULL,NULL),(71,'Angelica',NULL,NULL,'$2y$12$NEMX5Dl0/mXWE.t8mxEMLOdsIxqWPXd6S1iqN34.n9h5AKhPymbYO',NULL,NULL,'2026-06-05 03:35:52','Feliziano','Olivar',NULL,NULL,'312341',NULL,NULL),(74,'Ryunosuke','aliah.wales@tup.edu.ph','2026-04-06 17:49:46','$2y$12$Oj7xU.Buat8.yvARYfqUTuzfRcImV7NKq1XPCgzYDJdVCzVjKOHqu',NULL,'2026-04-06 17:49:46','2026-04-23 23:26:49','Test','Akutagawa',NULL,'Faculty','101010',NULL,NULL),(78,'Kimberlie Crissel','kimberliecrissel.porteria@tup.edu.ph','2026-05-11 18:46:44','$2y$12$kLUyF55DHMRjy1zKsOvjP.CxCjVRIiqO2SMAXg2ACn/6DBVG22QCG',NULL,'2026-05-11 18:46:44','2026-05-11 18:46:44','Francisco','Porteria',NULL,'Staff','230214',NULL,NULL),(79,'Patrick Justin','patrickjustin_ariado@tup.edu.ph','2026-05-15 03:10:28','$2y$12$QwcxwrJs75YqzsD65XVz0ewlRMBvJWfeL3vnDwxyqXMCEe8Qo2bCG',NULL,'2026-05-15 03:10:28','2026-05-15 03:10:28','Laurente','Ariado',NULL,'Faculty','182020',NULL,NULL),(82,'John Brix','johnbrix.coronejo@tup.edu.ph','2026-06-11 21:58:01','$2y$12$v8rlx/jYAMnoKptvzYCjWusvoI5Tr4.//2p0F7/e7cTBU11I1iTkW',NULL,'2026-06-11 21:58:01','2026-06-11 21:58:01','Gonzales','Coronejo',NULL,'Faculty','TUPTP-23-0072',NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `view_user_roles_departments`
--

DROP TABLE IF EXISTS `view_user_roles_departments`;
/*!50001 DROP VIEW IF EXISTS `view_user_roles_departments`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_user_roles_departments` AS SELECT 
 1 AS `user_id`,
 1 AS `full_name`,
 1 AS `role_name`,
 1 AS `department`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `user_assignments`
--

/*!50001 DROP VIEW IF EXISTS `user_assignments`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_assignments` AS select `ud`.`user_department_id` AS `Mapping ID`,`u`.`user_id` AS `User PK`,concat(`u`.`user_firstname`,' ',`u`.`user_lastname`) AS `User Full Name`,`u`.`user_email` AS `User Email`,`u`.`user_type` AS `User Type`,`d`.`dep_id` AS `Dept PK`,`d`.`dep_name` AS `Department Name`,`r`.`role_id` AS `Role PK`,coalesce(`r`.`role_name`,'Unassigned (Faculty/Staff)') AS `Role Name`,coalesce(`r`.`gen_role`,'Unassigned') AS `General Role` from (((`user_departments_tbl` `ud` join `users` `u` on((`ud`.`user_id_fk` = `u`.`user_id`))) join `departments_tbl` `d` on((`ud`.`department_id_fk` = `d`.`dep_id`))) left join `roles_tbl` `r` on((`ud`.`role_id_fk` = `r`.`role_id`))) order by concat(`u`.`user_firstname`,' ',`u`.`user_lastname`),`d`.`dep_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_user_roles_departments`
--

/*!50001 DROP VIEW IF EXISTS `view_user_roles_departments`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_user_roles_departments` AS select `u`.`user_id` AS `user_id`,concat_ws(' ',`u`.`user_firstname`,`u`.`user_middlename`,`u`.`user_lastname`) AS `full_name`,`r`.`role_name` AS `role_name`,`d`.`dep_name` AS `department` from ((((`users` `u` left join `user_roles_tbl` `ur` on((`u`.`user_id` = `ur`.`user_id_fk`))) left join `roles_tbl` `r` on((`ur`.`role_id_fk` = `r`.`role_id`))) left join `user_departments_tbl` `ud` on((`u`.`user_id` = `ud`.`user_id_fk`))) left join `departments_tbl` `d` on(((`d`.`dep_id` = `ud`.`department_id_fk`) or (`d`.`dep_id` = `r`.`role_dep_id_fk`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-16 10:40:40
