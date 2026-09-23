# 상품 데이터 크롤러

팀 프로젝트 당시 쇼핑몰에 넣을 상품 데이터를 모으려고 작성한 Python 스크립트입니다. 저장소의 [원본 상품 데이터](../db/original_product_catalog.sql)(상품 1,518 / 사이즈 3,513 / 이미지 7,410건)와 [사이즈 보충 데이터](../db/original_product_detail_supplement.sql)가 이 스크립트로 만들어졌습니다.

코드는 당시 작성한 그대로 두었습니다. 크롤링 결과 CSV는 SQL 파일에 이미 들어 있어 포함하지 않았습니다.

## 처리 순서

```text
nomanual_crawler.py                → nomanual_products.csv, nomanual_product_images.csv
        ↓
create_nomanual_products_detail.py → nomanual_products_detail.csv   (설명에서 사이즈 추출)
        ↓
a.py / update_ptext_from_excel.py  → 상품 설명 줄바꿈을 HTML로 변환해 반영
        ↓
create_insert_statements.py        → nomanual_insert.sql   (product → product_detail → product_image 순서)

사이즈가 빠진 상품 보충
missing_ids.csv → missing_product_detail.py → missing_product_detail.csv → make_sql_from_excel.py
```

| 파일 | 하는 일 |
|---|---|
| `nomanual_crawler.py` | Selenium으로 22개 하위 카테고리를 돌며 VIEW MORE를 끝까지 눌러 상품 번호를 모으고, 상품마다 이름·가격·설명·색상과 이미지를 수집. 가격 0원 상품은 제외하고, 10개마다 중간 저장 |
| `create_nomanual_products_detail.py` | 상품 설명의 `S - Length ...` 형식에서 사이즈를 정규식으로 뽑아 `product_detail` 행 생성 (재고는 100으로 일괄 입력) |
| `a.py` | 상품 설명의 줄바꿈을 `<br>`로 바꾼 `UPDATE` SQL 생성 |
| `update_ptext_from_excel.py` | 같은 작업을 DB에 직접 반영하는 버전 (접속 정보는 예시 값) |
| `create_insert_statements.py` | CSV 3개를 FK 순서에 맞춘 `INSERT` SQL로 변환, 문자열 escape 처리 |
| `missing_ids.csv` | 설명에 사이즈 표기가 없어 사이즈를 뽑지 못한 상품 313개 |
| `missing_product_detail.py` | requests + BeautifulSoup으로 상세 페이지의 SIZE 옵션을 다시 수집 |
| `crawl_missing_details.py` | 같은 보충을 Selenium으로 옵션별 재고까지 읽으려 한 버전 |
| `make_sql_from_excel.py` | 보충 결과를 `product_detail` `INSERT` SQL로 변환 |

## 이미지 수집 방식

- 대표 이미지는 썸네일 영역의 첫 이미지(`product/tiny`)만 저장
- 나머지는 "추가 이미지" 영역과 "상세 정보" 영역 중 이미지가 많은 쪽 하나만 사용
- 작은 미리보기(`product/small`)는 제외
- 같은 주소가 여러 번 나오면 마지막 위치를 기준으로 순서를 다시 매김

## 실행 환경

Python 3, Chrome. 필요한 패키지는 `requirements.txt`에 있습니다.

```bash
pip install -r requirements.txt
python nomanual_crawler.py
```

크롤링 대상 사이트의 구조가 바뀌어 지금은 그대로 동작하지 않을 수 있습니다. 수집한 데이터는 학습용 팀 프로젝트에만 사용했습니다.
