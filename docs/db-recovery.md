# DB 복구와 데이터 구분

## 설치 SQL

원본 전체 schema(`db/legacy-original/TABLE.sql`)는 현재 DAO 코드와 맞지 않는 부분이 있어, 코드가 실제로 사용하는 구조에 맞춘 아래 파일을 순서대로 적용합니다. 빈 MySQL에 한 번만 적용하는 것을 기준으로 합니다.

| 순서 | 파일 | 내용 |
|---|---|---|
| 1 | `recovery_minimal.sql` | `everywear_recovery` DB 생성, 회원·상품·Q&A 기본 테이블, 테스트 계정 1개 |
| 2 | `recovery_cart_schema.sql` | 장바구니·찜 |
| 3 | `recovery_signup_schema.sql` | 회원가입·배송지·로그인 기록 |
| 4 | `recovery_admin_auth_schema.sql` | 관리자 계정·관리자 로그 |
| 5 | `recovery_order_schema.sql` | 주문·결제·배송·환불 |
| 6 | `recovery_qna_review_schema.sql` | Q&A 첨부·답변, 리뷰·리뷰 이미지 |
| 7 | `recovery_notice_schema.sql` | 공지 |
| 8 | `recovery_faq_schema.sql` | FAQ와 원본 데이터 21건 |
| 9 | `recovery_category_schema.sql` | 카테고리와 원본 데이터 25건 |
| 10 | `original_product_catalog.sql` | 원본 상품 데이터 |
| 11 | `original_product_image_url_fix.sql` | 상대경로 이미지 주소 보정 (10번 직후 1회) |
| 12 | `original_product_detail_supplement.sql` | 사이즈가 빠졌던 상품의 사이즈 보충 |

- 테스트 계정 `recovery_user`는 1번 파일에 들어 있습니다. 따로 INSERT하지 않습니다.
- 일부 CREATE/ALTER와 고정 PK 데이터는 다시 실행하면 오류가 나거나 테스트 비밀번호를 덮어씁니다.
- 실제 비밀번호와 관리자 계정은 SQL에 넣지 않았습니다.
- DB 접속 정보는 환경변수로 전달합니다 ([config/recovery.env.example](../config/recovery.env.example)).

## 원본 상품 데이터

`original_product_catalog.sql`은 팀 프로젝트 당시 크롤링한 상품 데이터입니다. 내용은 수정하지 않았고 줄바꿈 문자(CRLF → LF)만 바꿨습니다.

| 테이블 | 건수 |
|---|---|
| `product` | 1,518 |
| `product_detail` (사이즈·재고) | 3,513 |
| `product_image` | 7,410 |

- 상품명·가격·설명·색상과 외부 쇼핑몰·CDN의 이미지 주소(nomanual-shop.com, musinsa, msscdn, sixshop)가 원본 그대로 들어 있습니다.
- 이미지 주소 181건은 원본에서부터 상대경로(`/web/...`)였습니다. `original_product_image_url_fix.sql`로 절대 주소로 보정합니다.
- 상품 314개는 원본 데이터에 사이즈 정보가 없습니다. 당시 상품 설명에서 사이즈를 뽑는 방식이라, 설명에 사이즈 표기가 없는 상품이 빠졌기 때문입니다.
- 이 상품들은 당시 상세 페이지의 SIZE 옵션을 다시 크롤링해 두었습니다. `original_product_detail_supplement.sql`로 304개 상품, 599행을 채웁니다(`pd_id` 3514~4112). 사이즈 표기는 쇼핑몰 옵션명 그대로라 `L[33]`처럼 허리 치수가 붙은 경우가 있습니다.
- 보충 후에도 10개 상품은 사이즈가 없어 장바구니에 담을 수 없습니다.
- 재고(`pd_stock`)는 원본·보충 모두 100으로 일괄 입력한 값이며 실제 재고가 아닙니다.
- INSERT에 컬럼명을 모두 적어 두어, `ProductDAO`가 컬럼 순서로 값을 읽는 방식과 맞습니다.

공개 초기에 넣었던 샘플 상품 24개(`demo_product_sample.sql`)는 원본 데이터와 PK가 겹쳐 제거했습니다.

## 원본 schema 참고본

`db/legacy-original/`에는 팀 프로젝트의 원본 schema(`TABLE.sql`)와 카테고리·FAQ 데이터가 그대로 있습니다. 설치에는 쓰지 않고 비교용으로만 둡니다. 쿠폰·이벤트·알림·리뷰 댓글·리뷰 신고처럼 복구에서 뺀 테이블은 여기서 확인할 수 있습니다.

원본 카테고리 데이터의 `JUMPER OUTER`는 상품 데이터의 `JUMPER`와 표기가 다릅니다. 그래서 OUTER 필터에서 JUMPER 상품 16개가 빠집니다. 원본 그대로 두었습니다.

## 데이터 확인

원본 상품 데이터를 적용한 뒤 다음을 확인했습니다.

- 세 테이블의 건수가 위 표와 일치
- PK 중복 0건, 상위 상품이 없는 상세·이미지 0건, 이미지가 없는 상품 0건
- 대표 이미지(`pi_orders = 1`)가 상품마다 정확히 1개
- 주소 보정 후 상대경로 이미지 0건
- 전체 상품 목록에 1,518개가 모두 표시됨
- 보충 SQL 적용 시 `product_detail` 3,513 → 4,112건, 사이즈 없는 상품 314 → 10개, 상위 상품 없는 행 0건 (transaction 안에서 확인 후 rollback)

테스트 데이터는 표시용 값을 붙여 만들고, 테스트가 끝나면 그 값으로만 지웠습니다. 지운 뒤에는 테이블별 건수와 PK 순서 SHA-256 값을 테스트 전과 비교해, 기존 데이터가 바뀌지 않았는지 확인했습니다.
