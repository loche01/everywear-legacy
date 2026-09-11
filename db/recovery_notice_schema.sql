-- PHASE 5B: 격리 everywear_recovery 전용. 승인 후에만 별도로 적용한다.
-- recovery_admin_auth_schema.sql 이후 적용. 계정/fixture/category는 포함하지 않는다.
-- NoticeDAO의 SELECT * 위치 기반 읽기와 호환되도록 컬럼 순서를 유지한다.
USE `everywear_recovery`;

CREATE TABLE `notice` (
  `noti_id` int NOT NULL AUTO_INCREMENT,
  `admin_id` varchar(20) NOT NULL,
  `noti_title` varchar(100) NOT NULL,
  `noti_content` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `noti_views` int NOT NULL DEFAULT 0,
  `noti_isPinned` char(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`noti_id`),
  KEY `idx_notice_admin` (`admin_id`),
  KEY `idx_notice_pinned_created` (`noti_isPinned`, `created_at`),
  CONSTRAINT `fk_notice_admin` FOREIGN KEY (`admin_id`)
    REFERENCES `admin` (`admin_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_notice_pinned` CHECK (`noti_isPinned` IN ('Y', 'N'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
