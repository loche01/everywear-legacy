-- 격리 everywear_recovery 전용. 관리자 상품 목록/수정(admin_product_list.jsp, admin_product_edit.jsp)과
-- AdminProductServlet이 읽는 category 테이블과 원본 category seed.
-- recovery_minimal.sql 이후 1회 적용한다. category_name이 PK라 재실행하면 중복 오류가 난다.
-- 테이블 정의는 db/legacy-original/TABLE.sql 의 category 정의와 같다.
-- 아래 INSERT는 db/legacy-original/Category.sql 원본을 수정 없이 그대로 옮긴 것이다(25건).
USE `everywear_recovery`;

CREATE TABLE IF NOT EXISTS `category` (
  `category_name` varchar(20) NOT NULL,
  `top_category` varchar(20),
  PRIMARY KEY (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 대분류 (상위 카테고리만 먼저 삽입)
INSERT INTO category (category_name, top_category) VALUES 
('GLOVES/SOCKS', 'ETC'),
('BELT/NECKLACE', 'ETC'),
('OTHERS', 'ETC');



-- 소분류 (상위 카테고리 지정)
INSERT INTO category (category_name, top_category) VALUES 
('HEAVY OUTER', 'OUTER'),
('JUMPER OUTER', 'OUTER'),
('VEST', 'OUTER'),
('JACKET', 'OUTER'),
('HOODED ZIP-UP', 'OUTER'),
('WIND BREAKER', 'OUTER'),

('HOODIE', 'TOP'),
('SWEAT SHIRT', 'TOP'),
('T-SHIRT', 'TOP'),
('SHIRT', 'TOP'),
('LONG SLEEVE', 'TOP'),
('SLEEVESS', 'TOP'),
('KNIT/CARDIGAN', 'TOP'),

('PANTS', 'BOTTOM'),
('DENIM', 'BOTTOM'),
('SHORTS', 'BOTTOM'),
('TRAINING PANTS', 'BOTTOM'),

('HEADGEAR', 'ACC'),
('BAG', 'ACC'),
('KEYRING', 'ACC'),
('MUFFLER', 'ACC'),
('ETC', 'ACC');