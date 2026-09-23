# DB 복구 기준

## 복구 검증 당시 격리 환경

- host/port: `127.0.0.1:3307`
- schema: `everywear_recovery`
- application account: `everywear_app`
- 시스템 MySQL과 포트 3306 사용 금지

실제 비밀번호와 관리자 설정은 저장소에 두지 않는다. 연결값의 키만 `config/recovery.env.example`에서 관리한다.

## 원본 스키마 참조본

원본 전체 스키마(`TABLE.sql`)와 미적용 seed(`Category.sql`, `FAQ.sql`)는 `db/legacy-original/` 아래에 그대로 보존한다. 이들은 복구 마이그레이션이 diff 기준으로 삼는 원형이며, 적용하지 않는다. `coupon`·`event`·`notification`·`review_comment`·`review_report` 등 복구에서 의도적으로 제외한 테이블을 확인할 수 있다.

`db/legacy-original/` 파일과 PHASE 7C 에서 제거한 제3자 데이터(`Product.sql`·`Q&A.sql`)는 서로 무관하다. legacy-original 은 스키마 참조본이며 제3자 상품/개인 handle 콘텐츠가 없다.

## 공개 신규 설치 적용 기준

`db/legacy-original/TABLE.sql` 전체를 적용하지 않고, 현재 DAO 계약에 맞춘 다음 파일을 사용한다.

1. `db/recovery_minimal.sql`
2. `db/recovery_cart_schema.sql`
3. `db/recovery_signup_schema.sql`
4. `db/recovery_admin_auth_schema.sql`
5. `db/recovery_order_schema.sql`
6. `db/recovery_qna_review_schema.sql` — PHASE 4 Q&A/리뷰 첨부 경로 (`inquiry_image`, `inquiry_reply`, `review`, `review_image`). `recovery_minimal.sql`(user·inquiry·product_detail)과 `recovery_admin_auth_schema.sql`(admin) 이후에 실행한다.
7. `db/recovery_notice_schema.sql` — PHASE 5B 관리자 공지 경로 (`notice`). seed·INSERT 없음.
7-1. `db/recovery_faq_schema.sql` — FAQ 화면(`FAQ.jsp`)용 `faq` 테이블과 원본 `db/legacy-original/FAQ.sql` seed 21건(수정 없이 그대로). 원본 seed에는 "회원 등급은 어떻게 되나요?"가 일반 텍스트와 HTML 강조 버전으로 두 번 들어 있다.
7-2. `db/recovery_category_schema.sql` — 관리자 상품 목록/수정용 `category` 테이블과 원본 `db/legacy-original/Category.sql` seed 25건(수정 없이 그대로). 원본 seed의 `JUMPER OUTER`는 상품 데이터의 카테고리명 `JUMPER`와 표기가 다르다.
8. `db/original_product_catalog.sql` — **상품 데이터 적재 단계.** 원본 크롤링 상품 카탈로그 (`product` 1,518 / `product_detail` 3,513 / `product_image` 7,410)를 적재한다.
9. `db/original_product_image_url_fix.sql` — **최종 URL 보정 단계.** 8번 직후 1회만 실행한다. 원본 크롤링 당시 상대경로로 저장된 이미지 URL 181건만 절대 URL로 보정하며, 8번 SQL 파일 내용 자체는 수정하지 않는다.

`recovery_user` 1행은 1번 `recovery_minimal.sql`에 이미 포함되어 있으므로 별도 INSERT하거나 계정 생성 목적으로 해당 SQL을 재실행하지 않는다. 위 순서는 빈 schema에서 한 번 적용하는 기준이며, ALTER/CREATE 및 고정 PK seed의 재실행은 중복 오류나 테스트 비밀번호 덮어쓰기를 일으킬 수 있다.

