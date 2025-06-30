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
-- Dumping data for table `email_templates`
--

LOCK TABLES `email_templates` WRITE;
/*!40000 ALTER TABLE `email_templates` DISABLE KEYS */;
INSERT INTO `email_templates` VALUES (1,'reservation_confirmation','Your Room Reservation Confirmation - #{reservation_id}','<p>Dear <i>#{user_name}</i>,</p><p>Your room reservation has been confirmed with the following details:</p><ul><li><strong>Room:</strong> #{room_name}</li><li><strong>Date:</strong> #{reservation_date}</li><li><strong>Time:</strong> #{start_time} to #{end_time}</li><li><strong>Purpose:</strong> #{purpose}</li></ul><p>If you need to cancel or modify this reservation, please visit the system at #{system_url}.</p><p>Best regards,<br>Room Reservation System</p>','2025-04-27 05:22:57','2025-05-31 14:04:40'),(2,'reservation_approval','Reservation Approved - #{reservation_id}','<p>Dear #{user_name},</p>\n <p>Your reservation request has been approved:</p>\n <ul>\n   <li><strong>Room:</strong> #{room_name}</li>\n   <li><strong>Date:</strong> #{reservation_date}</li>\n   <li><strong>Time:</strong> #{start_time} to #{end_time}</li>\n </ul>\n <p>You may now proceed with your meeting as scheduled.</p>\n <p>Best regards,<br>Room Reservation System</p>','2025-04-27 05:22:57','2025-04-27 05:22:57'),(3,'reservation_rejection','Reservation Not Approved - #{reservation_id}','<p>Dear #{user_name},</p>\n <p>We regret to inform you that your reservation request could not be approved:</p>\n <ul>\n   <li><strong>Room:</strong> #{room_name}</li>\n   <li><strong>Date:</strong> #{reservation_date}</li>\n   <li><strong>Time:</strong> #{start_time} to #{end_time}</li>\n   <li><strong>Reason:</strong> #{rejection_reason}</li>\n </ul>\n <p>Please contact #{admin_email} if you have any questions.</p>\n <p>Best regards,<br>Room Reservation System</p>','2025-04-27 05:22:57','2025-04-27 05:22:57'),(4,'reservation_reminder','Upcoming Reservation Reminder - #{reservation_id}','<p>Dear #{user_name},</p>\n <p>This is a reminder for your upcoming reservation:</p>\n <ul>\n   <li><strong>Room:</strong> #{room_name}</li>\n   <li><strong>Date:</strong> #{reservation_date}</li>\n   <li><strong>Time:</strong> #{start_time} to #{end_time}</li>\n   <li><strong>Starts in:</strong> #{hours_until} hours</li>\n </ul>\n <p>Please arrive on time for your meeting.</p>\n <p>Best regards,<br>Room Reservation System</p>','2025-04-27 05:22:57','2025-04-27 05:22:57');
/*!40000 ALTER TABLE `email_templates` ENABLE KEYS */;
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
-- Dumping data for table `room_amenities`
--

LOCK TABLES `room_amenities` WRITE;
/*!40000 ALTER TABLE `room_amenities` DISABLE KEYS */;
INSERT INTO `room_amenities` VALUES (1,'Projector','HD Projector with HDMI inputs','fas fa-video'),(2,'Whiteboard','Large whiteboard with markers','fas fa-chalkboard'),(3,'Video Conferencing','Zoom/Teams compatible system','fas fa-video'),(4,'Wheelchair Access','ADA compliant access','fas fa-wheelchair'),(5,'PA System','Public address system','fas fa-microphone'),(6,'Computer','Dedicated workstation','fas fa-laptop'),(7,'WiFi','High-speed campus network','fas fa-wifi'),(8,'Telephone','Conference phone with speaker','fas fa-phone'),(9,'Catering','Available upon request','fas fa-utensils');
/*!40000 ALTER TABLE `room_amenities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `system_settings`
--

LOCK TABLES `system_settings` WRITE;
/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
INSERT INTO `system_settings` VALUES (1,'system_name','RoomReserve','The display name for the application',1,'2025-04-27 05:22:31','2025-06-02 17:09:18'),(2,'max_booking_days','30','Maximum days in advance a room can be booked',1,'2025-04-27 05:22:31','2025-05-24 14:51:51'),(3,'min_booking_hours','1','Minimum hours required before a meeting to book',1,'2025-04-27 05:22:31','2025-06-06 22:58:10'),(5,'allow_weekend_bookings','true','Whether weekend bookings are allowed',1,'2025-04-27 05:22:31','2025-06-02 10:58:55'),(7,'admin_email','ovansa23@yahoo.com','Primary administrator email address',1,'2025-04-27 05:22:31','2025-05-31 14:25:37'),(8,'system_timezone','Nigeria/Lagos','System timezone for all date/time operations',0,'2025-04-27 05:22:31','2025-04-27 05:42:44'),(9,'version','1.0.0','Current system version',0,'2025-04-27 05:22:31','2025-04-27 05:22:31'),(11,'reminder_hours_before','24','How many hours before reservation to send reminder',1,'2025-05-23 09:02:25','2025-05-29 12:48:31'),(12,'reminder_check_interval','2','How often to check for reminders (minutes)',1,'2025-05-23 09:02:25','2025-05-29 12:48:39'),(13,'min_meeting_duration','30','Minimum meeting duration in minutes',1,'2025-05-24 14:12:28','2025-05-24 14:29:28'),(14,'max_meeting_duration','240','Maximum meeting duration in minutes',1,'2025-05-24 14:12:28','2025-05-24 14:12:28'),(15,'allow_only_business_hours','false','Allow meetings only during business hours',1,'2025-05-27 10:04:46','2025-06-02 08:55:52');
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','$2a$10$jt4HAB5I.ZUk9Et34sPK9edz8pDXrFaq6OTN0GU04mxh.8nO1BbkW','admin@gmail.com','Administrator','User','admin',4,'00000000000',1,1,'2025-04-09 21:48:23','2025-06-30 23:19:29');
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

-- Dump completed on 2025-07-01  0:16:07
