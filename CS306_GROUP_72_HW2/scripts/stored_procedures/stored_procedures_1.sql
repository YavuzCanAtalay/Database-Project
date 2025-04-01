-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 30, 2025 at 02:12 PM
-- Server version: 9.2.0
-- PHP Version: 8.2.12



DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUserReputation` (IN `uid` VARCHAR(10))   BEGIN
  DECLARE total_likes INT DEFAULT 0;
  DECLARE total_followups INT DEFAULT 0;
  DECLARE total_reviews INT DEFAULT 0;
  DECLARE total_marks INT DEFAULT 0;
  DECLARE new_reputation INT DEFAULT 0;

  SELECT 
    IFNULL(SUM(likes), 0), 
    IFNULL(SUM(followUps), 0), 
    COUNT(*)
  INTO 
    total_likes, total_followups, total_reviews
  FROM has_view_reviews
  WHERE UserID = uid;

  SELECT COUNT(*)
  INTO total_marks
  FROM marked
  WHERE UserID = uid;

  SET new_reputation = 
      (1 * total_likes) +
      (1 * total_followups) +
      (1 * total_marks) +
      (1 * total_reviews);

  UPDATE users
  SET Reputation = new_reputation
  WHERE UserID = uid;
END$$

DELIMITER ;

