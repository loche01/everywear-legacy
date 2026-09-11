CREATE TABLE `user` (
  `user_id` varchar(30) PRIMARY KEY NOT NULL,
  `user_pwd` varchar(100),
  `user_type` varchar(10) NOT NULL,
  `user_name` varchar(10),
  `user_birth` varchar(15),
  `user_gender` varchar(10),
  `user_height` int,
  `user_weight` int,
  `user_email` varchar(30),
  `created_at` datetime NOT NULL,
  `user_phone` varchar(15),
  `user_account_state` varchar(20),
  `user_wd_date` datetime,
  `user_wd_reason` varchar(30),
  `user_wd_detail_reason` varchar(100),
  `user_fail_login` int NOT NULL DEFAULT 0,
  `user_lock_state` varchar(5) NOT NULL,
  `user_marketing_state` varchar(5) NOT NULL,
  `user_point` int NOT NULL DEFAULT 0,
  `user_rank` varchar(10) DEFAULT '그린'
);

CREATE TABLE `user_log` (
  `log_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `log_date` datetime NOT NULL,
  `log_type` varchar(10) NOT NULL,
  `log_ip` varchar(20) NOT NULL
);

CREATE TABLE `user_address` (
  `addr_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `user_type` varchar(10) NOT NULL,
  `addr_zipcode` varchar(10) NOT NULL,
  `addr_road` varchar(100) NOT NULL,
  `addr_detail` varchar(100),
  `addr_isDefault` char(5) NOT NULL,
  `created_at` datetime NOT NULL,
  `addr_label` varchar(100) NOT NULL
);

CREATE TABLE `admin` (
  `admin_id` varchar(20) PRIMARY KEY NOT NULL,
  `admin_pwd` varchar(100) NOT NULL,
  `admin_name` varchar(10) NOT NULL,
  `admin_roll` varchar(10) NOT NULL,
  `admin_email` varchar(30) NOT NULL,
  `admin_fail_login` int NOT NULL DEFAULT 0,
  `admin_lock_state` varchar(5) NOT NULL
);

CREATE TABLE `admin_log` (
  `log_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `admin_id` varchar(20) NOT NULL,
  `log_date` datetime NOT NULL,
  `log_type` varchar(10) NOT NULL,
  `log_ip` varchar(20) NOT NULL
);

CREATE TABLE `coupon` (
  `cp_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `cp_name` varchar(20) NOT NULL,
  `cp_type` varchar(5) NOT NULL,
  `cp_price` int NOT NULL,
  `cp_start` varchar(20) NOT NULL,
  `cp_end` varchar(20) NOT NULL,
  `cp_usable_state` varchar(5) NOT NULL,
  `cp_min_price` int NOT NULL,
  `cp_user_rank` int
);

CREATE TABLE `user_coupon` (
  `user_cp_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `user_type` varchar(10) NOT NULL,
  `cp_id` int NOT NULL,
  `cp_provide_date` datetime NOT NULL,
  `cp_using_date` datetime,
  `cp_using_state` varchar(5) NOT NULL
);

CREATE TABLE `category` (
  `category_name` varchar(20) PRIMARY KEY NOT NULL,
  `top_category` varchar(20)
);

CREATE TABLE `product` (
  `p_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `p_code` varchar(10),
  `p_category` varchar(20),
  `p_name` varchar(50),
  `p_price` int,
  `p_disc` int,
  `p_text` text,
  `p_color` varchar(20),
  `created_at` datetime
);

