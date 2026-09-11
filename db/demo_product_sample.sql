-- everyWEAR 공개용 데모 상품 seed
--
-- 목적: from-scratch 데모/포트폴리오 환경에서 상품 목록·상세 화면을 채우기 위한 것.
-- 전부 자체 제작 합성 데이터이며, 실제 브랜드/상품/가격/이미지와 무관하다.
-- 이미지는 저장소 자체 placeholder(images/product-placeholder.svg)만 사용한다.
--
-- 주의: 이 파일은 docs/db-recovery.md 의 검증된 recovery baseline
--       (product 1518 / product_detail 3513 / product_image 7410) 을 대체하지 않는다.
--       스키마는 db/recovery_minimal.sql 이 먼저 적용되어 있어야 한다.
--
-- 컬럼 순서(product / product_detail)는 ProductDAO 의 SELECT * 위치 인덱스 계약과 일치해야 한다.

-- =========================================================
-- 1) product  (24개)
-- =========================================================
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (1,'T-SHIRT','DEMO BASIC TEE - WHITE',19000,NULL,'SIZE(cm)
S - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
M - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
L - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60

MATERIAL : COTTON 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','WHITE','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (2,'T-SHIRT','DEMO BASIC TEE - BLACK',19000,NULL,'SIZE(cm)
S - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
M - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
L - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60
XL - Length 63 / Shoulder 45 / Chest 51 / Sleeve 61

MATERIAL : COTTON 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','BLACK','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (3,'LONG SLEEVE','DEMO DAILY LONG SLEEVE - GREY',29000,NULL,'SIZE(cm)
M - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
L - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59

MATERIAL : COTTON 95% SPANDEX 5%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','GREY','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (4,'SHIRT','DEMO OXFORD SHIRT - SKYBLUE',49000,NULL,'SIZE(cm)
S - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
M - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
L - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60

MATERIAL : COTTON 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','SKYBLUE','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (5,'HOODIE','DEMO HEAVY HOODIE - CHARCOAL',59000,NULL,'SIZE(cm)
M - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
L - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
XL - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60

MATERIAL : COTTON 80% POLYESTER 20%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','CHARCOAL','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (6,'HOODIE','DEMO HEAVY HOODIE - OATMEAL',59000,NULL,'SIZE(cm)
S - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
M - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
L - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60

MATERIAL : COTTON 80% POLYESTER 20%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','OATMEAL','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (7,'SWEAT SHIRT','DEMO CREW SWEATSHIRT - NAVY',45000,NULL,'SIZE(cm)
M - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
L - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59

MATERIAL : COTTON 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','NAVY','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (8,'KNIT/CARDIGAN','DEMO WOOL KNIT - GREEN',69000,NULL,'SIZE(cm)
M - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
L - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59

MATERIAL : WOOL 60% ACRYLIC 40%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','GREEN','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (9,'KNIT/CARDIGAN','DEMO SHAWL CARDIGAN - BEIGE',79000,NULL,'SIZE(cm)
M - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
L - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59

MATERIAL : WOOL 50% ACRYLIC 50%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','BEIGE','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (10,'JACKET','DEMO LIGHT JACKET - NAVY',109000,NULL,'SIZE(cm)
M - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
L - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
XL - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60

MATERIAL : NYLON 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','NAVY','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (11,'JACKET','DEMO TRUCKER JACKET - INDIGO',99000,NULL,'SIZE(cm)
S - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
M - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
L - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60

MATERIAL : COTTON 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','INDIGO','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (12,'HEAVY OUTER','DEMO PUFFER PARKA - BLACK',199000,NULL,'SIZE(cm)
M - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
L - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
XL - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60

MATERIAL : SHELL NYLON 100% FILLING POLYESTER 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','BLACK','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (13,'WIND BREAKER','DEMO WINDBREAKER - OLIVE',89000,NULL,'SIZE(cm)
M - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
L - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59

MATERIAL : POLYESTER 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','OLIVE','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (14,'PANTS','DEMO WIDE CHINO PANTS - BEIGE',55000,NULL,'SIZE(cm)
28 - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
30 - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
32 - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60
34 - Length 63 / Shoulder 45 / Chest 51 / Sleeve 61

MATERIAL : COTTON 98% SPANDEX 2%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','BEIGE','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (15,'PANTS','DEMO TAPERED SLACKS - CHARCOAL',62000,NULL,'SIZE(cm)
30 - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
32 - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
34 - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60

MATERIAL : POLYESTER 70% RAYON 27% SPANDEX 3%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','CHARCOAL','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (16,'DENIM','DEMO STRAIGHT DENIM - MID BLUE',69000,NULL,'SIZE(cm)
28 - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
30 - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
32 - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60
34 - Length 63 / Shoulder 45 / Chest 51 / Sleeve 61

MATERIAL : COTTON 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','MID BLUE','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (17,'DENIM','DEMO WASHED DENIM - LIGHT BLUE',72000,NULL,'SIZE(cm)
30 - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
32 - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59

MATERIAL : COTTON 99% ELASTANE 1%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','LIGHT BLUE','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (18,'SHORTS','DEMO CARGO SHORTS - OLIVE',39000,NULL,'SIZE(cm)
M - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
L - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
XL - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60

MATERIAL : COTTON 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','OLIVE','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (19,'SHORTS','DEMO SWEAT SHORTS - GREY',32000,NULL,'SIZE(cm)
S - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
M - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
L - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60

MATERIAL : COTTON 90% POLYESTER 10%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','GREY','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (20,'TRAINING PANTS','DEMO JOGGER PANTS - BLACK',46000,NULL,'SIZE(cm)
M - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
L - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59
XL - Length 62 / Shoulder 44 / Chest 50 / Sleeve 60

MATERIAL : COTTON 85% POLYESTER 15%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','BLACK','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (21,'HEADGEAR','DEMO BALL CAP - BLACK',25000,NULL,'SIZE(cm)
57-59 - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
59-61 - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59

MATERIAL : COTTON 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','BLACK','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (22,'HEADGEAR','DEMO BUCKET HAT - IVORY',27000,NULL,'SIZE(cm)
M - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
L - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59

MATERIAL : COTTON 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','IVORY','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (23,'BAG','DEMO DAILY BACKPACK - BLACK',79000,NULL,'SIZE(cm)
STANDARD - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
LARGE - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59

MATERIAL : POLYESTER 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','BLACK','2025-01-02 10:00:00');
INSERT INTO `product` (`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES (24,'MUFFLER','DEMO WOOL MUFFLER - CAMEL',35000,NULL,'SIZE(cm)
FREE - Length 60 / Shoulder 42 / Chest 48 / Sleeve 58
LONG - Length 61 / Shoulder 43 / Chest 49 / Sleeve 59

MATERIAL : WOOL 100%
MADE IN : DEMO

* 데모용 예시 상품입니다. 실제 판매 상품이 아니며, 정보는 임의로 작성되었습니다.','CAMEL','2025-01-02 10:00:00');

-- =========================================================
-- 2) product_detail  (상품당 2~4개, pd_id 는 AUTO_INCREMENT)
-- =========================================================
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (1,'S',60);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (1,'M',80);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (1,'L',50);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (2,'S',40);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (2,'M',70);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (2,'L',65);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (2,'XL',20);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (3,'M',55);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (3,'L',45);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (4,'S',25);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (4,'M',40);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (4,'L',30);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (5,'M',50);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (5,'L',60);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (5,'XL',25);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (6,'S',20);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (6,'M',35);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (6,'L',35);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (7,'M',42);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (7,'L',38);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (8,'M',30);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (8,'L',18);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (9,'M',22);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (9,'L',26);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (10,'M',30);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (10,'L',34);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (10,'XL',12);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (11,'S',18);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (11,'M',28);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (11,'L',24);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (12,'M',26);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (12,'L',30);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (12,'XL',10);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (13,'M',33);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (13,'L',29);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (14,'28',20);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (14,'30',30);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (14,'32',28);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (14,'34',14);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (15,'30',24);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (15,'32',26);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (15,'34',16);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (16,'28',22);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (16,'30',34);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (16,'32',30);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (16,'34',12);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (17,'30',20);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (17,'32',22);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (18,'M',40);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (18,'L',44);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (18,'XL',18);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (19,'S',30);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (19,'M',38);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (19,'L',30);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (20,'M',50);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (20,'L',52);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (20,'XL',22);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (21,'57-59',70);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (21,'59-61',50);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (22,'M',34);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (22,'L',30);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (23,'STANDARD',22);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (23,'LARGE',14);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (24,'FREE',40);
INSERT INTO `product_detail` (`p_id`,`pd_size`,`pd_stock`) VALUES (24,'LONG',18);

-- =========================================================
-- 3) product_image  (상품당 정확히 1개, 저장소 자체 placeholder)
-- =========================================================
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (1,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (2,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (3,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (4,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (5,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (6,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (7,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (8,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (9,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (10,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (11,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (12,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (13,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (14,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (15,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (16,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (17,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (18,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (19,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (20,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (21,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (22,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (23,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
INSERT INTO `product_image` (`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES (24,'images/product-placeholder.svg',1,'2025-01-02 10:00:00');
