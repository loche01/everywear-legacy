-- everyWEAR Lee 기준선 cart 경로용 recovery migration
-- 적용 대상: 격리 everywear_recovery DB (localhost:3307)
-- 원본 TABLE.sql은 수정하지 않는다.
-- UserDAO/UserDTO/FavoriteDAO 계약의 SELECT * 컬럼 순서를 보존한다.

USE everywear_recovery;

-- UserDAO.getOneUser()와 UserDTO 생성자가 기대하는 20개 컬럼 순서로 보강한다.
-- 기존 smoke-test 사용자의 식별자/비밀번호/로그인 상태/생성일은 유지된다.
ALTER TABLE `user`
  ADD COLUMN `user_name` varchar(10) NOT NULL DEFAULT '복구사용자' AFTER `user_type`,
  ADD COLUMN `user_birth` varchar(15) NULL AFTER `user_name`,
  ADD COLUMN `user_gender` varchar(10) NULL AFTER `user_birth`,
  ADD COLUMN `user_height` int NOT NULL DEFAULT 0 AFTER `user_gender`,
  ADD COLUMN `user_weight` int NOT NULL DEFAULT 0 AFTER `user_height`,
  ADD COLUMN `user_email` varchar(30) NULL AFTER `user_weight`,
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `user_email`,
  ADD COLUMN `user_phone` varchar(15) NULL AFTER `created_at`,
  MODIFY COLUMN `user_account_state` varchar(20) NOT NULL DEFAULT '정상' AFTER `user_phone`,
  ADD COLUMN `user_wd_date` datetime NULL AFTER `user_account_state`,
  ADD COLUMN `user_wd_reason` varchar(30) NULL AFTER `user_wd_date`,
  ADD COLUMN `user_wd_detail_reason` varchar(100) NULL AFTER `user_wd_reason`,
  MODIFY COLUMN `user_fail_login` int NOT NULL DEFAULT 0 AFTER `user_wd_detail_reason`,
  MODIFY COLUMN `user_lock_state` varchar(5) NOT NULL DEFAULT 'N' AFTER `user_fail_login`,
  ADD COLUMN `user_marketing_state` varchar(5) NOT NULL DEFAULT 'N' AFTER `user_lock_state`,
  ADD COLUMN `user_point` int NOT NULL DEFAULT 0 AFTER `user_marketing_state`,
  ADD COLUMN `user_rank` varchar(10) NOT NULL DEFAULT '그린' AFTER `user_point`;

-- cart2.jsp는 미사용 쿠폰 수만 조회한다. 컬럼 순서는 UserCouponDTO/CouponDAO 계약과 맞춘다.
-- coupon/admin 기능 전체를 복구하지 않으므로 해당 테이블 FK는 이번 migration에서 만들지 않는다.
CREATE TABLE `user_coupon` (
  `user_cp_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `user_type` varchar(10) NOT NULL,
  `cp_id` int NULL,
  `admin_id` varchar(30) NULL,
  `cp_provide_date` datetime NULL,
  `cp_using_date` datetime NULL,
  `cp_using_state` varchar(5) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`user_cp_id`),
  KEY `idx_user_coupon_user` (`user_id`, `user_type`),
  CONSTRAINT `fk_recovery_user_coupon_user`
    FOREIGN KEY (`user_id`, `user_type`)
    REFERENCES `user` (`user_id`, `user_type`)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- FavoriteDAO/FavoriteDTO는 user_type을 포함한 7개 컬럼을 위치 기반으로 읽는다.
CREATE TABLE `favorite` (
  `f_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `user_type` varchar(10) NOT NULL,
  `pd_id` int NOT NULL,
  `f_type` varchar(10) NOT NULL,
  `f_quantity` int NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`f_id`),
  KEY `idx_favorite_user_type` (`user_id`, `user_type`, `f_type`),
  KEY `idx_favorite_product_detail` (`pd_id`),
  CONSTRAINT `fk_recovery_favorite_user`
    FOREIGN KEY (`user_id`, `user_type`)
    REFERENCES `user` (`user_id`, `user_type`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `fk_recovery_favorite_product_detail`
    FOREIGN KEY (`pd_id`)
    REFERENCES `product_detail` (`pd_id`)
    ON UPDATE CASCADE ON DELETE CASCADE
);
