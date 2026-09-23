-- everyWEAR 회원가입 경로용 최소 recovery migration
-- 적용 대상: everywear_recovery DB
-- UserDAO의 위치 기반 INSERT/SELECT 계약을 위해 컬럼 순서를 유지한다.

USE everywear_recovery;

-- 소셜 계정은 비밀번호를 저장하지 않으므로 NULL을 허용한다.
ALTER TABLE `user`
  MODIFY COLUMN `user_pwd` varchar(100) NULL;

-- UserDAO.insertAddr()와 UserAddrDTO가 기대하는 9개 컬럼 순서다.
CREATE TABLE `user_address` (
  `addr_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `user_type` varchar(10) NOT NULL,
  `addr_zipcode` varchar(10) NOT NULL,
  `addr_road` varchar(100) NOT NULL,
  `addr_detail` varchar(100) NULL,
  `addr_isDefault` char(5) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `addr_label` varchar(100) NOT NULL,
  PRIMARY KEY (`addr_id`),
  KEY `idx_user_address_user` (`user_id`, `user_type`),
  CONSTRAINT `fk_recovery_user_address_user`
    FOREIGN KEY (`user_id`, `user_type`)
    REFERENCES `user` (`user_id`, `user_type`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
