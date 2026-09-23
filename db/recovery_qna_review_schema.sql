-- everyWEAR Q&A/리뷰 첨부 경로용 최소 recovery migration
-- 적용 대상: everywear_recovery DB
-- 원본 TABLE.sql은 수정하지 않는다.
-- 선행 migration: recovery_minimal.sql(user, inquiry, product_detail),
--   recovery_cart_schema.sql / recovery_signup_schema.sql(user 보강),
--   recovery_admin_auth_schema.sql(admin) 적용 이후에 실행한다.
--
-- 사용자 Q&A/리뷰 기능 검증을 통과한 테이블 정의를 그대로 옮긴 것이다.
-- 컬럼 순서/타입/NULL/기본값/PK/FK/인덱스를 추측하거나 재설계하지 않는다.
-- 원본 TABLE.sql 대비 복구 시 확정된 차이만 반영한다:
--   review 는 미사용 r_heart 를 제외하고, user 복합 PK(user_id,user_type)에 맞춰
--   user_type 컬럼과 복합 FK 를 가진다. inquiry_reply.admin_id 는 admin.admin_id 와
--   같은 varchar(20) 이다. 첨부/답변 자식 테이블은 부모 삭제 시 ON DELETE CASCADE 다.
-- 이 4개 테이블의 FK 는 검증된 스키마에서 이름 없이 생성되어 MySQL 기본 이름
--   (테이블명 뒤에 _ibfk_N 이 붙는 형식)을 가진다. SHOW CREATE TABLE 및 스키마 digest
--   동일성을 위해 다른 db/ recovery migration 의 fk_recovery_* 명명 규칙과 ON UPDATE 절은
--   이 파일에서는 적용하지 않는다.
-- review_comment / review_report 는 이번 복구 범위가 아니므로 만들지 않는다.
-- credential/fixture/seed 는 포함하지 않는다.

USE everywear_recovery;

-- QnaDAO 는 소유권 확인 후 생성된 부모 i_id 로 첨부 이미지를 연결한다.
CREATE TABLE `inquiry_image` (
  `ii_id` int NOT NULL AUTO_INCREMENT,
  `i_id` int NOT NULL,
  `ii_url` varchar(255) NOT NULL,
  `uploaded_at` datetime NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`ii_id`),
  KEY `idx_inquiry_image_parent` (`i_id`),
  FOREIGN KEY (`i_id`)
    REFERENCES `inquiry` (`i_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 관리자 답변. 사용자 mutation 은 아니지만 inquiry 삭제 시 함께 정리되는 자식 테이블이다.
CREATE TABLE `inquiry_reply` (
  `ir_id` int NOT NULL AUTO_INCREMENT,
  `i_id` int NOT NULL,
  `admin_id` varchar(20) NOT NULL,
  `ir_content` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`ir_id`),
  KEY `idx_inquiry_reply_parent` (`i_id`),
  KEY `idx_inquiry_reply_admin` (`admin_id`),
  FOREIGN KEY (`i_id`)
    REFERENCES `inquiry` (`i_id`)
    ON DELETE CASCADE,
  FOREIGN KEY (`admin_id`)
    REFERENCES `admin` (`admin_id`)
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ReviewDAO/ReviewDTO 는 user_type 을 포함한 10개 컬럼을 위치 기반으로 읽는다.
CREATE TABLE `review` (
  `r_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `user_type` varchar(10) NOT NULL,
  `pd_id` int NOT NULL,
  `r_content` text NOT NULL,
  `r_rating` int NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NULL,
  `r_report_count` int DEFAULT 0,
  `r_isHidden` char(5) DEFAULT 'N',
  PRIMARY KEY (`r_id`),
  KEY `idx_review_user` (`user_id`, `user_type`),
  KEY `idx_review_detail` (`pd_id`),
  FOREIGN KEY (`user_id`, `user_type`)
    REFERENCES `user` (`user_id`, `user_type`)
    ON DELETE RESTRICT,
  FOREIGN KEY (`pd_id`)
    REFERENCES `product_detail` (`pd_id`)
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 리뷰 첨부 이미지. r_id 로 부모 review 를 참조하며 부모 삭제 시 함께 제거된다.
CREATE TABLE `review_image` (
  `ri_id` int NOT NULL AUTO_INCREMENT,
  `r_id` int NOT NULL,
  `ri_url` varchar(255) NOT NULL,
  `ri_sort_orders` int DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`ri_id`),
  KEY `idx_review_image_parent_sort` (`r_id`, `ri_sort_orders`),
  FOREIGN KEY (`r_id`)
    REFERENCES `review` (`r_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
