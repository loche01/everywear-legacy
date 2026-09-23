-- everyWEAR 원본 상품 이미지 URL 보정
--
-- 목적: db/original_product_catalog.sql 을 그대로 적용한 뒤,
--       원본 크롤링 당시 상대경로로 저장된 product_image.pi_url 181건만
--       nomanual-shop.com 기준 절대 URL로 보정한다.
--
-- 원본 catalog SQL(db/original_product_catalog.sql)의 내용 자체는 수정하지 않는다.
-- 이 파일은 그 위에 적용하는 보정 단계이며, 별도로 관리한다.
--
-- 대상: pi_url이 '/web/'로 시작하는 행만 (181건).
--       다른 host(nomanual-shop.com 절대경로, image.musinsa.com, image.msscdn.net,
--       contents.sixshop.com 등)의 pi_url은 대상이 아니며 수정하지 않는다.
--
-- 적용 순서: db/original_product_catalog.sql 적용 직후, 1회만 실행한다.
-- 재실행해도 안전하다(WHERE 조건이 이미 보정된 절대 URL에는 다시 매치되지 않음).

UPDATE `product_image`
SET `pi_url` = CONCAT('https://nomanual-shop.com', `pi_url`)
WHERE `pi_url` LIKE '/web/%';
