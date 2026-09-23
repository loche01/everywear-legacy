-- everyWEAR 최소 실행용 스키마
-- 원본 TABLE.sql을 수정하지 않고 다음 경로만 검증한다.
-- main.jsp -> DB 연결 -> 일반 로그인 -> 상품 목록/상세

CREATE DATABASE IF NOT EXISTS everywear_recovery
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE everywear_recovery;

CREATE TABLE IF NOT EXISTS `user` (
  `user_id` varchar(30) NOT NULL,
  `user_pwd` varchar(100) NOT NULL,
  `user_type` varchar(10) NOT NULL,
  `user_account_state` varchar(20) NOT NULL DEFAULT '정상',
  `user_fail_login` int NOT NULL DEFAULT 0,
  `user_lock_state` varchar(5) NOT NULL DEFAULT 'N',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `user_type`),
  KEY `idx_user_id` (`user_id`)
);

CREATE TABLE IF NOT EXISTS `user_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `user_type` varchar(10) NOT NULL,
  `log_date` datetime NOT NULL,
  `log_type` varchar(30) NOT NULL,
  `log_ip` varchar(45) NOT NULL,
  PRIMARY KEY (`log_id`),
  KEY `idx_user_log_user` (`user_id`, `user_type`)
);

-- Lee ProductDAO는 SELECT * 결과의 2번째 컬럼을 p_category로 읽는다.
-- 원본 TABLE.sql의 미사용 p_code는 이 최소 스키마에서 제외한다.
CREATE TABLE IF NOT EXISTS `product` (
  `p_id` int NOT NULL AUTO_INCREMENT,
  `p_category` varchar(20),
  `p_name` varchar(100),
  `p_price` int,
  `p_disc` int,
  `p_text` text,
  `p_color` varchar(30),
  `created_at` datetime,
  PRIMARY KEY (`p_id`),
  KEY `idx_product_category` (`p_category`)
);

CREATE TABLE IF NOT EXISTS `product_detail` (
  `pd_id` int NOT NULL AUTO_INCREMENT,
  `p_id` int NOT NULL,
  `pd_size` varchar(10) NOT NULL,
  `pd_stock` int NOT NULL,
  PRIMARY KEY (`pd_id`),
  KEY `idx_product_detail_product` (`p_id`)
);

CREATE TABLE IF NOT EXISTS `product_image` (
  `pi_id` int NOT NULL AUTO_INCREMENT,
  `p_id` int NOT NULL,
  `pi_url` varchar(255),
  `pi_orders` int DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`pi_id`),
  KEY `idx_product_image_product` (`p_id`, `pi_orders`)
);

-- pdDetail.jsp가 상품 Q&A를 조회하므로 빈 테이블이라도 필요하다.
CREATE TABLE IF NOT EXISTS `inquiry` (
  `i_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `user_type` varchar(10) NOT NULL,
  `p_id` int,
  `o_id` int,
  `i_title` varchar(100) NOT NULL,
  `i_content` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `i_isPrivate` char(1) DEFAULT 'N',
  `i_status` varchar(20) DEFAULT '답변대기',
  PRIMARY KEY (`i_id`),
  KEY `idx_inquiry_product` (`p_id`)
);

-- 로컬 smoke test 전용 계정이다. 운영 자격 증명으로 사용하지 않는다.
INSERT INTO `user`
  (`user_id`, `user_pwd`, `user_type`, `user_account_state`, `user_fail_login`, `user_lock_state`)
VALUES
  ('recovery_user', 'recovery_test_only', '일반', '정상', 0, 'N')
ON DUPLICATE KEY UPDATE `user_pwd` = VALUES(`user_pwd`);
