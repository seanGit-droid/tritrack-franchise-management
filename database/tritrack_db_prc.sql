CREATE DATABASE IF NOT EXISTS `tritrack_db_prc` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `tritrack_db_prc`;

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 31, 2026 at 05:52 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tritrack_db_prc`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `activity_log_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `office_id` bigint(20) UNSIGNED DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `module` varchar(80) NOT NULL,
  `record_table` varchar(80) DEFAULT NULL,
  `record_id` bigint(20) UNSIGNED DEFAULT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `assessments`
--

CREATE TABLE `assessments` (
  `assessment_id` bigint(20) UNSIGNED NOT NULL,
  `renewal_id` bigint(20) UNSIGNED DEFAULT NULL,
  `amount_due` decimal(12,2) NOT NULL,
  `penalty_amount` decimal(12,2) DEFAULT 0.00,
  `other_charges` decimal(12,2) DEFAULT 0.00,
  `total_amount` decimal(12,2) NOT NULL,
  `assessment_number` varchar(50) NOT NULL,
  `assessed_by` bigint(20) UNSIGNED DEFAULT NULL,
  `assessed_at` datetime DEFAULT current_timestamp(),
  `assessment_status` enum('issued','partially_paid','paid','void') DEFAULT 'issued',
  `remarks` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `assessment_items`
--

CREATE TABLE `assessment_items` (
  `assessment_item_id` bigint(20) UNSIGNED NOT NULL,
  `assessment_id` bigint(20) UNSIGNED NOT NULL,
  `fee_type_id` int(11) DEFAULT NULL,
  `fee_name` varchar(150) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `is_custom` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `document_types`
--

CREATE TABLE `document_types` (
  `document_type_id` bigint(20) UNSIGNED NOT NULL,
  `document_name` varchar(120) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_required_for_renewal` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `drivers`
--

CREATE TABLE `drivers` (
  `driver_id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(80) NOT NULL,
  `middle_name` varchar(80) DEFAULT NULL,
  `last_name` varchar(80) NOT NULL,
  `suffix` varchar(20) DEFAULT NULL,
  `license_number` varchar(60) DEFAULT NULL,
  `license_expiry` date DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fee_types`
--

CREATE TABLE `fee_types` (
  `fee_type_id` int(11) NOT NULL,
  `fee_name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `application_type` enum('renewal','transfer','motor_change','all') NOT NULL DEFAULT 'all',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `franchisees`
--

CREATE TABLE `franchisees` (
  `franchisee_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `first_name` varchar(80) NOT NULL,
  `middle_name` varchar(80) DEFAULT NULL,
  `last_name` varchar(80) NOT NULL,
  `suffix` varchar(20) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `address` text NOT NULL,
  `barangay` varchar(100) DEFAULT NULL,
  `city_municipality` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `contact_number` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `franchises`
--

CREATE TABLE `franchises` (
  `franchise_id` bigint(20) UNSIGNED NOT NULL,
  `franchisee_id` bigint(20) UNSIGNED NOT NULL,
  `franchise_number` varchar(50) NOT NULL,
  `date_issued` date DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  `franchise_status` enum('active','for_renewal','expired','suspended','cancelled','transferred') DEFAULT 'active',
  `remarks` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `franchise_documents`
--

CREATE TABLE `franchise_documents` (
  `franchise_document_id` bigint(20) UNSIGNED NOT NULL,
  `franchise_id` bigint(20) UNSIGNED NOT NULL,
  `document_type_id` bigint(20) UNSIGNED NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `file_size_bytes` bigint(20) UNSIGNED DEFAULT NULL,
  `uploaded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `verification_status` enum('pending','approved','rejected') DEFAULT 'pending',
  `verified_by` bigint(20) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `franchise_drivers`
--

CREATE TABLE `franchise_drivers` (
  `franchise_driver_id` bigint(20) UNSIGNED NOT NULL,
  `franchise_id` bigint(20) UNSIGNED NOT NULL,
  `driver_id` bigint(20) UNSIGNED NOT NULL,
  `assigned_from` date NOT NULL,
  `assigned_until` date DEFAULT NULL,
  `is_primary` tinyint(1) DEFAULT 0,
  `assignment_status` enum('active','ended') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `franchise_transfers`
--

CREATE TABLE `franchise_transfers` (
  `transfer_id` bigint(20) UNSIGNED NOT NULL,
  `franchise_id` bigint(20) UNSIGNED NOT NULL,
  `old_franchisee_id` bigint(20) UNSIGNED NOT NULL,
  `new_franchisee_id` bigint(20) UNSIGNED NOT NULL,
  `application_number` varchar(50) NOT NULL,
  `reason` text DEFAULT NULL,
  `status` enum('draft','submitted','under_review','for_compliance','approved','rejected','cancelled') DEFAULT 'submitted',
  `submitted_at` datetime DEFAULT current_timestamp(),
  `reviewed_by` bigint(20) UNSIGNED DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `remarks` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `franchise_vehicles`
--

CREATE TABLE `franchise_vehicles` (
  `franchise_vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `franchise_id` bigint(20) UNSIGNED NOT NULL,
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `assigned_from` date NOT NULL,
  `assigned_until` date DEFAULT NULL,
  `assignment_status` enum('active','replaced','ended') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `motor_change_applications`
--

CREATE TABLE `motor_change_applications` (
  `motor_change_id` bigint(20) UNSIGNED NOT NULL,
  `franchise_id` bigint(20) UNSIGNED NOT NULL,
  `old_vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `new_vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `application_number` varchar(50) NOT NULL,
  `reason` text DEFAULT NULL,
  `status` enum('draft','submitted','under_review','for_compliance','approved','rejected','cancelled') DEFAULT 'submitted',
  `submitted_at` datetime DEFAULT current_timestamp(),
  `reviewed_by` bigint(20) UNSIGNED DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `remarks` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `motor_change_history`
--

CREATE TABLE `motor_change_history` (
  `motor_change_history_id` bigint(20) UNSIGNED NOT NULL,
  `motor_change_id` bigint(20) UNSIGNED NOT NULL,
  `franchise_id` bigint(20) UNSIGNED NOT NULL,
  `old_vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `new_vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `effective_date` date NOT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(150) NOT NULL,
  `message` text NOT NULL,
  `notification_type` varchar(50) DEFAULT NULL,
  `related_table` varchar(60) DEFAULT NULL,
  `related_record_id` bigint(20) UNSIGNED DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `read_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `offices`
--

CREATE TABLE `offices` (
  `office_id` bigint(20) UNSIGNED NOT NULL,
  `office_code` varchar(20) NOT NULL,
  `office_name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` bigint(20) UNSIGNED NOT NULL,
  `assessment_id` bigint(20) UNSIGNED NOT NULL,
  `payment_method_id` bigint(20) UNSIGNED NOT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  `amount_paid` decimal(12,2) NOT NULL,
  `proof_file_path` varchar(500) DEFAULT NULL,
  `payment_status` enum('submitted','under_verification','verified','rejected','refunded') DEFAULT 'submitted',
  `paid_at` datetime DEFAULT NULL,
  `submitted_at` datetime DEFAULT current_timestamp(),
  `verified_by` bigint(20) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `treasury_remarks` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment_methods`
--

CREATE TABLE `payment_methods` (
  `payment_method_id` bigint(20) UNSIGNED NOT NULL,
  `method_name` varchar(80) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `renewal_applications`
--

CREATE TABLE `renewal_applications` (
  `renewal_id` bigint(20) UNSIGNED NOT NULL,
  `franchise_id` bigint(20) UNSIGNED NOT NULL,
  `application_number` varchar(50) NOT NULL,
  `submitted_at` datetime DEFAULT current_timestamp(),
  `target_renewal_year` year(4) DEFAULT NULL,
  `status` enum('draft','submitted','under_review','for_compliance','approved','rejected','cancelled') DEFAULT 'submitted',
  `reviewed_by` bigint(20) UNSIGNED DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `renewal_documents`
--

CREATE TABLE `renewal_documents` (
  `renewal_document_id` bigint(20) UNSIGNED NOT NULL,
  `renewal_id` bigint(20) UNSIGNED NOT NULL,
  `document_type_id` bigint(20) UNSIGNED NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `file_size_bytes` bigint(20) UNSIGNED DEFAULT NULL,
  `verification_status` enum('pending','approved','rejected') DEFAULT 'pending',
  `verified_by` bigint(20) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transfer_documents`
--

CREATE TABLE `transfer_documents` (
  `transfer_document_id` bigint(20) UNSIGNED NOT NULL,
  `transfer_id` bigint(20) UNSIGNED NOT NULL,
  `document_type_id` bigint(20) UNSIGNED NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `verification_status` enum('pending','approved','rejected') DEFAULT 'pending',
  `verified_by` bigint(20) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transfer_history`
--

CREATE TABLE `transfer_history` (
  `transfer_history_id` bigint(20) UNSIGNED NOT NULL,
  `transfer_id` bigint(20) UNSIGNED NOT NULL,
  `franchise_id` bigint(20) UNSIGNED NOT NULL,
  `previous_owner_id` bigint(20) UNSIGNED NOT NULL,
  `new_owner_id` bigint(20) UNSIGNED NOT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `effective_date` date NOT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `office_id` bigint(20) UNSIGNED DEFAULT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `username` varchar(80) DEFAULT NULL,
  `mobile_number` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `account_status` enum('pending','active','suspended','rejected') DEFAULT 'pending',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `or_number` varchar(60) DEFAULT NULL,
  `cr_number` varchar(60) DEFAULT NULL,
  `motor_number` varchar(80) NOT NULL,
  `chassis_number` varchar(80) DEFAULT NULL,
  `plate_number` varchar(30) DEFAULT NULL,
  `make` varchar(80) DEFAULT NULL,
  `model` varchar(80) DEFAULT NULL,
  `year_model` year(4) DEFAULT NULL,
  `color` varchar(40) DEFAULT NULL,
  `vehicle_status` enum('pending','active','replaced','retired','rejected') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`activity_log_id`),
  ADD KEY `office_id` (`office_id`),
  ADD KEY `idx_logs_module_date` (`module`,`created_at`),
  ADD KEY `idx_logs_user_date` (`user_id`,`created_at`);

--
-- Indexes for table `assessments`
--
ALTER TABLE `assessments`
  ADD PRIMARY KEY (`assessment_id`),
  ADD UNIQUE KEY `assessment_number` (`assessment_number`),
  ADD KEY `assessed_by` (`assessed_by`),
  ADD KEY `idx_assessment_status` (`assessment_status`),
  ADD KEY `idx_assessment_renewal` (`renewal_id`);

--
-- Indexes for table `assessment_items`
--
ALTER TABLE `assessment_items`
  ADD PRIMARY KEY (`assessment_item_id`),
  ADD KEY `fk_assessment_items_assessment` (`assessment_id`),
  ADD KEY `fk_assessment_items_fee_type` (`fee_type_id`);

--
-- Indexes for table `document_types`
--
ALTER TABLE `document_types`
  ADD PRIMARY KEY (`document_type_id`),
  ADD UNIQUE KEY `document_name` (`document_name`);

--
-- Indexes for table `drivers`
--
ALTER TABLE `drivers`
  ADD PRIMARY KEY (`driver_id`),
  ADD UNIQUE KEY `license_number` (`license_number`),
  ADD KEY `idx_drivers_name` (`last_name`,`first_name`);

--
-- Indexes for table `fee_types`
--
ALTER TABLE `fee_types`
  ADD PRIMARY KEY (`fee_type_id`);

--
-- Indexes for table `franchisees`
--
ALTER TABLE `franchisees`
  ADD PRIMARY KEY (`franchisee_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `idx_franchisees_name` (`last_name`,`first_name`),
  ADD KEY `idx_franchisees_contact` (`contact_number`);

--
-- Indexes for table `franchises`
--
ALTER TABLE `franchises`
  ADD PRIMARY KEY (`franchise_id`),
  ADD UNIQUE KEY `franchise_number` (`franchise_number`),
  ADD KEY `idx_franchises_status_expiry` (`franchise_status`,`expiration_date`),
  ADD KEY `idx_franchises_owner` (`franchisee_id`);

--
-- Indexes for table `franchise_documents`
--
ALTER TABLE `franchise_documents`
  ADD PRIMARY KEY (`franchise_document_id`),
  ADD KEY `document_type_id` (`document_type_id`),
  ADD KEY `uploaded_by` (`uploaded_by`),
  ADD KEY `verified_by` (`verified_by`),
  ADD KEY `idx_fdoc_franchise` (`franchise_id`,`verification_status`);

--
-- Indexes for table `franchise_drivers`
--
ALTER TABLE `franchise_drivers`
  ADD PRIMARY KEY (`franchise_driver_id`),
  ADD KEY `idx_fd_franchise_active` (`franchise_id`,`assignment_status`),
  ADD KEY `idx_fd_driver` (`driver_id`);

--
-- Indexes for table `franchise_transfers`
--
ALTER TABLE `franchise_transfers`
  ADD PRIMARY KEY (`transfer_id`),
  ADD UNIQUE KEY `application_number` (`application_number`),
  ADD KEY `old_franchisee_id` (`old_franchisee_id`),
  ADD KEY `new_franchisee_id` (`new_franchisee_id`),
  ADD KEY `reviewed_by` (`reviewed_by`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `idx_transfer_franchise_status` (`franchise_id`,`status`);

--
-- Indexes for table `franchise_vehicles`
--
ALTER TABLE `franchise_vehicles`
  ADD PRIMARY KEY (`franchise_vehicle_id`),
  ADD KEY `idx_fv_franchise_active` (`franchise_id`,`assignment_status`),
  ADD KEY `idx_fv_vehicle` (`vehicle_id`);

--
-- Indexes for table `motor_change_applications`
--
ALTER TABLE `motor_change_applications`
  ADD PRIMARY KEY (`motor_change_id`),
  ADD UNIQUE KEY `application_number` (`application_number`),
  ADD KEY `old_vehicle_id` (`old_vehicle_id`),
  ADD KEY `new_vehicle_id` (`new_vehicle_id`),
  ADD KEY `reviewed_by` (`reviewed_by`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `idx_mc_franchise_status` (`franchise_id`,`status`);

--
-- Indexes for table `motor_change_history`
--
ALTER TABLE `motor_change_history`
  ADD PRIMARY KEY (`motor_change_history_id`),
  ADD UNIQUE KEY `motor_change_id` (`motor_change_id`),
  ADD KEY `franchise_id` (`franchise_id`),
  ADD KEY `old_vehicle_id` (`old_vehicle_id`),
  ADD KEY `new_vehicle_id` (`new_vehicle_id`),
  ADD KEY `approved_by` (`approved_by`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `idx_notifications_user_read` (`user_id`,`is_read`,`created_at`);

--
-- Indexes for table `offices`
--
ALTER TABLE `offices`
  ADD PRIMARY KEY (`office_id`),
  ADD UNIQUE KEY `office_code` (`office_code`),
  ADD UNIQUE KEY `office_name` (`office_name`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `assessment_id` (`assessment_id`),
  ADD KEY `payment_method_id` (`payment_method_id`),
  ADD KEY `verified_by` (`verified_by`),
  ADD KEY `idx_payment_status_date` (`payment_status`,`submitted_at`),
  ADD KEY `idx_payment_reference` (`reference_number`);

--
-- Indexes for table `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD PRIMARY KEY (`payment_method_id`),
  ADD UNIQUE KEY `method_name` (`method_name`);

--
-- Indexes for table `renewal_applications`
--
ALTER TABLE `renewal_applications`
  ADD PRIMARY KEY (`renewal_id`),
  ADD UNIQUE KEY `application_number` (`application_number`),
  ADD KEY `reviewed_by` (`reviewed_by`),
  ADD KEY `idx_renewal_status_date` (`status`,`submitted_at`),
  ADD KEY `idx_renewal_franchise` (`franchise_id`,`submitted_at`);

--
-- Indexes for table `renewal_documents`
--
ALTER TABLE `renewal_documents`
  ADD PRIMARY KEY (`renewal_document_id`),
  ADD KEY `document_type_id` (`document_type_id`),
  ADD KEY `verified_by` (`verified_by`),
  ADD KEY `idx_rd_renewal_status` (`renewal_id`,`verification_status`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `role_name` (`role_name`);

--
-- Indexes for table `transfer_documents`
--
ALTER TABLE `transfer_documents`
  ADD PRIMARY KEY (`transfer_document_id`),
  ADD KEY `document_type_id` (`document_type_id`),
  ADD KEY `verified_by` (`verified_by`),
  ADD KEY `idx_td_transfer_status` (`transfer_id`,`verification_status`);

--
-- Indexes for table `transfer_history`
--
ALTER TABLE `transfer_history`
  ADD PRIMARY KEY (`transfer_history_id`),
  ADD UNIQUE KEY `transfer_id` (`transfer_id`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `idx_th_franchise_date` (`franchise_id`,`effective_date`),
  ADD KEY `idx_th_previous_owner` (`previous_owner_id`),
  ADD KEY `idx_th_new_owner` (`new_owner_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `idx_users_status` (`account_status`),
  ADD KEY `idx_users_office_role` (`office_id`,`role_id`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`vehicle_id`),
  ADD UNIQUE KEY `motor_number` (`motor_number`),
  ADD UNIQUE KEY `chassis_number` (`chassis_number`),
  ADD UNIQUE KEY `plate_number` (`plate_number`),
  ADD KEY `idx_vehicles_or_cr` (`or_number`,`cr_number`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `activity_log_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `assessments`
--
ALTER TABLE `assessments`
  MODIFY `assessment_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `assessment_items`
--
ALTER TABLE `assessment_items`
  MODIFY `assessment_item_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `document_types`
--
ALTER TABLE `document_types`
  MODIFY `document_type_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `drivers`
--
ALTER TABLE `drivers`
  MODIFY `driver_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fee_types`
--
ALTER TABLE `fee_types`
  MODIFY `fee_type_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `franchisees`
--
ALTER TABLE `franchisees`
  MODIFY `franchisee_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `franchises`
--
ALTER TABLE `franchises`
  MODIFY `franchise_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `franchise_documents`
--
ALTER TABLE `franchise_documents`
  MODIFY `franchise_document_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `franchise_drivers`
--
ALTER TABLE `franchise_drivers`
  MODIFY `franchise_driver_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `franchise_transfers`
--
ALTER TABLE `franchise_transfers`
  MODIFY `transfer_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `franchise_vehicles`
--
ALTER TABLE `franchise_vehicles`
  MODIFY `franchise_vehicle_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `motor_change_applications`
--
ALTER TABLE `motor_change_applications`
  MODIFY `motor_change_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `motor_change_history`
--
ALTER TABLE `motor_change_history`
  MODIFY `motor_change_history_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `offices`
--
ALTER TABLE `offices`
  MODIFY `office_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment_methods`
--
ALTER TABLE `payment_methods`
  MODIFY `payment_method_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `renewal_applications`
--
ALTER TABLE `renewal_applications`
  MODIFY `renewal_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `renewal_documents`
--
ALTER TABLE `renewal_documents`
  MODIFY `renewal_document_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transfer_documents`
--
ALTER TABLE `transfer_documents`
  MODIFY `transfer_document_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transfer_history`
--
ALTER TABLE `transfer_history`
  MODIFY `transfer_history_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `vehicle_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `activity_logs_ibfk_2` FOREIGN KEY (`office_id`) REFERENCES `offices` (`office_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `assessments`
--
ALTER TABLE `assessments`
  ADD CONSTRAINT `assessments_ibfk_1` FOREIGN KEY (`renewal_id`) REFERENCES `renewal_applications` (`renewal_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `assessments_ibfk_2` FOREIGN KEY (`assessed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `assessment_items`
--
ALTER TABLE `assessment_items`
  ADD CONSTRAINT `fk_assessment_items_assessment` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`assessment_id`),
  ADD CONSTRAINT `fk_assessment_items_fee_type` FOREIGN KEY (`fee_type_id`) REFERENCES `fee_types` (`fee_type_id`);

--
-- Constraints for table `franchisees`
--
ALTER TABLE `franchisees`
  ADD CONSTRAINT `franchisees_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `franchises`
--
ALTER TABLE `franchises`
  ADD CONSTRAINT `franchises_ibfk_1` FOREIGN KEY (`franchisee_id`) REFERENCES `franchisees` (`franchisee_id`) ON UPDATE CASCADE;

--
-- Constraints for table `franchise_documents`
--
ALTER TABLE `franchise_documents`
  ADD CONSTRAINT `franchise_documents_ibfk_1` FOREIGN KEY (`franchise_id`) REFERENCES `franchises` (`franchise_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `franchise_documents_ibfk_2` FOREIGN KEY (`document_type_id`) REFERENCES `document_types` (`document_type_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `franchise_documents_ibfk_3` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `franchise_documents_ibfk_4` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `franchise_drivers`
--
ALTER TABLE `franchise_drivers`
  ADD CONSTRAINT `franchise_drivers_ibfk_1` FOREIGN KEY (`franchise_id`) REFERENCES `franchises` (`franchise_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `franchise_drivers_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`driver_id`) ON UPDATE CASCADE;

--
-- Constraints for table `franchise_transfers`
--
ALTER TABLE `franchise_transfers`
  ADD CONSTRAINT `franchise_transfers_ibfk_1` FOREIGN KEY (`franchise_id`) REFERENCES `franchises` (`franchise_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `franchise_transfers_ibfk_2` FOREIGN KEY (`old_franchisee_id`) REFERENCES `franchisees` (`franchisee_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `franchise_transfers_ibfk_3` FOREIGN KEY (`new_franchisee_id`) REFERENCES `franchisees` (`franchisee_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `franchise_transfers_ibfk_4` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `franchise_transfers_ibfk_5` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `franchise_vehicles`
--
ALTER TABLE `franchise_vehicles`
  ADD CONSTRAINT `franchise_vehicles_ibfk_1` FOREIGN KEY (`franchise_id`) REFERENCES `franchises` (`franchise_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `franchise_vehicles_ibfk_2` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON UPDATE CASCADE;

--
-- Constraints for table `motor_change_applications`
--
ALTER TABLE `motor_change_applications`
  ADD CONSTRAINT `motor_change_applications_ibfk_1` FOREIGN KEY (`franchise_id`) REFERENCES `franchises` (`franchise_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `motor_change_applications_ibfk_2` FOREIGN KEY (`old_vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `motor_change_applications_ibfk_3` FOREIGN KEY (`new_vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `motor_change_applications_ibfk_4` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `motor_change_applications_ibfk_5` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `motor_change_history`
--
ALTER TABLE `motor_change_history`
  ADD CONSTRAINT `motor_change_history_ibfk_1` FOREIGN KEY (`motor_change_id`) REFERENCES `motor_change_applications` (`motor_change_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `motor_change_history_ibfk_2` FOREIGN KEY (`franchise_id`) REFERENCES `franchises` (`franchise_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `motor_change_history_ibfk_3` FOREIGN KEY (`old_vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `motor_change_history_ibfk_4` FOREIGN KEY (`new_vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `motor_change_history_ibfk_5` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`assessment_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`payment_method_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `payments_ibfk_3` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `renewal_applications`
--
ALTER TABLE `renewal_applications`
  ADD CONSTRAINT `renewal_applications_ibfk_1` FOREIGN KEY (`franchise_id`) REFERENCES `franchises` (`franchise_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `renewal_applications_ibfk_2` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `renewal_documents`
--
ALTER TABLE `renewal_documents`
  ADD CONSTRAINT `renewal_documents_ibfk_1` FOREIGN KEY (`renewal_id`) REFERENCES `renewal_applications` (`renewal_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `renewal_documents_ibfk_2` FOREIGN KEY (`document_type_id`) REFERENCES `document_types` (`document_type_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `renewal_documents_ibfk_3` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `transfer_documents`
--
ALTER TABLE `transfer_documents`
  ADD CONSTRAINT `transfer_documents_ibfk_1` FOREIGN KEY (`transfer_id`) REFERENCES `franchise_transfers` (`transfer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transfer_documents_ibfk_2` FOREIGN KEY (`document_type_id`) REFERENCES `document_types` (`document_type_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `transfer_documents_ibfk_3` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `transfer_history`
--
ALTER TABLE `transfer_history`
  ADD CONSTRAINT `transfer_history_ibfk_1` FOREIGN KEY (`transfer_id`) REFERENCES `franchise_transfers` (`transfer_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `transfer_history_ibfk_2` FOREIGN KEY (`franchise_id`) REFERENCES `franchises` (`franchise_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `transfer_history_ibfk_3` FOREIGN KEY (`previous_owner_id`) REFERENCES `franchisees` (`franchisee_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `transfer_history_ibfk_4` FOREIGN KEY (`new_owner_id`) REFERENCES `franchisees` (`franchisee_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `transfer_history_ibfk_5` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`office_id`) REFERENCES `offices` (`office_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `users_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- TriTrack starter accounts for local development.
INSERT IGNORE INTO `offices` (`office_id`,`office_code`,`office_name`,`description`,`is_active`) VALUES
(1,'BPLO','Business Permits and Licensing Office','TriTrack BPLO office',1),
(2,'TREASURY','Municipal Treasury','TriTrack treasury office',1);
INSERT IGNORE INTO `roles` (`role_id`,`role_name`,`description`) VALUES
(1,'staff_admin','BPLO staff or administrator'),
(2,'treasury','Treasury staff'),
(3,'franchisee','Franchise owner');
INSERT IGNORE INTO `users` (`id`,`office_id`,`role_id`,`name`,`username`,`mobile_number`,`password`,`account_status`) VALUES
(1,1,1,'Sean Ivan Ramiscal','seanivan',NULL,SHA2('ramiscal',256),'active'),
(2,2,2,'Czyen Aceveda','czyen',NULL,SHA2('aceveda',256),'active');
CREATE TABLE IF NOT EXISTS `otp_verifications` (`otp_id` bigint unsigned NOT NULL AUTO_INCREMENT,`mobile_number` varchar(20) NOT NULL,`otp_hash` varchar(64) NOT NULL,`expires_at` datetime NOT NULL,`verified_at` datetime DEFAULT NULL,PRIMARY KEY (`otp_id`),KEY `idx_otp_mobile` (`mobile_number`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT IGNORE INTO `payment_methods` (`payment_method_id`,`method_name`,`description`,`is_active`) VALUES
(1,'GCash','Electronic wallet payment',1),(2,'Bank transfer','Municipal bank transfer',1),(3,'Over the counter','Treasury counter payment',1);
