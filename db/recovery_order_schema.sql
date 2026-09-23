-- everyWEAR 주문/결제/환불/배송용 최소 recovery migration
-- 적용 대상: everywear_recovery DB
-- OrderDAO와 DeliveryDAO의 위치 기반 INSERT/SELECT 컬럼 순서를 유지한다.

USE everywear_recovery;

CREATE TABLE `payment` (
  `pay_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NULL,
  `user_type` varchar(10) NULL,
  `pay_status` varchar(10) NOT NULL,
  `paid_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pay_imp_uid` varchar(100) NOT NULL,
  `pay_apply_num` varchar(50) NULL,
  `pay_card_name` varchar(50) NULL,
  PRIMARY KEY (`pay_id`),
  UNIQUE KEY `uq_payment_pay_imp_uid` (`pay_imp_uid`),
  KEY `idx_payment_user` (`user_id`, `user_type`),
  CONSTRAINT `fk_recovery_payment_user`
    FOREIGN KEY (`user_id`, `user_type`)
    REFERENCES `user` (`user_id`, `user_type`)
    ON UPDATE RESTRICT
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `refund` (
  `rf_id` int NOT NULL AUTO_INCREMENT,
  `rf_amount` int NOT NULL,
  `rf_quantity` int NOT NULL,
  `rf_reason_code` varchar(20) NOT NULL,
  `rf_reason_text` text NULL,
  `refunded_at` datetime NULL,
  `admin_id` varchar(20) NULL,
  `rf_status` varchar(20) NOT NULL,
  PRIMARY KEY (`rf_id`),
  KEY `idx_refund_admin` (`admin_id`),
  CONSTRAINT `fk_recovery_refund_admin`
    FOREIGN KEY (`admin_id`)
    REFERENCES `admin` (`admin_id`)
    ON UPDATE RESTRICT
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `orders` (
  `o_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NULL,
  `user_type` varchar(10) NULL,
  `pd_id` int NOT NULL,
  `o_num` varchar(20) NOT NULL,
  `o_isMember` char(5) NOT NULL,
  `o_name` varchar(50) NOT NULL,
  `o_phone` varchar(15) NOT NULL,
  `o_quantity` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `o_total_amount` int NOT NULL,
  `pay_id` int NULL,
  `rf_id` int NULL,
  PRIMARY KEY (`o_id`),
  KEY `idx_orders_user` (`user_id`, `user_type`),
  KEY `idx_orders_product_detail` (`pd_id`),
  KEY `idx_orders_payment` (`pay_id`),
  KEY `idx_orders_refund` (`rf_id`),
  CONSTRAINT `fk_recovery_orders_user`
    FOREIGN KEY (`user_id`, `user_type`)
    REFERENCES `user` (`user_id`, `user_type`)
    ON UPDATE RESTRICT
    ON DELETE RESTRICT,
  CONSTRAINT `fk_recovery_orders_product_detail`
    FOREIGN KEY (`pd_id`)
    REFERENCES `product_detail` (`pd_id`)
    ON UPDATE RESTRICT
    ON DELETE RESTRICT,
  CONSTRAINT `fk_recovery_orders_payment`
    FOREIGN KEY (`pay_id`)
    REFERENCES `payment` (`pay_id`)
    ON UPDATE RESTRICT
    ON DELETE RESTRICT,
  CONSTRAINT `fk_recovery_orders_refund`
    FOREIGN KEY (`rf_id`)
    REFERENCES `refund` (`rf_id`)
    ON UPDATE RESTRICT
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `delivery` (
  `d_id` int NOT NULL AUTO_INCREMENT,
  `o_id` int NOT NULL,
  `d_name` varchar(20) NULL,
  `recv_name` varchar(10) NOT NULL,
  `recv_phone` varchar(15) NOT NULL,
  `recv_zipcode` varchar(10) NOT NULL,
  `recv_addr_road` varchar(100) NOT NULL,
  `recv_addr_detail` varchar(100) NOT NULL,
  `d_status` varchar(20) NOT NULL DEFAULT '배송준비중',
  `d_courier` varchar(20) NULL,
  `d_tracking_num` varchar(50) NULL,
  `shipped_at` datetime NULL,
  `started_at` datetime NULL,
  `completed_at` datetime NULL,
  `d_memo` varchar(100) NULL,
  PRIMARY KEY (`d_id`),
  KEY `idx_delivery_order` (`o_id`),
  CONSTRAINT `fk_recovery_delivery_order`
    FOREIGN KEY (`o_id`)
    REFERENCES `orders` (`o_id`)
    ON UPDATE RESTRICT
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
