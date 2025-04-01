-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 01, 2025 at 05:45 PM
-- Server version: 9.2.0
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cs306`
--

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

-- --------------------------------------------------------

--
-- Table structure for table `has_view_reviews`
--

CREATE TABLE `has_view_reviews` (
  `UserID` char(5) NOT NULL,
  `RestaurantID` int NOT NULL,
  `reviewID` int NOT NULL,
  `view_date` char(10) DEFAULT NULL,
  `rating` double DEFAULT NULL,
  `likes` int DEFAULT NULL,
  `FollowUps` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `has_view_reviews`
--

INSERT INTO `has_view_reviews` (`UserID`, `RestaurantID`, `reviewID`, `view_date`, `rating`, `likes`, `FollowUps`) VALUES
('A001', 1, 100, '2024-03-01', 8.2, 741, 42),
('A001', 1, 101, '2024-03-02', 7.2, 203, 378),
('A001', 2, 102, '2024-03-03', 9, 181, 315),
('A001', 6, 120, '2025-03-27', 0, 613, 85),
('A001', 7, 200, '3/30/2025', 10, 10, 10),
('A002', 6, 2001, '2025-03-30', 10, 50, 50),
('A003', 2, 103, '2024-03-04', 5.6, 19, 289),
('A005', 8, 115, '2024-03-16', 6.3, 835, 219),
('A005', 9, 116, '2024-03-17', 7.4, 696, 77),
('A005', 9, 117, '2024-03-18', 6.7, 695, 2),
('A005', 10, 118, '2024-03-19', 5.9, 939, 339),
('A005', 10, 119, '2024-03-20', 8.8, 581, 432),
('A100', 3, 104, '2024-03-05', 6.7, 588, 168),
('C045', 3, 105, '2024-03-06', 8.3, 929, 314),
('C045', 8, 114, '2024-03-15', 7.4, 359, 452),
('D435', 4, 106, '2024-03-07', 9.6, 452, 271),
('T222', 4, 107, '2024-03-08', 7.6, 358, 79),
('T222', 5, 108, '2024-03-09', 6.9, 728, 78),
('T222', 5, 109, '2024-03-10', 8.7, 599, 262),
('T222', 6, 110, '2024-03-11', 4.5, 833, 291),
('T222', 6, 111, '2024-03-12', 5.8, 423, 181),
('T222', 7, 112, '2024-03-13', 8.1, 543, 313),
('U092', 7, 113, '2024-03-14', 8.8, 510, 332);

--
-- Triggers `has_view_reviews`
--
DELIMITER $$
CREATE TRIGGER `TriggerReputationOnLikesandFollowUps` AFTER INSERT ON `has_view_reviews` FOR EACH ROW BEGIN
  CALL UpdateUserReputation(NEW.UserID);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `TriggerReputationOnMark` AFTER INSERT ON `has_view_reviews` FOR EACH ROW BEGIN
  CALL UpdateUserReputation(NEW.UserID);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `TriggerReputationOnReviews` AFTER INSERT ON `has_view_reviews` FOR EACH ROW BEGIN
  CALL UpdateUserReputation(NEW.UserID);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `flag_low_rated_restaurants` AFTER INSERT ON `has_view_reviews` FOR EACH ROW BEGIN
  DECLARE avg_rating DECIMAL(4,2);

  -- Calculate the updated average
  SELECT ROUND(AVG(rating), 2)
  INTO avg_rating
  FROM has_view_reviews
  WHERE RestaurantID = NEW.RestaurantID;

  -- Update the flag based on threshold
  UPDATE restaurants
  SET 
    AverageRating = avg_rating,
    IsFlagged = (avg_rating < 4.0)
  WHERE RestaurantID = NEW.RestaurantID;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_avg_rating` AFTER INSERT ON `has_view_reviews` FOR EACH ROW BEGIN
  UPDATE restaurants
  SET AverageRating = (
    SELECT ROUND(AVG(rating), 1)
    FROM has_view_reviews
    WHERE RestaurantID = NEW.RestaurantID
  )
  WHERE RestaurantID = NEW.RestaurantID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `marked`
--