CREATE TABLE `product_detail` (
  `pd_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `p_id` int NOT NULL,
  `pd_size` varchar(10) NOT NULL,
  `pd_stock` int NOT NULL
);

CREATE TABLE `product_image` (
  `pi_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `p_id` int NOT NULL,
  `pi_url` varchar(255),
  `pi_orders` int DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `orders` (
  `o_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `pd_id` int NOT NULL,
  `o_num` varchar(20) NOT NULL,
  `o_isMember` char(5) NOT NULL,
  `o_name` varchar(50) NOT NULL,
  `o_phone` varchar(15) NOT NULL,
  `o_quantity` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  `o_total_amount` int NOT NULL,
  `pay_id` int,
  `rf_id` int
);

CREATE TABLE `payment` (
  `pay_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `pay_status` varchar(10) NOT NULL,
  `paid_at` datetime,
  `pay_trans_id` varchar(100),
  `pay_appr_code` varchar(50),
  `pay_card_com` varchar(50),
  `pay_req_id` varchar(100) UNIQUE NOT NULL
);

CREATE TABLE `refund` (
  `rf_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `rf_amount` int NOT NULL,
  `rf_quantity` int NOT NULL,
  `rf_reason_code` varchar(20) NOT NULL,
  `rf_reason_text` text,
  `refunded_at` datetime,
  `admin_id` varchar(20),
  `rf_status` varchar(20) NOT NULL
);

CREATE TABLE `delivery` (
  `d_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `o_id` int NOT NULL,
  `d_name` varchar(20),
  `recv_name` varchar(10) NOT NULL,
  `recv_phone` varchar(15) NOT NULL,
  `recv_zipcode` varchar(10) NOT NULL,
  `recv_addr_road` varchar(100) NOT NULL,
  `recv_addr_detail` varchar(100) NOT NULL,
  `d_status` varchar(20) NOT NULL,
  `d_courier` varchar(20),
  `d_tracking_num` varchar(50),
  `shipped_at` datetime,
  `started_at` datetime,
  `completed_at` datetime,
  `d_memo` varchar(100)
);

CREATE TABLE `favorite` (
  `f_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `pd_id` int NOT NULL,
  `f_type` varchar(10) NOT NULL,
  `f_quantity` int DEFAULT 1,
  `created_at` datetime NOT NULL
);

CREATE TABLE `notification` (
  `notifi_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `o_id` int,
  `notifi_title` varchar(100) NOT NULL,
  `notifi_content` text NOT NULL,
  `notified_at` datetime NOT NULL,
  `notifi_isRead` char(1) NOT NULL DEFAULT 'N'
);

CREATE TABLE `review` (
  `r_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `pd_id` int NOT NULL,
  `r_content` text NOT NULL,
  `r_rating` int NOT NULL,
  `r_heart` int,
  `created_at` datetime NOT NULL,
  `updated_at` datetime,
  `r_report_count` int DEFAULT 0,
  `r_isHidden` char(5) DEFAULT 'N'
);

CREATE TABLE `review_image` (
  `ri_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `r_id` int NOT NULL,
  `ri_url` varchar(255) NOT NULL,
  `ri_sort_orders` int DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT (CURRENT_DATE)
);

CREATE TABLE `review_comment` (
  `rc_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `r_id` int NOT NULL,
  `rc_author_id` varchar(30) NOT NULL,
  `rc_author_type` varchar(10) NOT NULL,
  `rc_content` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (CURRENT_DATE),
  `updated_at` datetime,
  `rc_isDeleted` char(1) NOT NULL DEFAULT 'N'
);

CREATE TABLE `review_report` (
  `rr_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `rr_target_id` int NOT NULL,
  `rr_target_type` varchar(10) NOT NULL,
  `rr_reason_code` varchar(20) NOT NULL,
  `rr_reason_text` text,
  `reported_at` datetime NOT NULL DEFAULT (CURRENT_DATE),
  `admin_id` varchar(20),
  `proc_at` datetime,
  `proc_state` varchar(10) DEFAULT '처리 대기'
);

CREATE TABLE `notice` (
  `noti_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `admin_id` varchar(30) NOT NULL,
  `noti_title` varchar(100) NOT NULL,
  `noti_content` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (CURRENT_DATE),
  `noti_views` int DEFAULT 0,
  `noti_isPinned` char(1) DEFAULT 'N'
);

CREATE TABLE `inquiry` (
  `i_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `user_type` varchar(10) NOT NULL,
  `p_id` int,
  `o_id` int,
  `i_title` varchar(100) NOT NULL,
  `i_content` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (CURRENT_DATE),
  `i_isPrivate` char(1) DEFAULT 'N',
  `i_status` varchar(20) DEFAULT '답변대기'
);

CREATE TABLE `inquiry_image` (
  `ii_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `i_id` int NOT NULL,
  `ii_url` varchar(255) NOT NULL,
  `uploaded_at` datetime NOT NULL DEFAULT (CURRENT_DATE)
);

CREATE TABLE `inquiry_reply` (
  `ir_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `i_id` int NOT NULL,
  `admin_id` varchar(30) NOT NULL,
  `ir_content` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (CURRENT_DATE)
);

CREATE TABLE `event` (
  `e_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `e_title` varchar(100) NOT NULL,
  `e_type` varchar(10) NOT NULL,
  `e_image_url` varchar(255),
  `e_link_url` varchar(255),
  `e_start` datetime NOT NULL,
  `e_end` datetime NOT NULL,
  `e_isActive` char(1) NOT NULL DEFAULT 'Y'
);

CREATE TABLE `faq` (
  `faq_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `faq_title` varchar(50) NOT NULL,
  `faq_content` text NOT NULL
);

CREATE UNIQUE INDEX `favorite_index_0` ON `favorite` (`user_id`, `pd_id`, `f_type`);

CREATE UNIQUE INDEX `review_report_index_1` ON `review_report` (`user_id`, `rr_target_id`, `rr_target_type`);

ALTER TABLE `user_log` COMMENT = 'log_type은 로그인, 로그인 시도, 로그아웃 중 하나의 값';

ALTER TABLE `admin_log` COMMENT = 'log_type은 로그인, 로그인 시도, 로그아웃 중 하나의 값';

ALTER TABLE `user_log` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `user_address` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `user_address` ADD FOREIGN KEY (`user_type`) REFERENCES `user` (`user_id`);

ALTER TABLE `admin_log` ADD FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`);

ALTER TABLE `user_coupon` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `user_coupon` ADD FOREIGN KEY (`user_type`) REFERENCES `user` (`user_id`);

ALTER TABLE `user_coupon` ADD FOREIGN KEY (`cp_id`) REFERENCES `coupon` (`cp_id`);

ALTER TABLE `category` ADD FOREIGN KEY (`top_category`) REFERENCES `category` (`category_name`);

ALTER TABLE `product` ADD FOREIGN KEY (`p_category`) REFERENCES `category` (`category_name`);

ALTER TABLE `product_detail` ADD FOREIGN KEY (`p_id`) REFERENCES `product` (`p_id`);

ALTER TABLE `product_image` ADD FOREIGN KEY (`p_id`) REFERENCES `product` (`p_id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`pd_id`) REFERENCES `product_detail` (`pd_id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`pay_id`) REFERENCES `payment` (`pay_id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`rf_id`) REFERENCES `refund` (`rf_id`);

