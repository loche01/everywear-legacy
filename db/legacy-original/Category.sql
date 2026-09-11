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