공개/disposable 신규 설치에는 아래 A의 private recovery 데이터가 필요하지 않다. 기존 recovery DB를 사용하지 않고 별도의 빈 schema를 준비한다. 현재 SQL의 CREATE DATABASE/USE는 `everywear_recovery`로 고정되어 있으므로, 승인된 disposable 검증에서는 저장소 밖 사본의 schema 지정문만 대상 이름으로 바꾸고 확인해야 한다. CLI의 기본 DB 지정만으로는 격리되지 않는다.

**PUBLIC FRESH INSTALL — PASS (2026-09-12, 합성 Demo 24개 기준, 이전 세션):** 독립 MySQL 8.0.46에 당시 공개 SQL 8개(`db/demo_product_sample.sql` 포함)를 순차 적용해 신규 설치 실제 검증을 완료했다. `everywear_recovery` schema 20 tables, `user` 1, `product` 24, `product_detail` 65, `product_image` 24가 예상대로 생성되었다. 메인·상품 목록/NEW/BEST·Demo 상세 ID 8/10/11/12/13가 HTTP 200, 일반 로그인과 장바구니·찜·텍스트 Q&A CRUD가 PASS했다. 검증 후 임시 DB·계정·runtime을 정리했다. 이 기록은 원본 카탈로그 복원 **이전**의 합성 24개 Demo seed 기준이며 과거 기록으로 유지한다.

**원본 상품 카탈로그 복원 — PASS (disposable 환경):** 위 8·9번을 disposable MySQL/Tomcat(기존 실행 환경과 분리된 port·socket·datadir)에 적용해 `product` 1,518 / `product_detail` 3,513 / `product_image` 7,410 row count, PK 중복 0, orphan FK 0, 이미지 없는 상품 0, URL 보정 후 상대경로 잔존 0을 확인했다. `main2.jsp`·`productList.jsp`(전 카테고리)·`productNew.jsp`·`productBest.jsp`·`pdDetail.jsp`(사이즈 있는/없는 상품 모두)·`login.jsp` HTTP 200, `productList.jsp?cat=all`이 실제 1,518개 항목을 렌더링함을 확인했다. 검증 후 disposable DB·Tomcat은 사용자 확인을 위해 유지 중이다. 상품 데이터는 두 갈래로 분리한다. 아래 "A. 검증된 recovery baseline" 과 "B. 공개 원본 상품 카탈로그" 를 혼동하지 않는다.

Migration과 fixture는 분리한다. Migration에 실제 관리자 계정, 비밀번호 또는 외부 credential을 넣지 않는다.

## A. 검증된 recovery baseline (변경 금지)

격리 DB `127.0.0.1:3307/everywear_recovery` 를 재구축한 뒤 기록한 검증 기준선이다. PHASE 4~7 의 모든 E2E·digest 근거이며 **PHASE 7C 에서 변경하지 않았다.**

- `user` 1, `user_log` 0, `user_address` 0, `user_coupon` 0, `favorite` 0
- `product` 1518, `product_detail` 3513, `product_image` 7410
- `admin` 0, `admin_log` 0
- `payment` 0, `orders` 0, `delivery` 0, `refund` 0
- `inquiry` 0, `inquiry_image` 0, `inquiry_reply` 0, `review` 0, `review_image` 0
- `notice` 0 (PHASE 5B에서 `db/recovery_notice_schema.sql` 적용, seed 없음)

상품 1518건은 forensic 원본의 상품 INSERT 데이터 중 검증된 부분에서 왔다. **PHASE 7C 에서 `src/main/java/Product.sql` 을 저장소에서 제거했으나, 이후 사용자 확정 요구사항에 따라 `db/original_product_catalog.sql` 경로로 공개 저장소 tree 에 복원했다.** baseline digest 는 저장소 밖 backup 에 historical evidence 로 계속 보존한다.

## B. 공개 원본 상품 카탈로그 (`db/original_product_catalog.sql`)

당시 실제로 크롤링한 원본 상품 데이터다. 위 공개 신규 설치 migration을 순서대로 적용한 뒤, `db/original_product_image_url_fix.sql` 과 함께 마지막에 실행한다.

