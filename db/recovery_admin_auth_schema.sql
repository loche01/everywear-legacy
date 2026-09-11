-- everyWEAR 관리자 인증용 최소 recovery migration
-- 적용 대상: 격리 everywear_recovery DB (localhost:3307)
-- 실제 관리자 계정이나 credential fixture는 포함하지 않는다.

USE everywear_recovery;

CREATE TABLE `admin` (
  `admin_id` varchar(20) NOT NULL,
  `admin_pwd` varchar(100) NOT NULL,
  `admin_name` varchar(10) NOT NULL,
  `admin_roll` varchar(10) NOT NULL,
  `admin_email` varchar(30) NOT NULL,
  `admin_fail_login` int NOT NULL DEFAULT 0,
  `admin_lock_state` varchar(5) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `admin_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `admin_id` varchar(20) NOT NULL,
  `log_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `log_type` varchar(20) NOT NULL,
  `log_ip` varchar(45) NOT NULL,
  PRIMARY KEY (`log_id`),
  KEY `idx_admin_log_admin_id` (`admin_id`),
  CONSTRAINT `fk_recovery_admin_log_admin`
    FOREIGN KEY (`admin_id`)
    REFERENCES `admin` (`admin_id`)
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
