-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 19, 2024 at 03:57 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mn_641463021`
--

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `ShopID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `ProductName` varchar(100) DEFAULT NULL,
  `Unit` int(50) DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL,
  `statusDelete` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`ShopID`, `ProductID`, `ProductName`, `Unit`, `Price`, `statusDelete`) VALUES
(1, 1, 'Bottled Water', 10, '20.00', 0),
(1, 2, 'Snacks', 50, '35.00', 0),
(2, 3, 'Keychain', 40, '50.00', 0),
(2, 4, 'T-Shirt', 40, '200.00', 0),
(3, 5, 'Smartphone', 90, '10000.00', 0),
(3, 6, 'Headphones', 1, '500.00', 0),
(3, 7, 'aa', 1, '1.00', 0),
(2, 8, 'bb', 12331, '33.00', 0),
(7, 9, 'test1A', 1, '111.00', 0),
(2, 10, 'a', 1, '1.00', 1),
(2, 11, 'a', 1, '1.00', 1),
(2, 12, 'qq', 1, '122222.00', 1),
(2, 13, 'a', 2, '3.00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `route`
--

CREATE TABLE `route` (
  `RouteID` int(11) NOT NULL,
  `AttractionID` int(11) DEFAULT NULL,
  `Time` time DEFAULT NULL,
  `statusDelete` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `route`
--

INSERT INTO `route` (`RouteID`, `AttractionID`, `Time`, `statusDelete`) VALUES
(1, 1, '09:00:00', 0),
(2, 2, '10:30:00', 0),
(3, 3, '12:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `shops`
--

CREATE TABLE `shops` (
  `ShopID` int(11) NOT NULL,
  `ShopName` varchar(100) DEFAULT NULL,
  `statusDelete` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `shops`
--

INSERT INTO `shops` (`ShopID`, `ShopName`, `statusDelete`) VALUES
(1, 'ABC Convenience Store', 0),
(2, 'XYZ Souvenir Shop', 0),
(3, 'Best Deals Electronics', 1),
(4, 'test', 1),
(5, 'test', 1),
(6, 'ttt', 1),
(7, 'MainTest', 0),
(8, 'ss', 1),
(9, 'ssss', 1);

-- --------------------------------------------------------

--
-- Table structure for table `touristattractions`
--

CREATE TABLE `touristattractions` (
  `AttractionID` int(11) NOT NULL,
  `AttractionName` varchar(100) DEFAULT NULL,
  `Latitude` decimal(10,6) DEFAULT NULL,
  `Longitude` decimal(10,6) DEFAULT NULL,
  `statusDelete` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `touristattractions`
--

INSERT INTO `touristattractions` (`AttractionID`, `AttractionName`, `Latitude`, `Longitude`, `statusDelete`) VALUES
(0, 'test', '199.100000', '15.110000', 1),
(1, 'วัดร่องขุ่น', '19.907600', '99.832200', 0),
(2, 'ดอยตุง', '20.043700', '99.390000', 0),
(3, 'ถ้ำขุนน้ำนม', '20.254300', '99.853600', 0),
(4, 'แม่ฮ่องสอน', '20.429700', '99.886200', 0),
(5, 'เซ็นทรัลเชียงราย', '19.886700', '99.834800', 0),
(6, 'test', '11.000000', '11.000000', 1),
(7, 'test1', '1.000000', '1.000000', 1),
(8, 'test1', '111.000000', '111.000000', 1),
(9, 'test1', '111.000000', '111.000000', 1),
(10, 'a', '1.000000', '1.000000', 1),
(11, 'a', '1.000000', '1.000000', 1),
(12, 'bb', '1.000000', '1.000000', 1),
(13, 'ss22a', '1.000000', '1.000000', 1),
(14, 'ddd', '12.000000', '1.000000', 1);

-- --------------------------------------------------------

--
-- Table structure for table `train`
--

CREATE TABLE `train` (
  `TrainID` int(11) NOT NULL,
  `TrainNumber` varchar(50) DEFAULT NULL,
  `statusDelete` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `train`
--

INSERT INTO `train` (`TrainID`, `TrainNumber`, `statusDelete`) VALUES
(1, 'A123', 0),
(2, 'B456', 0),
(3, 'C789', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  `phone_number` varchar(10) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `statusDelete` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `address`, `phone_number`, `email`, `username`, `password`, `statusDelete`) VALUES
(1, 'anun', 'anun', 'anun', '0644042022', 'anun@gmail.com', 'anun', 'anun123', 0),
(2, 'anun1', 'anun1', 'anun1', '123456799', 'anun1@gmail.com', 'anun1', 'anun1123', 0),
(3, 'test1', 'test1', 'test1', '0644042022', 'test1@gmail.com', 'test1', 'test1', 0),
(4, 'test2', 'test2', 'test2', 'test2', 'test2@gmail.com', 'test2', 'test2test2', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`ProductID`),
  ADD KEY `ShopID` (`ShopID`);

--
-- Indexes for table `route`
--
ALTER TABLE `route`
  ADD PRIMARY KEY (`RouteID`),
  ADD KEY `AttractionID` (`AttractionID`);

--
-- Indexes for table `shops`
--
ALTER TABLE `shops`
  ADD PRIMARY KEY (`ShopID`);

--
-- Indexes for table `touristattractions`
--
ALTER TABLE `touristattractions`
  ADD PRIMARY KEY (`AttractionID`);

--
-- Indexes for table `train`
--
ALTER TABLE `train`
  ADD PRIMARY KEY (`TrainID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`ShopID`) REFERENCES `shops` (`ShopID`);

--
-- Constraints for table `route`
--
ALTER TABLE `route`
  ADD CONSTRAINT `route_ibfk_1` FOREIGN KEY (`AttractionID`) REFERENCES `touristattractions` (`AttractionID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