- `product` 1,518, `product_detail` 3,513, `product_image` 7,410. A의 검증된 recovery baseline과 row count가 동일하다.
- 실제 상품명·가격·설명·색상과 원본 크롤링 대상 쇼핑몰(nomanual-shop.com)·제휴 CDN(musinsa, msscdn, sixshop)의 외부 이미지 URL을 그대로 포함한다.
- 소스: `everyWEAR_recovered` 저장소 commit `ff858d9`(PHASE 7C 직전) `src/main/java/Product.sql`. CRLF만 LF로 정규화했으며 SQL 내용 자체는 수정하지 않았다. LF 정규화본 sha256: `6898aaf9b2b923406958761eb729f306dce3f485b12c8d4dd40724c5c198cdd0`.
- `product` / `product_detail` / `product_image` 컬럼은 모두 컬럼명을 명시한 INSERT이므로 `ProductDAO` 의 `SELECT *` 위치 인덱스 계약과 호환된다.
- 상품 1,518개 중 314개는 원본 데이터 자체에 `product_detail`(사이즈)이 없다. 상세 화면은 정상 표시되며 재입고 알림 상태로 처리된다.
- 이미지 URL 181건은 원본 크롤링 당시부터 상대경로(`/web/...`)였다. `db/original_product_image_url_fix.sql` 로 `nomanual-shop.com` 기준 절대 URL로 보정한다. 원본 카탈로그 SQL 파일 자체는 수정하지 않는다.
- **과거 합성 24개 Demo seed(`db/demo_product_sample.sql`)는 제거했다.** 원본 카탈로그와 함께 적용하면 `product_detail`의 고정 PK(1~65)가 충돌하므로 두 파일을 함께 적용하지 않는다.
- **이 카탈로그는 위 "A. 검증된 recovery baseline" 과 동일한 원본 데이터를 담고 있다.** 라이브 recovery DB(:3307)는 이 파일로 재구축하지 않았다.

## digest 기준선 / fixture 규칙

과거 PHASE 4 E2E 당시 기준선은 19개 테이블의 count와 PK 정렬 SHA-256 digest 집합이며, 저장소 밖의 복구 backup에 보관한다. 이 digest 는 위 "A. 검증된 recovery baseline"(상품 1518건 포함) 기준이며, "B. 공개 원본 상품 카탈로그"의 disposable 검증과는 별개 환경의 기록이다. PHASE 5B에서 `notice` 테이블을 recovery DB에 추가해 현재 스키마는 20개 테이블이다. PHASE 5B의 targeted regression은 `notice` 관련 count·동작만 확인했고, 20개 테이블 전체 digest는 당시 PHASE 5B에서 재실행하지 않았다. 기존 19개 테이블 digest baseline 기록은 그대로 유지한다.

**별도 최종 결과:** 이후 FINAL INTEGRATED REGRESSION의 consolidated fixture E2E를 완료했다(PASS WITH LIMITATIONS). cleanup 후 20/20 table count와 PK-sorted SHA-256 digest가 실행 직전 baseline과 완전 일치했고 marker 잔존 0, 기존 데이터 불변을 확인했다. 이는 A의 복구 검증 환경 결과이며, PHASE 8의 disposable 원본 카탈로그 검증과는 별개 결과다.

E2E fixture는 recovery 전용 marker와 명시적 컬럼을 사용해 transaction으로 만들고, 정확한 PK·marker로만 정리한다. 정리 후 table count와 PK 정렬 SHA-256 digest를 기준선과 비교한다. PHASE 5B 테스트 정리 후 `notice`·`admin` marker 잔존 0, `notice` = 0. AUTO_INCREMENT 값은 되돌리지 않는다.

실제 CREATE/ALTER/INSERT/UPDATE/DELETE/DROP/TRUNCATE와 관리자 권한 사용 직전에는 대상 port·schema·영향 행을 확인하고 STOP한다.