ALTER TABLE `payment` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `refund` ADD FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`);

ALTER TABLE `delivery` ADD FOREIGN KEY (`o_id`) REFERENCES `orders` (`o_id`);

ALTER TABLE `favorite` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `favorite` ADD FOREIGN KEY (`pd_id`) REFERENCES `product_detail` (`pd_id`);

ALTER TABLE `notification` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `notification` ADD FOREIGN KEY (`o_id`) REFERENCES `orders` (`o_id`);

ALTER TABLE `review` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `review` ADD FOREIGN KEY (`pd_id`) REFERENCES `product_detail` (`pd_id`);

ALTER TABLE `review_image` ADD FOREIGN KEY (`r_id`) REFERENCES `review` (`r_id`);

ALTER TABLE `review_comment` ADD FOREIGN KEY (`r_id`) REFERENCES `review` (`r_id`);

ALTER TABLE `review_report` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `review_report` ADD FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`);

ALTER TABLE `notice` ADD FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`);

ALTER TABLE `inquiry` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `inquiry` ADD FOREIGN KEY (`user_type`) REFERENCES `user` (`user_type`);

ALTER TABLE `inquiry` ADD FOREIGN KEY (`p_id`) REFERENCES `product` (`p_id`);

ALTER TABLE `inquiry` ADD FOREIGN KEY (`o_id`) REFERENCES `orders` (`o_id`);

ALTER TABLE `inquiry_image` ADD FOREIGN KEY (`i_id`) REFERENCES `inquiry` (`i_id`);

ALTER TABLE `inquiry_reply` ADD FOREIGN KEY (`i_id`) REFERENCES `inquiry` (`i_id`);

ALTER TABLE `inquiry_reply` ADD FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`);
