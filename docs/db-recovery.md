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
8. `db/demo_product_sample.sql` — 공개 신규 설치의 마지막 단계. 합성 상품·옵션·이미지 seed.

`recovery_user` 1행은 1번 `recovery_minimal.sql`에 이미 포함되어 있으므로 별도 INSERT하거나 계정 생성 목적으로 해당 SQL을 재실행하지 않는다. 위 순서는 빈 schema에서 한 번 적용하는 기준이며, ALTER/CREATE 및 고정 PK seed의 재실행은 중복 오류나 테스트 비밀번호 덮어쓰기를 일으킬 수 있다.

공개/disposable 신규 설치에는 아래 A의 private recovery 데이터가 필요하지 않다. 기존 recovery DB를 사용하지 않고 별도의 빈 schema를 준비한다. 현재 SQL의 CREATE DATABASE/USE는 `everywear_recovery`로 고정되어 있으므로, 승인된 disposable 검증에서는 저장소 밖 사본의 schema 지정문만 대상 이름으로 바꾸고 확인해야 한다. CLI의 기본 DB 지정만으로는 격리되지 않는다. 신규 설치 실제 검증은 아직 수행하지 않았다.

상품 데이터는 두 갈래로 분리한다. 아래 "A. 검증된 recovery baseline" 과 "B. 공개용 demo sample" 을 혼동하지 않는다.

Migration과 fixture는 분리한다. Migration에 실제 관리자 계정, 비밀번호 또는 외부 credential을 넣지 않는다.

## A. 검증된 recovery baseline (변경 금지)

격리 DB `127.0.0.1:3307/everywear_recovery` 를 재구축한 뒤 기록한 검증 기준선이다. PHASE 4~7 의 모든 E2E·digest 근거이며 **PHASE 7C 에서 변경하지 않았다.**

- `user` 1, `user_log` 0, `user_address` 0, `user_coupon` 0, `favorite` 0
- `product` 1518, `product_detail` 3513, `product_image` 7410
- `admin` 0, `admin_log` 0
- `payment` 0, `orders` 0, `delivery` 0, `refund` 0
- `inquiry` 0, `inquiry_image` 0, `inquiry_reply` 0, `review` 0, `review_image` 0
- `notice` 0 (PHASE 5B에서 `db/recovery_notice_schema.sql` 적용, seed 없음)

상품 1518건은 forensic 원본의 상품 INSERT 데이터 중 검증된 부분에서 왔다. 이 원본 상품 데이터(제3자 상품명·가격·외부 이미지 URL 포함)는 공개 저장소 tree 에는 두지 않으며, PHASE 7C 에서 `src/main/java/Product.sql` 을 저장소에서 제거했다. baseline digest 는 저장소 밖 backup 에 historical evidence 로 보존한다.

## B. 공개용 demo sample (`db/demo_product_sample.sql`)

from-scratch 데모·포트폴리오 환경에서 상품 목록/상세 화면을 채우기 위한 **완전 합성** 상품 seed 다. 위 공개 신규 설치 migration을 순서대로 적용한 뒤 마지막에 실행한다.

- `product` 24, `product_detail` 65, `product_image` 24
- 상품명·가격·설명·색상 전부 자체 제작(예: `DEMO BASIC TEE - WHITE`). 실제 브랜드/상품/가격과 무관.
- 이미지는 저장소 자체 `images/product-placeholder.svg` 하나만 사용. 제3자 쇼핑몰·CDN URL 없음.
- 상품마다 `product_detail` 2~4개, `product_image` 정확히 1개.
- `product` / `product_detail` 컬럼 순서는 `ProductDAO` 의 `SELECT *` 위치 인덱스 계약과 일치.
- **이 sample 은 위 "A. 검증된 recovery baseline" 을 대체하지 않는다.** 라이브 recovery DB(:3307) 는 이 파일로 재구축하지 않았다.

## digest 기준선 / fixture 규칙

과거 PHASE 4 E2E 당시 기준선은 19개 테이블의 count와 PK 정렬 SHA-256 digest 집합이며, 저장소 밖의 복구 backup에 보관한다. 이 digest 는 위 "A. 검증된 recovery baseline"(상품 1518건 포함) 기준이며, "B. 공개용 demo sample" 과는 무관하다. PHASE 5B에서 `notice` 테이블을 recovery DB에 추가해 현재 스키마는 20개 테이블이다. PHASE 5B의 targeted regression은 `notice` 관련 count·동작만 확인했고, 20개 테이블 전체 digest는 당시 PHASE 5B에서 재실행하지 않았다. 기존 19개 테이블 digest baseline 기록은 그대로 유지한다.

**별도 최종 결과:** 이후 FINAL INTEGRATED REGRESSION의 consolidated fixture E2E를 완료했다(PASS WITH LIMITATIONS). cleanup 후 20/20 table count와 PK-sorted SHA-256 digest가 실행 직전 baseline과 완전 일치했고 marker 잔존 0, 기존 데이터 불변을 확인했다. 이는 A의 복구 검증 환경 결과이며, B의 공개 Demo 신규 설치 검증 완료를 의미하지 않는다.

E2E fixture는 recovery 전용 marker와 명시적 컬럼을 사용해 transaction으로 만들고, 정확한 PK·marker로만 정리한다. 정리 후 table count와 PK 정렬 SHA-256 digest를 기준선과 비교한다. PHASE 5B 테스트 정리 후 `notice`·`admin` marker 잔존 0, `notice` = 0. AUTO_INCREMENT 값은 되돌리지 않는다.

실제 CREATE/ALTER/INSERT/UPDATE/DELETE/DROP/TRUNCATE와 관리자 권한 사용 직전에는 대상 port·schema·영향 행을 확인하고 STOP한다.
