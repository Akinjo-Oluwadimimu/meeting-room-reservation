-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: localhost    Database: room_reserve_db
-- ------------------------------------------------------
-- Server version	8.0.17

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
-- Dumping data for table `approval_logs`
--

LOCK TABLES `approval_logs` WRITE;
/*!40000 ALTER TABLE `approval_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `approval_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,'Science Complex','SCI','North Campus',5,'2025-04-06 18:28:02'),(2,'Humanities Hall','HUM','Central Campus',8,'2025-04-06 18:28:02'),(3,'Library Annex','LIB','East Campus',3,'2025-04-06 18:28:02'),(4,'Engineering Center','ENG','North Campus',7,'2025-04-30 15:13:33');
/*!40000 ALTER TABLE `buildings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `department_members`
--

LOCK TABLES `department_members` WRITE;
/*!40000 ALTER TABLE `department_members` DISABLE KEYS */;
INSERT INTO `department_members` VALUES (1,9,0,'2025-04-20 12:43:27'),(1,21,1,'2025-04-22 09:00:06');
/*!40000 ALTER TABLE `department_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'Computer Science','CS','Department of Computer Science',21,'2025-04-06 18:27:34'),(2,'Mathematics','MATH','Department of Mathematics',NULL,'2025-04-06 18:27:34'),(3,'Engineering','ENG','School of Engineering',NULL,'2025-04-06 18:27:34'),(4,'Other','Other','Other',NULL,'2025-04-09 21:18:33'),(5,'Business Administration','BSA','Department of Business Administration',NULL,'2025-04-10 16:15:31'),(6,'Chemistry','CHEM','Department of Chemistry',NULL,'2025-04-13 19:00:47'),(7,'Biology','BIO','Department of Biology',NULL,'2025-04-13 19:05:27');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `email_templates`
--

LOCK TABLES `email_templates` WRITE;
/*!40000 ALTER TABLE `email_templates` DISABLE KEYS */;
INSERT INTO `email_templates` VALUES (1,'reservation_confirmation','Your Room Reservation Confirmation - #{reservation_id}','<p>Dear #{user_name},</p>\n <p>Your room reservation has been confirmed with the following details:</p>\n <ul>\n   <li><strong>Room:</strong> #{room_name}</li>\n   <li><strong>Date:</strong> #{reservation_date}</li>\n   <li><strong>Time:</strong> #{start_time} to #{end_time}</li>\n   <li><strong>Purpose:</strong> #{purpose}</li>\n </ul>\n <p>If you need to cancel or modify this reservation, please visit the system at #{system_url}.</p>\n <p>Best regards,<br>Room Reservation System</p>','2025-04-27 05:22:57','2025-04-27 05:22:57'),(2,'reservation_approval','Reservation Approved - #{reservation_id}','<p>Dear #{user_name},</p>\n <p>Your reservation request has been approved:</p>\n <ul>\n   <li><strong>Room:</strong> #{room_name}</li>\n   <li><strong>Date:</strong> #{reservation_date}</li>\n   <li><strong>Time:</strong> #{start_time} to #{end_time}</li>\n </ul>\n <p>You may now proceed with your meeting as scheduled.</p>\n <p>Best regards,<br>Room Reservation System</p>','2025-04-27 05:22:57','2025-04-27 05:22:57'),(3,'reservation_rejection','Reservation Not Approved - #{reservation_id}','<p>Dear #{user_name},</p>\n <p>We regret to inform you that your reservation request could not be approved:</p>\n <ul>\n   <li><strong>Room:</strong> #{room_name}</li>\n   <li><strong>Date:</strong> #{reservation_date}</li>\n   <li><strong>Time:</strong> #{start_time} to #{end_time}</li>\n   <li><strong>Reason:</strong> #{rejection_reason}</li>\n </ul>\n <p>Please contact #{admin_email} if you have any questions.</p>\n <p>Best regards,<br>Room Reservation System</p>','2025-04-27 05:22:57','2025-04-27 05:22:57'),(4,'reservation_reminder','Upcoming Reservation Reminder - #{reservation_id}','<p>Dear #{user_name},</p>\n <p>This is a reminder for your upcoming reservation:</p>\n <ul>\n   <li><strong>Room:</strong> #{room_name}</li>\n   <li><strong>Date:</strong> #{reservation_date}</li>\n   <li><strong>Time:</strong> #{start_time} to #{end_time}</li>\n   <li><strong>Starts in:</strong> #{hours_until} hours</li>\n </ul>\n <p>Please arrive on time for your meeting.</p>\n <p>Best regards,<br>Room Reservation System</p>','2025-04-27 05:22:57','2025-04-27 05:22:57');
/*!40000 ALTER TABLE `email_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `email_verification`
--

LOCK TABLES `email_verification` WRITE;
/*!40000 ALTER TABLE `email_verification` DISABLE KEYS */;
INSERT INTO `email_verification` VALUES (12,20,'soti-48lONunNgEXiDtJJ7jtvcZDNglw','2025-04-20 19:15:40','2025-04-21 19:15:41'),(13,21,'MtXze4LmJxMv6zaDDE3hgXnC9khw662t','2025-04-21 10:06:31','2025-04-22 10:06:31'),(14,23,'AWXrALZGEbacqSJi-nc4n2Gnay6TRoUt','2025-04-22 17:09:57','2025-04-23 17:09:58'),(17,26,'ou0C8L6fW2VqJ7i4Zs0ce0yJ_9hlhxHF','2025-04-28 14:15:19','2025-04-29 14:15:19'),(19,28,'ty79X6Lef-Vj98v6hJYxP561M746xEt-','2025-05-21 16:41:13','2025-05-22 16:41:13'),(22,31,'G-DvIkJ7utM9LEUMMOxdVr8T_MDA1Q_n','2025-05-23 19:55:45','2025-05-24 19:55:45');
/*!40000 ALTER TABLE `email_verification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `export_history`
--

LOCK TABLES `export_history` WRITE;
/*!40000 ALTER TABLE `export_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `export_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `login_logs`
--

LOCK TABLES `login_logs` WRITE;
/*!40000 ALTER TABLE `login_logs` DISABLE KEYS */;
INSERT INTO `login_logs` VALUES (1475,23,'LuoZhen','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0','2025-05-30 13:22:10','SUCCESS',NULL),(1476,10,'ovansa','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0','2025-05-30 13:23:21','SUCCESS',NULL),(1477,10,'ovansa','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0','2025-05-30 13:23:41','SUCCESS',NULL),(1478,41,'newuser','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0','2025-05-30 13:25:18','SUCCESS',NULL),(1479,20,'Ash','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0','2025-05-30 13:29:07','SUCCESS',NULL);
/*!40000 ALTER TABLE `login_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,9,'Reservation 12 Rejected','Your reservation for Lecture Hall B on April 30, 2025 has been rejected',0,'2025-05-01 10:52:04'),(2,9,'Reservation 14 Rejected','Your reservation for Biology Lab on April 30, 2025 has been rejected',0,'2025-05-01 11:02:35'),(3,9,'Reservation 10 Rejected','Your reservation for Seminar Room 2 on April 30, 2025 has been rejected',1,'2025-05-01 11:08:03'),(4,9,'Reservation 11 Approved','Your reservation for Lecture Hall B on April 30, 2025 has been approved',0,'2025-05-01 11:08:30'),(5,9,'Reservation 9 Approved','Your reservation for Seminar Room 2 on May 01, 2025 has been approved',1,'2025-05-03 13:59:55'),(6,9,'Reservation 11 Rejected','Your reservation for Lecture Hall B on April 30, 2025 has been rejected',0,'2025-05-03 14:22:43'),(7,9,'Reservation 16 Approved','Your reservation for Lecture Hall B on May 13, 2025 has been approved',1,'2025-05-03 19:58:38'),(8,9,'Reservation 16 Rejected','Your reservation for Lecture Hall B on May 13, 2025 has been rejected',0,'2025-05-03 20:03:58'),(9,9,'Reservation 15 Approved','Your reservation for Davidson Hall on May 16, 2025 has been approved',0,'2025-05-03 20:10:49'),(10,9,'Reservation 15 Rejected','Your reservation for Davidson Hall on May 16, 2025 has been rejected',0,'2025-05-03 20:22:09'),(11,9,'Reservation 12 Rejected','Your reservation for Lecture Hall B on June 30, 2025 has been rejected',1,'2025-05-05 11:04:42'),(12,9,'Reservation 13 Approved','Your reservation for Seminar Room 2 on May 06, 2025 has been approved',0,'2025-05-05 11:07:39'),(13,9,'Reservation 13 Rejected','Your reservation for Seminar Room 2 on May 06, 2025 has been rejected',0,'2025-05-05 11:50:26'),(14,9,'Reservation 17 Rejected','Your reservation for Lecture Hall B on May 12, 2025 has been rejected',0,'2025-05-06 12:31:11'),(15,9,'Reservation 18 Approved','Your reservation for Lecture Hall B on May 12, 2025 has been approved',1,'2025-05-06 14:04:14'),(16,9,'Reservation 20 Rejected','Your reservation for Seminar Room 2 on May 13, 2025 has been rejected',1,'2025-05-06 15:34:48'),(17,21,'Reservation 21 Rejected','Your reservation for Seminar Room 2 on May 20, 2025 has been rejected',0,'2025-05-06 15:48:04'),(18,21,'Reservation 22 Rejected','Your reservation for Executive Conference Room on May 08, 2025 has been rejected',0,'2025-05-06 15:51:46'),(19,9,'Reservation 23 Approved','Your reservation for Chemistry Lab on May 08, 2025 has been approved',0,'2025-05-08 01:02:08'),(21,9,'Reservation 27 Approved','Your reservation for Conference Room A on May 12, 2025 has been approved',1,'2025-05-11 23:15:20'),(23,9,'Reservation 28 Approved','Your reservation for Chemistry Lab on May 12, 2025 has been approved',0,'2025-05-12 14:53:05'),(24,9,'Reservation 29 Approved','Your reservation for Conference Room A on May 16, 2025 has been approved',0,'2025-05-16 13:33:27'),(25,9,'Reservation 29 Rejected','Your reservation for Conference Room A on May 16, 2025 has been rejected',1,'2025-05-16 13:34:34'),(26,9,'Reservation 30 Approved','Your reservation for Chemistry Lab on May 19, 2025 has been approved',0,'2025-05-17 06:22:57'),(27,9,'Reservation 31 Approved','Your reservation for Seminar Room 1 on May 19, 2025 has been approved',0,'2025-05-17 06:23:02'),(28,9,'Reservation 35 Approved','Your reservation for Conference Room A on May 19, 2025 has been approved',0,'2025-05-17 22:25:18'),(29,9,'Reservation 32 Approved','Your reservation for Seminar Room 2 on May 20, 2025 has been approved',0,'2025-05-17 22:25:24'),(30,9,'Reservation 36 Approved','Your reservation for Davidson Hall on May 21, 2025 has been approved',0,'2025-05-21 07:53:16'),(31,9,'Reservation 37 Approved','Your reservation for Seminar Room 2 on May 21, 2025 has been approved',0,'2025-05-21 11:37:59'),(32,9,'Reservation 38 Approved','Your reservation for Biology Lab on May 21, 2025 has been approved',0,'2025-05-21 11:58:37'),(33,9,'Reservation 34 Rejected','Your reservation for Davidson Hall on May 20, 2025 has been rejected',0,'2025-05-21 12:00:29'),(34,9,'Reservation 33 Approved','Your reservation for Seminar Room 2 on May 23, 2025 has been approved',0,'2025-05-21 12:14:52'),(35,9,'Reservation 39 Approved','Your reservation for Lulu on May 28, 2025 has been approved',0,'2025-05-21 12:25:17'),(36,9,'Reservation 47 Approved','Your reservation for Chemistry Lab on May 29, 2025 has been approved',0,'2025-05-22 22:29:33'),(37,9,'Reservation 41 Approved','Your reservation for Davidson Hall on May 22, 2025 has been approved',0,'2025-05-22 22:33:27'),(38,9,'Reservation 48 Approved','Your reservation for Conference Room A on May 28, 2025 has been approved',0,'2025-05-22 22:33:53'),(39,9,'Reservation 46 Rejected','Your reservation for Chemistry Lab on May 26, 2025 has been rejected',0,'2025-05-22 22:34:26'),(40,9,'Reservation 47 Rejected','Your reservation for Chemistry Lab on May 29, 2025 has been rejected',0,'2025-05-22 22:44:23'),(41,9,'Reservation 59 Approved','Your reservation for Biology Lab on May 28, 2025 has been approved',0,'2025-05-27 09:57:16'),(42,41,'Reservation 65 Approved','Your reservation for Conference Room A on May 30, 2025 has been approved',1,'2025-05-29 10:10:56'),(43,41,'Reservation 65 Rejected','Your reservation for Conference Room A on May 30, 2025 has been rejected',0,'2025-05-29 10:56:02'),(44,41,'Reservation 67 Approved','Your reservation for Lecture Hall B on May 30, 2025 has been approved',0,'2025-05-29 12:47:37'),(45,9,'Reservation 48 Rejected','Your reservation for Conference Room A on May 29, 2025 has been rejected',0,'2025-05-29 19:50:58');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `report_definitions`
--

LOCK TABLES `report_definitions` WRITE;
/*!40000 ALTER TABLE `report_definitions` DISABLE KEYS */;
INSERT INTO `report_definitions` VALUES (1,'Room Utilization','Shows room usage statistics','SELECT r.name, COUNT(res.reservation_id) as bookings, \n   SUM(TIMESTAMPDIFF(HOUR, res.start_time, res.end_time)) as hours_used\n  FROM rooms r LEFT JOIN reservations res ON r.room_id = res.room_id\n  WHERE res.start_time BETWEEN :start_date AND :end_date\n  GROUP BY r.name','{\"end_date\": \"date\", \"start_date\": \"date\"}','2025-05-26 13:11:42','2025-05-26 16:09:55'),(2,'User Booking Activity','Shows booking activity by user','SELECT u.username, COUNT(r.reservation_id) as bookings,\n   SUM(TIMESTAMPDIFF(HOUR, r.start_time, r.end_time)) as hours_booked\n  FROM users u LEFT JOIN reservations r ON u.user_id = r.user_id\n  WHERE r.start_time BETWEEN :start_date AND :end_date\n  GROUP BY u.username','{\"end_date\": \"date\", \"start_date\": \"date\"}','2025-05-26 13:11:42','2025-05-26 13:11:42'),(3,'Cancellation Analysis','Analyzes cancellation reasons','SELECT status, COUNT(*) as count, \n   GROUP_CONCAT(DISTINCT cancellation_reason) as reasons\n  FROM reservations\n  WHERE start_time BETWEEN :start_date AND :end_date\n  AND status = \'cancelled\'\n  GROUP BY status','{\"end_date\": \"date\", \"start_date\": \"date\"}','2025-05-26 13:11:42','2025-05-26 13:11:42');
/*!40000 ALTER TABLE `report_definitions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `reservation_approvals`
--

LOCK TABLES `reservation_approvals` WRITE;
/*!40000 ALTER TABLE `reservation_approvals` DISABLE KEYS */;
/*!40000 ALTER TABLE `reservation_approvals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `reservation_audit`
--

LOCK TABLES `reservation_audit` WRITE;
/*!40000 ALTER TABLE `reservation_audit` DISABLE KEYS */;
INSERT INTO `reservation_audit` VALUES (4,12,20,'pending','rejected','','2025-05-01 10:52:04'),(5,14,20,'pending','rejected','','2025-05-01 11:02:35'),(6,10,20,'pending','rejected','','2025-05-01 11:08:03'),(7,11,20,'pending','approved','','2025-05-01 11:08:30'),(8,9,20,'pending','approved','yjttg','2025-05-03 13:59:55'),(9,11,20,'approved','rejected','tgfds','2025-05-03 14:22:43'),(10,16,20,'pending','approved','fhnfmu j,d','2025-05-03 19:58:38'),(11,16,20,'approved','rejected','fsgdh gfhr s','2025-05-03 20:03:58'),(12,15,20,'pending','approved','','2025-05-03 20:10:49'),(13,15,20,'approved','rejected','fdghfgj fhrv egttu','2025-05-03 20:22:09'),(14,12,20,'approved','rejected','hg rhn fd','2025-05-05 11:04:42'),(15,13,20,'pending','approved','vh jbgyu','2025-05-05 11:07:39'),(16,13,20,'approved','rejected','dxtfygu uon','2025-05-05 11:50:26'),(17,17,20,'pending','rejected','fgfgsh jed dfgs','2025-05-06 12:31:07'),(18,18,20,'pending','approved','been really busy','2025-05-06 14:04:14'),(19,20,20,'pending','rejected','hdh hdsgg','2025-05-06 15:34:48'),(20,21,20,'pending','rejected','dfy ugv','2025-05-06 15:48:04'),(21,22,20,'pending','rejected','Room under maintenance','2025-05-06 15:51:46'),(22,23,20,'pending','approved','b ui yju','2025-05-08 01:02:08'),(24,27,20,'pending','approved','','2025-05-11 23:15:20'),(26,28,20,'pending','approved','','2025-05-12 14:53:05'),(27,29,23,'pending','approved','','2025-05-16 13:33:27'),(28,29,20,'approved','rejected','tuyrmn fn','2025-05-16 13:34:34'),(29,30,20,'pending','approved','','2025-05-17 06:22:57'),(30,31,20,'pending','approved','','2025-05-17 06:23:02'),(31,35,20,'pending','approved','','2025-05-17 22:25:18'),(32,32,20,'pending','approved','','2025-05-17 22:25:24'),(33,36,23,'pending','approved','','2025-05-21 07:53:16'),(34,37,23,'pending','approved','','2025-05-21 11:37:59'),(35,38,23,'pending','approved','','2025-05-21 11:58:37'),(36,34,23,'pending','rejected','past reservation time','2025-05-21 12:00:29'),(37,33,20,'pending','approved','','2025-05-21 12:14:52'),(38,39,20,'pending','approved','','2025-05-21 12:25:17'),(39,47,20,'pending','approved','','2025-05-22 22:29:33'),(40,41,20,'pending','approved','','2025-05-22 22:33:27'),(41,48,20,'pending','approved','','2025-05-22 22:33:53'),(42,46,20,'pending','rejected','Room under maintenance','2025-05-22 22:34:26'),(43,47,20,'approved','rejected','Facility broken','2025-05-22 22:44:23'),(44,59,23,'pending','approved','','2025-05-27 09:57:16'),(45,65,23,'pending','approved','Kindly ensure to check in on the portal 15 minutes before the start time.','2025-05-29 10:10:56'),(46,65,23,'approved','rejected','Room is currently under maintenance','2025-05-29 10:56:02'),(47,67,23,'pending','approved','','2025-05-29 12:47:37'),(48,48,23,'no-show','completed','Attended late','2025-05-29 19:50:58');
/*!40000 ALTER TABLE `reservation_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
INSERT INTO `reservations` VALUES (8,6,9,'shm','2025-03-30 20:11:00','2025-03-30 21:11:00','fgnm bgb d',11,'completed',NULL,NULL,NULL,'2025-04-29 18:11:28','2025-05-08 14:57:39',NULL,NULL,0,NULL),(9,6,9,'Lorem ipsum dolor sit amet','2025-05-01 10:00:00','2025-05-01 12:00:00','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eu sem ac odio mollis efficitur ut a dui. Duis non odio dolor. Morbi ac orci id diam vestibulum consectetur. Mauris efficitur nibh at sapien fermentum, id accumsan augue facilisis. Curabitur congue interdum nisl, nec maximus velit cursus at.',22,'completed',NULL,NULL,NULL,'2025-04-29 21:13:10','2025-05-07 13:10:00',NULL,NULL,0,NULL),(10,6,9,'dfsv','2025-04-30 08:00:00','2025-04-30 12:00:00','daf',12,'rejected',NULL,NULL,NULL,'2025-04-29 21:14:14','2025-05-01 11:08:03',NULL,NULL,0,NULL),(11,2,9,'xzc','2025-04-30 20:00:00','2025-04-30 22:00:00','zcv',2,'completed',NULL,NULL,NULL,'2025-04-30 07:57:11','2025-05-07 13:10:00',NULL,NULL,0,NULL),(12,2,9,'dfdgb','2025-06-30 06:00:00','2025-06-30 11:00:00','czv',3,'rejected','hg rhn fd',NULL,NULL,'2025-04-30 08:24:04','2025-05-05 11:04:42',NULL,NULL,0,NULL),(13,6,9,'yrd','2025-05-06 09:00:00','2025-05-06 10:00:00','',2,'rejected','dxtfygu uon','No longer needed','fydrutiyolj;','2025-04-30 15:25:09','2025-05-08 12:17:34',NULL,'2025-05-05 12:50:26',0,NULL),(14,4,9,'cg','2025-04-30 18:00:00','2025-04-30 19:00:00','bj',2,'rejected',NULL,NULL,NULL,'2025-04-30 16:40:34','2025-05-01 11:02:35',NULL,NULL,0,NULL),(15,7,9,'Group Revision Meeting','2025-05-16 12:00:00','2025-05-16 14:00:00','Phasellus volutpat odio non leo rutrum accumsan et eget tellus. In quam felis, convallis ac risus quis, congue tempor augue. Curabitur interdum lacus enim, sed varius urna ullamcorper posuere. Nullam lorem massa, condimentum sit amet mollis et, luctus vitae lectus. Fusce euismod ante vel convallis mollis. Donec quam tellus, tempor non eros malesuada, luctus scelerisque dui. Etiam ullamcorper tincidunt tortor, vitae cursus sem pellentesque ac.',4,'rejected','15',NULL,NULL,'2025-05-01 09:23:11','2025-05-03 20:22:09',NULL,NULL,0,NULL),(16,2,9,'Donec tellus diam','2025-05-13 07:00:00','2025-05-13 09:00:00','Donec tellus diam, ornare non facilisis id, euismod ut ipsum. Praesent vitae tellus ante. Ut ante tortor, convallis a tortor et, placerat egestas purus. Sed ultrices nisi eget lacus auctor vestibulum. Suspendisse dapibus sollicitudin augue quis pellentesque. Donec in interdum tortor, ut imperdiet eros. Cras et velit sed risus ultricies sagittis. Aenean sodales venenatis quam non vehicula.',16,'rejected','16',NULL,NULL,'2025-05-03 19:58:06','2025-05-03 20:03:58',NULL,NULL,0,NULL),(17,2,9,'Team Meeting','2025-05-12 08:00:00','2025-05-12 10:00:00','hgf',3,'rejected','fgfgsh jed dfgs',NULL,NULL,'2025-05-04 16:32:52','2025-05-06 12:30:59',NULL,NULL,0,NULL),(18,2,9,'Team Meeting','2025-05-12 10:00:00','2025-05-12 12:00:00','',3,'completed',NULL,NULL,NULL,'2025-05-04 16:42:17','2025-05-12 09:35:43','2025-05-12 10:35:43',NULL,0,NULL),(19,2,9,'Didi\'s Meeting','2025-05-02 08:00:00','2025-05-02 10:00:00','hj dnfui ernjkdgtrb fje rjf  rngj gbif oorgjg giutg jgrgrg bgir.  tgigtg guieg igbng tjb jgtru jtgro[w;gb ruig griekb',4,'cancelled',NULL,'No longer needed','dgj gdo oired rg dfo','2025-05-05 10:54:31','2025-05-08 12:26:39',NULL,'2025-05-08 13:25:19',0,NULL),(20,6,9,'cyyk ylnho','2025-05-13 10:00:00','2025-05-13 12:00:00','ytruiyoupi 98oihn; ohion',6,'rejected','hdh hdsgg',NULL,NULL,'2025-05-06 15:31:16','2025-05-06 15:34:48',NULL,NULL,0,NULL),(21,6,21,'Class Discussion','2025-05-20 12:00:00','2025-05-20 14:00:00','dnib ddnhfjrs rhnosfgh rdohhe hnbidohnh ni.kjfhnit dihhd oth.hjkhndhhdont',9,'rejected','dfy ugv',NULL,NULL,'2025-05-06 15:38:16','2025-05-06 15:48:04',NULL,NULL,0,NULL),(22,8,21,'Group Revision Meeting','2025-05-08 09:00:00','2025-05-08 12:00:00','  jk kjkj',5,'rejected','Room under maintenance',NULL,NULL,'2025-05-06 15:50:09','2025-05-06 15:51:46',NULL,NULL,0,NULL),(23,5,9,'dfghm','2025-05-08 02:05:00','2025-05-08 03:00:00','kljjn',3,'no-show',NULL,NULL,NULL,'2025-05-08 01:00:24','2025-05-08 01:38:27',NULL,NULL,0,NULL),(24,17,9,'Group Revision Meeting','2025-05-08 10:10:00','2025-05-08 10:20:00','fhghh ',5,'cancelled',NULL,'Change of plans','vghjo','2025-05-08 09:07:04','2025-05-08 12:23:27',NULL,'2025-05-08 10:07:25',0,NULL),(27,1,9,'Team Meeting','2025-05-12 12:00:00','2025-05-12 14:00:00','',10,'no-show',NULL,NULL,NULL,'2025-05-11 23:14:33','2025-05-12 13:30:00',NULL,NULL,0,NULL),(28,5,9,'Lab work','2025-05-12 11:00:00','2025-05-12 13:00:00','laboratory work which requires lab equipment for 4 students',5,'no-show',NULL,NULL,NULL,'2025-05-12 09:59:46','2025-05-12 21:28:00',NULL,NULL,0,NULL),(29,1,9,'Group Revision Meeting','2025-05-16 15:00:00','2025-05-16 17:00:00','',7,'rejected','tuyrmn fn',NULL,NULL,'2025-05-16 13:26:45','2025-05-16 13:34:34',NULL,NULL,0,NULL),(30,5,9,'Team Meeting','2025-05-17 08:00:00','2025-05-17 10:00:00','yiffjy 8ig8ou9 8y8h 7gutlui,v goiy9p 9y9ul9ouv tgtrd 7toyp;h 6rderv 7toyo',18,'completed',NULL,NULL,NULL,'2025-05-17 06:21:43','2025-05-17 06:46:05','2025-05-17 07:46:05',NULL,0,NULL),(31,3,9,'Group Revision Meeting','2025-05-17 11:00:00','2025-05-17 12:00:00','fiyugv itdj dtjfgkh \'pg yfrytuykf oii p9y fiyruot8; pypu 9[uhrs5 you;sxdtydf 97rofy ',7,'no-show',NULL,NULL,NULL,'2025-05-17 06:22:29','2025-05-17 11:50:27',NULL,NULL,0,NULL),(32,6,9,'Class Discussion','2025-05-20 13:00:00','2025-05-20 14:00:00','hjbfdc fhu wcbu vefwv wuu fvugww ',10,'completed',NULL,NULL,NULL,'2025-05-17 16:39:49','2025-05-20 12:01:29','2025-05-20 13:01:29',NULL,0,NULL),(33,6,9,'Team Meeting','2025-05-24 09:10:00','2025-05-24 10:30:00','fgy uyiyi y hv uyh uyi',12,'completed',NULL,NULL,NULL,'2025-05-17 16:40:29','2025-05-24 07:55:12','2025-05-24 08:55:12',NULL,1,'2025-05-23 08:02:28'),(34,7,9,'Team Revision Meeting','2025-05-20 08:00:00','2025-05-20 10:00:00','7g  uyibu un  uiouj f6ghb8',6,'rejected','past reservation time',NULL,NULL,'2025-05-17 16:41:16','2025-05-21 12:00:29',NULL,NULL,0,NULL),(35,1,9,'Team Meeting','2025-05-19 10:00:00','2025-05-19 12:00:00','5hre trge trbe tbe tbre',4,'completed',NULL,NULL,NULL,'2025-05-17 19:49:13','2025-05-19 09:27:53','2025-05-19 10:27:53',NULL,0,NULL),(36,7,9,'Meeting','2025-05-21 10:00:00','2025-05-21 12:00:00','ytfu uyyui i',2,'no-show',NULL,NULL,NULL,'2025-05-21 07:52:43','2025-05-21 11:30:00',NULL,NULL,0,NULL),(37,6,9,'bgbrt f d','2025-05-21 15:00:00','2025-05-21 16:00:00','',2,'no-show',NULL,NULL,NULL,'2025-05-21 11:37:34','2025-05-21 15:08:10',NULL,NULL,0,NULL),(38,4,9,'Defense Meeting','2025-05-21 13:00:00','2025-05-21 14:00:00','6ft7gyb 7tyib vutyinvy y uyin iuohgcr6t y8unby y8b',3,'completed',NULL,NULL,NULL,'2025-05-21 11:48:19','2025-05-21 12:24:15','2025-05-21 13:24:15',NULL,0,NULL),(39,17,9,'Research','2025-05-30 08:00:00','2025-05-30 10:00:00','jfgkvhlj. guovhkj',2,'no-show',NULL,NULL,NULL,'2025-05-21 12:24:59','2025-05-30 10:02:21',NULL,NULL,1,'2025-05-27 17:37:33'),(40,8,9,'jgdciv o','2025-05-20 12:00:00','2025-05-20 13:00:00','khuftygb ip',41,'cancelled',NULL,'Personal emergency','jhgjkhl','2025-05-21 17:08:25','2025-05-21 17:16:08',NULL,'2025-05-21 18:13:34',0,NULL),(41,7,9,'Group work','2025-05-22 15:00:00','2025-05-22 16:00:00','gh thr hytrsdvg fdsvd rgcq',8,'no-show',NULL,NULL,NULL,'2025-05-22 11:21:16','2025-05-22 23:00:00',NULL,NULL,0,NULL),(42,8,9,'Group Revision Meeting','2025-05-23 10:00:00','2025-05-23 12:00:00','jkhkmf bgarb  zfcs ',5,'pending',NULL,NULL,NULL,'2025-05-22 20:08:50','2025-05-22 20:08:50',NULL,NULL,0,NULL),(43,4,9,'Class Discussion','2025-05-26 09:00:00','2025-05-26 10:00:00','',4,'pending',NULL,NULL,NULL,'2025-05-22 20:16:41','2025-05-22 20:16:41',NULL,NULL,0,NULL),(44,3,9,'Class Discussion','2025-05-29 14:00:00','2025-05-29 16:00:00','',4,'cancelled',NULL,'Accidental booking','Mistake booking','2025-05-22 20:59:53','2025-05-22 21:46:03',NULL,'2025-05-22 22:46:03',0,NULL),(45,17,9,'Class Discussion','2025-05-23 15:00:00','2025-05-23 16:00:00','',10,'pending',NULL,NULL,NULL,'2025-05-22 21:04:34','2025-05-22 21:04:34',NULL,NULL,0,NULL),(46,5,9,'Class Discussion','2025-05-26 17:00:00','2025-05-26 19:00:00','',10,'rejected','Room under maintenance',NULL,NULL,'2025-05-22 21:43:41','2025-05-22 22:34:26',NULL,NULL,0,NULL),(47,5,9,'Group Revision Meeting','2025-05-29 14:00:00','2025-05-29 16:00:00','',2,'rejected','Facility broken',NULL,NULL,'2025-05-22 21:46:39','2025-05-22 22:44:23',NULL,NULL,0,NULL),(48,1,9,'Class Discussion','2025-05-29 10:00:00','2025-05-29 12:00:00','',6,'completed',NULL,NULL,NULL,'2025-05-22 21:49:33','2025-05-29 19:50:58',NULL,NULL,1,'2025-05-27 08:41:24'),(49,2,28,'Team Meeting','2025-05-26 10:00:00','2025-05-26 12:00:00','',15,'pending',NULL,NULL,NULL,'2025-05-22 22:06:03','2025-05-22 22:06:03',NULL,NULL,0,NULL),(55,17,9,'Class Discussion','2025-05-24 18:35:00','2025-05-24 20:35:00','yuitr uotiyc culfoj',8,'pending',NULL,NULL,NULL,'2025-05-24 12:23:06','2025-05-24 12:23:06',NULL,NULL,0,NULL),(56,2,9,'Team Meeting','2025-05-25 09:00:00','2025-05-25 12:00:00','hvg ifyiov g7ftx ukytb  jlj,',4,'pending',NULL,NULL,NULL,'2025-05-24 12:29:31','2025-05-24 12:29:31',NULL,NULL,0,NULL),(57,2,9,'Team Revision Meeting','2025-05-28 16:00:00','2025-05-28 17:00:00','',2,'no-show',NULL,NULL,NULL,'2025-05-24 14:40:17','2025-05-28 19:57:01',NULL,NULL,0,NULL),(58,2,9,'Team Revision Meeting','2025-05-27 09:00:00','2025-05-27 10:00:00','',2,'pending',NULL,NULL,NULL,'2025-05-24 14:47:01','2025-05-24 14:47:01',NULL,NULL,0,NULL),(59,4,9,'Discussion','2025-05-28 15:00:00','2025-05-28 15:30:00','whs',4,'no-show',NULL,NULL,NULL,'2025-05-27 09:56:03','2025-05-28 15:00:00',NULL,NULL,1,'2025-05-27 22:37:34'),(60,2,21,'Team Revision Meeting','2025-05-31 03:00:00','2025-05-31 04:00:00','tumrhd',4,'pending',NULL,NULL,NULL,'2025-05-27 10:46:27','2025-05-28 14:06:29',NULL,NULL,0,NULL),(61,1,21,'rte','2025-05-28 03:00:00','2025-05-28 04:00:00','hewnt',3,'pending',NULL,NULL,NULL,'2025-05-27 10:47:22','2025-05-28 14:06:29',NULL,NULL,0,NULL),(62,5,9,'sf a','2025-05-29 03:00:00','2025-05-29 04:00:00','rjm',3,'no-show',NULL,NULL,NULL,'2025-05-27 10:48:12','2025-05-29 06:34:34',NULL,NULL,0,NULL),(63,2,9,'jtrh','2025-05-30 04:00:00','2025-05-30 06:00:00','hegs',3,'cancelled',NULL,'Change of plans','Meeting postponed','2025-05-27 10:57:00','2025-05-29 11:49:30',NULL,'2025-05-29 12:49:30',0,NULL),(65,1,41,'Group Revision Meeting','2025-05-30 08:00:00','2025-05-30 10:00:00','A meeting held by 20 final semester Computer Science students to do a course review for our upcoming Artificial Intelligence examination on the 1st of June. ',20,'rejected','Room is currently under maintenance',NULL,NULL,'2025-05-28 23:38:09','2025-05-29 10:56:02',NULL,NULL,0,NULL),(66,1,41,'Group Discussion','2025-05-30 13:00:00','2025-05-30 14:00:00','Meeting with my reading group to discuss our upcoming project on software development.',14,'cancelled',NULL,'Meeting postponed',NULL,'2025-05-28 23:49:16','2025-05-29 11:17:01',NULL,'2025-05-29 12:17:01',0,NULL),(67,2,41,'Team Meeting','2025-05-30 15:50:00','2025-05-30 17:50:00','My general monthly team meeting.',5,'approved',NULL,NULL,NULL,'2025-05-29 12:45:02','2025-05-29 14:43:10',NULL,NULL,1,'2025-05-29 14:43:10'),(68,1,9,'Group Revision Meeting','2025-05-30 08:00:00','2025-05-30 10:00:00','Group Revision Meeting for all team mates.',7,'pending',NULL,NULL,NULL,'2025-05-29 15:08:26','2025-05-29 15:28:33',NULL,NULL,0,NULL),(69,17,9,'Team Revision Meeting','2025-05-30 10:00:00','2025-05-30 12:00:00','Team Revision Meeting',7,'pending',NULL,NULL,NULL,'2025-05-29 15:32:48','2025-05-29 15:57:31',NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `room_amenities`
--

LOCK TABLES `room_amenities` WRITE;
/*!40000 ALTER TABLE `room_amenities` DISABLE KEYS */;
INSERT INTO `room_amenities` VALUES (1,'Projector','HD Projector with HDMI inputs','fas fa-video'),(2,'Whiteboard','Large whiteboard with markers','fas fa-chalkboard'),(3,'Video Conferencing','Zoom/Teams compatible system','fas fa-video'),(4,'Wheelchair Access','ADA compliant access','fas fa-wheelchair'),(5,'PA System','Public address system','fas fa-microphone'),(6,'Computer','Dedicated workstation','fas fa-laptop'),(7,'WiFi','High-speed campus network','fas fa-wifi'),(8,'Telephone','Conference phone with speaker','fas fa-phone'),(9,'Catering','Available upon request','fas fa-utensils');
/*!40000 ALTER TABLE `room_amenities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `room_amenity_mapping`
--

LOCK TABLES `room_amenity_mapping` WRITE;
/*!40000 ALTER TABLE `room_amenity_mapping` DISABLE KEYS */;
INSERT INTO `room_amenity_mapping` VALUES (5,1),(8,1),(2,2),(4,2),(4,3),(3,4),(4,4),(7,4),(1,5),(2,5),(1,6),(7,6),(8,6),(2,7),(3,7),(5,7),(1,8),(3,8),(8,9);
/*!40000 ALTER TABLE `room_amenity_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `room_images`
--

LOCK TABLES `room_images` WRITE;
/*!40000 ALTER TABLE `room_images` DISABLE KEYS */;
INSERT INTO `room_images` VALUES (108,2,'/RoomReserve/uploads/494754e2-912a-4933-ab57-efafcfd8b1e9_1748367275154.jpg','',1,0,'2025-05-27 17:34:35',NULL),(109,2,'/RoomReserve/uploads/0f6feb14-4fe0-42de-a416-5795f0e2d8f2_1748367275202.jpg','',0,0,'2025-05-27 17:34:35',NULL),(110,2,'/RoomReserve/uploads/0f31ab01-f4d1-45bf-b7cd-b5c7cd52b80b_1748367275203.jpg','',0,0,'2025-05-27 17:34:35',NULL),(111,2,'/RoomReserve/uploads/c989a944-2446-4431-a171-81a1bf5ca24a_1748367275221.jpg','',0,0,'2025-05-27 17:34:35',NULL),(112,1,'/RoomReserve/uploads/92da8ba2-800b-4122-9f98-48278e150ccd_1748367309500.jpg','',1,0,'2025-05-27 17:35:09',NULL),(113,1,'/RoomReserve/uploads/4314d656-4bc5-48a1-b032-411466568f65_1748367309568.jpg','',0,0,'2025-05-27 17:35:09',NULL),(114,1,'/RoomReserve/uploads/600290a7-3244-4f0d-9a42-977aada45756_1748367309597.jpg','',0,0,'2025-05-27 17:35:09',NULL),(115,4,'/RoomReserve/uploads/a0fb66fd-956d-47f4-bba9-f139e17ec4d8_1748367345454.jpg','',1,0,'2025-05-27 17:35:45',NULL),(116,4,'/RoomReserve/uploads/1126bf2b-cfce-460b-9d4e-c8a6ed515461_1748367345545.jpg','',0,0,'2025-05-27 17:35:45',NULL),(117,4,'/RoomReserve/uploads/03c9af3c-e36c-46ba-8cf7-0c8955a8e8e3_1748367345565.jpg','',0,0,'2025-05-27 17:35:45',NULL),(118,4,'/RoomReserve/uploads/8b09e9e4-06c6-40a1-a151-55617bbc4f6e_1748367345590.jpg','',0,0,'2025-05-27 17:35:45',NULL),(119,6,'/RoomReserve/uploads/6f945b1e-0362-42df-abe2-13635c5f7b74_1748367537186.jpg','',1,0,'2025-05-27 17:38:57',NULL),(120,6,'/RoomReserve/uploads/0bc2ea30-26e4-4e29-9314-eb0fee2ac734_1748367537287.jpg','',0,0,'2025-05-27 17:38:57',NULL),(121,6,'/RoomReserve/uploads/c47a102a-ba6f-4bae-a33c-243a39ac103f_1748367537299.jpg','',0,0,'2025-05-27 17:38:57',NULL),(122,6,'/RoomReserve/uploads/6b9533ec-942c-4dbd-91ad-f9ebc8467ec3_1748367537318.jpg','',0,0,'2025-05-27 17:38:57',NULL),(123,8,'/RoomReserve/uploads/b68eb535-f4a5-40c3-a194-6ec60eb9ec5c_1748367565617.jpg','',1,0,'2025-05-27 17:39:25',NULL),(124,8,'/RoomReserve/uploads/b440da61-2da3-497c-9d51-7193663941bf_1748367565666.jpg','',0,0,'2025-05-27 17:39:25',NULL),(125,8,'/RoomReserve/uploads/7f022f6c-ad1c-4260-9dd4-4df5ef5ea9ed_1748367565700.jpg','',0,0,'2025-05-27 17:39:25',NULL),(126,8,'/RoomReserve/uploads/d5359271-d52c-4396-ba48-26739063b0f9_1748367565714.jpg','',0,0,'2025-05-27 17:39:25',NULL),(127,7,'/RoomReserve/uploads/5899356d-b6a4-4b57-80df-fd11b4dff634_1748367600814.jpg','',1,0,'2025-05-27 17:40:00',NULL),(128,7,'/RoomReserve/uploads/5bff13b8-fcb5-4964-be4b-851c9dce3ee6_1748367600862.jpg','',0,0,'2025-05-27 17:40:00',NULL),(129,7,'/RoomReserve/uploads/2bc3dda0-98d5-479b-958d-77e682a11cf9_1748367600883.jpg','',0,0,'2025-05-27 17:40:00',NULL),(130,7,'/RoomReserve/uploads/0fc77e64-0e98-4b7a-8738-ed025bb932ee_1748367600906.jpg','',0,0,'2025-05-27 17:40:00',NULL),(131,5,'/RoomReserve/uploads/d8dafedb-40dc-4953-abff-1aa73aa0b4a3_1748367635624.jpg','',1,0,'2025-05-27 17:40:35',NULL),(132,5,'/RoomReserve/uploads/c585ddbb-b8a9-4151-b538-fdea6f311fb9_1748367635690.jpg','',0,0,'2025-05-27 17:40:35',NULL),(133,5,'/RoomReserve/uploads/9c58ea62-0481-4f4c-8050-774c8bb95865_1748367635705.jpg','',0,0,'2025-05-27 17:40:35',NULL),(134,5,'/RoomReserve/uploads/0acd5b18-1ecc-465d-9494-0acd5f3996ef_1748367635705.jpg','',0,0,'2025-05-27 17:40:35',NULL),(135,17,'/RoomReserve/uploads/40591fec-36b2-41ea-a120-d45949114ed0_1748367683632.jpg','',1,0,'2025-05-27 17:41:23',NULL),(136,17,'/RoomReserve/uploads/ffec1913-c182-4f99-8933-ec36b6f98bca_1748367683705.jpg','',0,0,'2025-05-27 17:41:23',NULL),(137,17,'/RoomReserve/uploads/c83b916c-87d8-4665-8234-a5a1332c4a64_1748367683716.jpg','',0,0,'2025-05-27 17:41:23',NULL),(138,3,'/RoomReserve/uploads/5edafce4-3931-4dbd-bdbf-c86ebb0e7f66_1748367726751.jpg','',1,0,'2025-05-27 17:42:06',NULL),(139,3,'/RoomReserve/uploads/d25bb530-6547-4d86-92ff-40fca8b9bf33_1748367726795.jpg','',0,0,'2025-05-27 17:42:06',NULL);
/*!40000 ALTER TABLE `room_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,1,'Conference Room A','201',2,120,'conference','Main department conference room with projector',112,1,'2025-04-06 18:28:22'),(2,1,'Lecture Hall B','101',1,45,'lecture','Large lecture hall with PA system. Located on the 10th floor with panoramic views of the campus, this room provides a quiet, distraction-free environment with soundproof walls and blackout curtains for complete privacy when needed.',108,1,'2025-04-06 18:28:22'),(3,3,'Seminar Room 1','301',3,8,'seminar','Small seminar room for group discussions',138,0,'2025-04-06 18:28:22'),(4,1,'Biology Lab','401',2,55,'lab','Biology Lab',115,1,'2025-04-18 19:36:28'),(5,3,'Chemistry Lab','222',3,50,'lab','Chemistry Lab',131,1,'2025-04-22 08:40:53'),(6,2,'Seminar Room 2','120',1,65,'seminar','Seminar room at Humanities Hall',119,1,'2025-04-22 08:45:41'),(7,3,'Davidson Hall','200',2,22,'other','Davidson Hall',127,1,'2025-04-22 08:47:10'),(8,3,'Executive Conference Room','1001',3,45,'seminar','Executive Conference Room',123,1,'2025-04-25 12:42:38'),(17,3,'Lulu','290',3,22,'seminar','rfb jrv  ejc',135,1,'2025-04-26 18:53:08');
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `system_settings`
--

LOCK TABLES `system_settings` WRITE;
/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
INSERT INTO `system_settings` VALUES (1,'system_name','RoomReserve','The display name for the application',1,'2025-04-27 05:22:31','2025-05-23 12:27:16'),(2,'max_booking_days','30','Maximum days in advance a room can be booked',1,'2025-04-27 05:22:31','2025-05-24 14:51:51'),(3,'min_booking_hours','2','Minimum hours required before a meeting to book',1,'2025-04-27 05:22:31','2025-04-27 05:22:31'),(5,'allow_weekend_bookings','true','Whether weekend bookings are allowed',1,'2025-04-27 05:22:31','2025-05-24 12:26:43'),(7,'admin_email','ovansa23@gmail.com','Primary administrator email address',1,'2025-04-27 05:22:31','2025-05-24 14:49:49'),(8,'system_timezone','China/Beijing','System timezone for all date/time operations',0,'2025-04-27 05:22:31','2025-04-27 05:42:44'),(9,'version','1.0.0','Current system version',0,'2025-04-27 05:22:31','2025-04-27 05:22:31'),(11,'reminder_hours_before','24','How many hours before reservation to send reminder',1,'2025-05-23 09:02:25','2025-05-29 12:48:31'),(12,'reminder_check_interval','2','How often to check for reminders (minutes)',1,'2025-05-23 09:02:25','2025-05-29 12:48:39'),(13,'min_meeting_duration','30','Minimum meeting duration in minutes',1,'2025-05-24 14:12:28','2025-05-24 14:29:28'),(14,'max_meeting_duration','240','Maximum meeting duration in minutes',1,'2025-05-24 14:12:28','2025-05-24 14:12:28'),(15,'allow_only_business_hours','false','Allow meetings only during business hours',1,'2025-05-27 10:04:46','2025-05-27 10:56:03');
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_favorites`
--

LOCK TABLES `user_favorites` WRITE;
/*!40000 ALTER TABLE `user_favorites` DISABLE KEYS */;
INSERT INTO `user_favorites` VALUES (9,1,'2025-05-24 15:02:04'),(9,3,'2025-05-18 16:37:11'),(9,5,'2025-05-19 10:27:46'),(21,1,'2025-05-27 09:43:11'),(41,1,'2025-05-29 08:02:50'),(41,4,'2025-05-29 08:02:59'),(41,5,'2025-05-29 08:03:12');
/*!40000 ALTER TABLE `user_favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_notification_prefs`
--

LOCK TABLES `user_notification_prefs` WRITE;
/*!40000 ALTER TABLE `user_notification_prefs` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_notification_prefs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_reports`
--

LOCK TABLES `user_reports` WRITE;
/*!40000 ALTER TABLE `user_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (9,'Miracle','$2a$10$7j9VKh1QJUfV2s8ftUb4PuQdojcr6pZcjOW40770GPN1yJJn3hdKK','ovansa@gmail.com','Miracle','Ovansa','student',1,'08148569284',1,1,'2025-04-09 15:09:43','2025-05-29 15:55:49'),(10,'ovansa','$2a$10$FVvssCn2ykVg3.NnCzpxweOmRDezXMkajNMySKKYRmUsxBbOwOzIW','ovansa23@gmail.com','Ovansa','Miracle','admin',4,'15140244699',1,1,'2025-04-09 21:48:23','2025-05-30 12:23:41'),(20,'Ash','$2a$10$9FcmeEVuh0fwEfYM0UHssu41y27lxknN9woLsAp2b1P08IyEG3UbW','didiakin@yahoo.com','Didi','Akinjo','manager',1,'195152010913',1,1,'2025-04-20 19:15:34','2025-05-30 12:29:07'),(21,'Topseen','$2a$10$TVDf/QGHbVx71D3uZfnHVepwmF8.X91ZLEIwvBV483EWtogjWqGqm','abodunrintopseendd@gmail.com','Temitope','Abodunrin','student',1,'195152010913',1,1,'2025-04-21 10:06:25','2025-05-27 10:45:42'),(22,'Akinjo','$2a$10$m1OTkrtKA0JiC.P72feXf.cDxLGBPG9fzzXxPLZ/xPgiNoZVnA4Aa','didiakinjo@yahoo.com','Didi','Akinjo','faculty',1,'195152010913',1,0,'2025-04-21 22:40:41','2025-05-28 16:19:17'),(23,'LuoZhen','$2a$10$dlh2TIDh4vsxwS7xGp5fwO2wb4pJMXSIxUo2RNqHVqDMn6Ws5dnWW','luozhen@gmail.com','Luo','Zhen','manager',1,'15140244699',1,1,'2025-04-22 17:09:53','2025-05-30 12:22:10'),(26,'jcedu','$2a$10$DhOZ5MPHHNHMrSInO6ICC.YGa7EoDsv8sE1CE7lEQGtrCq6r5mFyu','jiruve@yahoo.com','kjnv','nngw','manager',1,'195152010913',1,0,'2025-04-28 14:15:14',NULL),(28,'Tee','$2a$10$.bXJDa4oyT8AtBkcll1E0O5o6L318sy8Vbj9D4fMQg0Nr0BvY67Ha','abodunrintopseen@gmail.com','Topseen','Abodunrin','student',1,'195152010913',1,1,'2025-05-21 16:41:09','2025-05-22 22:05:13'),(31,'olive','$2a$10$stlfT2gG0FHnClt.ujSY6.MDKZ.3j1xn9nbVfXTx46Jm1BYyJApdi','olivia.white@medicare.com','Olivia','White','admin',1,'1867902544',1,0,'2025-05-23 19:55:45','2025-05-23 19:56:00'),(41,'newuser','$2a$10$zddiY9/igluLMGQsyszPCexJOoGMtBllB86D7YNduJp5dBPuyQdDS','oluwadimimuakinjo@yahoo.com','New','User','faculty',1,'15140244699',1,1,'2025-05-28 20:02:29','2025-05-30 12:25:18');
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

-- Dump completed on 2025-05-30 13:30:07