CREATE TABLE `marked` (
  `UserID` char(5) NOT NULL,
  `RestaurantID` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `marked`
--

INSERT INTO `marked` (`UserID`, `RestaurantID`) VALUES
('A001', 1),
('A005', 2),
('A005', 3),
('T222', 4),
('C045', 5),
('C045', 6),
('T222', 7),
('U092', 8),
('U092', 9),
('U092', 10);

-- --------------------------------------------------------

--
-- Table structure for table `menu_offer`
--

CREATE TABLE `menu_offer` (
  `NameItem` char(25) DEFAULT NULL,
  `AboutItem` char(100) DEFAULT NULL,
  `PriceItem` double DEFAULT NULL,
  `NoItem` int NOT NULL,
  `RestaurantID` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `menu_offer`
--

INSERT INTO `menu_offer` (`NameItem`, `AboutItem`, `PriceItem`, `NoItem`, `RestaurantID`) VALUES
('Ratatouille', 'Vegetable stew', 7, 1, 1),
('Quiche Lorraine', 'Savory pie with cheese, cream, and bacon', 8.5, 2, 1),
('Lahmacun', 'Thin dough with meat and spices', 4, 4, 2),
('Adana Kebab', 'Spicy ground meat skewer', 9, 5, 2),
('Margherita Pizza', 'Pizza with tomato, mozzarella, basil', 9.5, 7, 3),
('Tiramisu', 'Coffee-flavored dessert', 6, 8, 3),
('Apple Strudel', 'Apple pastry dessert', 5.5, 10, 4),
('Pretzel', 'Baked bread', 3, 11, 4),
('Sachertorte', 'Chocolate cake with apricot jam', 6, 13, 5),
('Schnitzel', 'Breaded veal cutlet', 11, 14, 5),
('Kürtőskalács', 'Chimney cake', 4, 15, 6),
('Gulyás', 'Beef stew with paprika', 9, 16, 6),
('Svíčková', 'Marinated beef with cream sauce', 10, 17, 7),
('Medovnik', 'Honey cake', 5, 18, 7),
('Ratatouille', 'Vegetable stew', 7, 19, 8),
('Quiche Lorraine', 'Savory pie with cheese, cream, and bacon', 8.5, 20, 8),
('Victoria Sponge', 'Layer cake with jam and cream', 5.5, 22, 9),
('Fish and Chips', 'Fried fish with fries', 9, 23, 9),
('Tortilla Española', 'Egg and potato omelette', 6.5, 24, 10),
('Churros', 'Fried dough pastry', 4, 25, 10);

-- --------------------------------------------------------

--
-- Table structure for table `restaurants`
--

CREATE TABLE `restaurants` (
  `RestaurantID` int NOT NULL,
  `name` char(125) DEFAULT NULL,
  `street` char(20) DEFAULT NULL,
  `city` char(20) DEFAULT NULL,
  `country` char(20) DEFAULT NULL,
  `AverageRating` double DEFAULT NULL,
  `capacity` int DEFAULT NULL,
  `cuisine_type` char(50) DEFAULT NULL,
  `vegetarian_available` tinyint(1) DEFAULT NULL,
  `best_selling` char(25) DEFAULT NULL,
  `alcohol_available` tinyint(1) DEFAULT NULL,
  `gluten_free_option` tinyint(1) DEFAULT NULL,
  `wifi` tinyint(1) DEFAULT NULL,
  `RestaurantType` char(20) DEFAULT NULL,
  `IsFlagged` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `restaurants`
--

INSERT INTO `restaurants` (`RestaurantID`, `name`, `street`, `city`, `country`, `AverageRating`, `capacity`, `cuisine_type`, `vegetarian_available`, `best_selling`, `alcohol_available`, `gluten_free_option`, `wifi`, `RestaurantType`, `IsFlagged`) VALUES
(1, 'Le Petit Bistro', 'Rue Cler', 'Paris', 'France', 7.7, 50, 'French', 1, 'Duck Confit', 1, 1, 1, 'Traditional', 0),
(2, 'Anatolia Sofrası', 'İstiklal Cad.', 'Istanbul', 'Turkey', 7.3, 80, 'Turkish', 1, 'Adana Kebab', 0, 0, 1, 'Traditional', 0),
(3, 'Dolce Vita', 'Via Roma', 'Rome', 'Italy', 7.5, 60, 'Italian', 1, 'Lasagna', 1, 1, 1, 'Traditional', 0),
(4, 'Berlin Kaffeehaus', 'Unter den Linden', 'Berlin', 'Germany', 8.6, 45, 'German', 1, 'Apple Strudel', 1, 1, 1, 'Cafe', 0),
(5, 'Vienna Brews', 'Mariahilfer Str.', 'Vienna', 'Austria', 7.8, 30, 'Austrian', 0, 'Schnitzel', 1, 0, 1, 'Cafe', 0),
(6, 'Kürtőskalács Heaven', 'Váci Utca', 'Budapest', 'Hungary', 5.08, 25, 'Hungarian', 1, 'Chimney Cake', 0, 0, 1, 'Patisserie', 0),
(7, 'Sweet Prague', 'Nerudova', 'Prague', 'Czech Republic', 8.97, 20, 'Czech', 0, 'Medovnik', 0, 0, 0, 'Patisserie', 0),
(8, 'Maison de Croissant', 'Boulevard Haussmann', 'Paris', 'France', 6.85, 40, 'French', 1, 'Croissant', 0, 1, 1, 'Patisserie', 0),
(9, 'Choco Cafe', 'Baker Street', 'London', 'UK', 7.05, 35, 'British', 1, 'Chocolate Cake', 0, 1, 1, 'Cafe', 0),
(10, 'Espresso Lounge', 'Gran Via', 'Madrid', 'Spain', 7.35, 30, 'Spanish', 1, 'Café con Leche', 0, 1, 1, 'Cafe', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `UserID` char(5) NOT NULL,
  `Username` char(25) DEFAULT NULL,
  `Email` char(20) DEFAULT NULL,
  `Age` int DEFAULT NULL,
  `Reputation` int DEFAULT NULL,
  `Nationality` char(25) DEFAULT NULL,
  `JoinDate` char(10) DEFAULT NULL
) ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UserID`, `Username`, `Email`, `Age`, `Reputation`, `Nationality`, `JoinDate`) VALUES
('A001', 'Alice', 'alice@example.com', 25, 2584, 'Turkish', '2024-01-01'),
('A002', 'Grace', 'grace@example.com', 31, 101, 'Spanish', '2024-07-07'),
('A003', 'Hank', 'hank@example.com', 29, 309, 'Korean', '2024-08-12'),
('A004', 'Ivy', 'ivy@example.com', 24, 0, 'Greek', '2024-09-22'),
('A005', 'Jack', 'jack@example.com', 26, 4822, 'Chinese', '2024-10-30'),
('A100', 'Eve', 'eve@example.com', 35, 724, 'French', '2024-05-05'),
('C045', 'Bob', 'bob@example.com', 30, 2058, 'Italian', '2024-02-15'),
('D435', 'Carol', 'carol@example.com', 28, 724, 'Japanese', '2024-03-10'),
('T222', 'Dave', 'dave@example.com', 22, 4696, 'American', '2024-04-20'),
('U092', 'Frank', 'frank@example.com', 27, 846, 'German', '2024-06-18');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `has_view_reviews`
--
ALTER TABLE `has_view_reviews`
  ADD PRIMARY KEY (`UserID`,`reviewID`,`RestaurantID`),
  ADD KEY `RestaurantID` (`RestaurantID`);

--
-- Indexes for table `marked`
--
ALTER TABLE `marked`
  ADD PRIMARY KEY (`UserID`,`RestaurantID`),
  ADD KEY `RestaurantID` (`RestaurantID`);

--
-- Indexes for table `menu_offer`
--
ALTER TABLE `menu_offer`
  ADD PRIMARY KEY (`NoItem`,`RestaurantID`),
  ADD KEY `RestaurantID` (`RestaurantID`);

--
-- Indexes for table `restaurants`
--
ALTER TABLE `restaurants`
  ADD PRIMARY KEY (`RestaurantID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `uc_email` (`Email`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `has_view_reviews`
--
ALTER TABLE `has_view_reviews`
  ADD CONSTRAINT `has_view_reviews_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE,
  ADD CONSTRAINT `has_view_reviews_ibfk_2` FOREIGN KEY (`RestaurantID`) REFERENCES `restaurants` (`RestaurantID`) ON DELETE CASCADE;

--
-- Constraints for table `marked`
--
ALTER TABLE `marked`
  ADD CONSTRAINT `marked_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`),
  ADD CONSTRAINT `marked_ibfk_2` FOREIGN KEY (`RestaurantID`) REFERENCES `restaurants` (`RestaurantID`);

--
-- Constraints for table `menu_offer`
--
ALTER TABLE `menu_offer`
  ADD CONSTRAINT `menu_offer_ibfk_1` FOREIGN KEY (`RestaurantID`) REFERENCES `restaurants` (`RestaurantID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
