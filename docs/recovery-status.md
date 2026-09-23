# Legacy 복구 현황

복구 기준: `36a9cb2`의 소스 스냅샷. 공개 root commit `af336ab`과 Demo/문서 보정 commit `f503693` 생성 완료. 이 문서의 `36a9cb2` 및 PHASE별 과거 commit은 복구 기준 저장소의 이력이며, 현재 공개 저장소의 Git history에 포함되지 않는다.

## 완료

- **FINAL INTEGRATED REGRESSION 완료 — PASS WITH LIMITATIONS. Legacy 기능/보안 검증 종료.**
- **[PHASE 7 당시 기록]** PUBLIC FRESH INSTALL 완료 — PASS(합성 Demo 24개 기준). 독립 MySQL 8.0.46에 당시 공개 SQL 8개(`db/demo_product_sample.sql` 포함)를 순차 적용해 신규 설치·로그인·장바구니·찜·텍스트 Q&A CRUD를 검증했다. **PHASE 8에서 설치 절차가 원본 카탈로그(`db/original_product_catalog.sql` + `db/original_product_image_url_fix.sql`) 기준으로 교체되었다.** 세부 결과는 [DB 복구와 데이터 구분](db-recovery.md) 참고.
- C-1/H-1/H-2 consolidated fixture E2E PASS. cleanup 후 20/20 table count와 PK 정렬 SHA-256 digest가 실행 직전 baseline과 완전 일치. marker 잔존 0, 기존 데이터 불변.
- 상품 상세 입력 검증 및 장바구니 stale 세션 보호를 복구 기준에 포함했다.
- **[PHASE 7 당시 기록 — 현재 상태 아님]** 공개본에서는 권리 근거가 없는 메인 영상을 제외하고 자체 placeholder로 대체했다. **PHASE 8에서 이 결정을 되돌리고 원본 영상(`videos/mainvideo-white.mp4`)을 복원했다. 아래 PHASE 8 항목 참고.** 미사용 Windows 절대경로와 구형 리뷰 삭제 오버로드를 제거했다(이 부분은 현재도 유효).

- Lee 작업본 기반 Java 21·Tomcat 9 최소 실행 기준선
- recovery DB 최소 스키마와 상품 seed 복구
- 일반 로그인, 회원가입 transaction, 상품 목록·상세, 장바구니 빈 상태
- Naver 후기 로그인 로직 선택 병합 및 credential 외부화 구조
- 관리자 인증·로그아웃, 주문·결제·배송 조회와 상태 변경 보호
- 배송 상태·timestamp·송장 transaction 및 ID 연관 검증
- 관리자 환불 조회, 전체 환불 생성, 안전한 상태 전이
- 사용자·관리자 PBKDF2 비밀번호와 legacy plaintext 점진 migration
- 일반 로그인 세션 보호와 내부 redirect 검증
- FORGOT/UNLOCK 비밀번호 재설정 grant, 사용자 POST·CSRF 로그아웃
- PHASE 4: 일반 사용자 mutation(cart, wish, address, account, Q&A, review) 인증·POST·CSRF·IDOR 보호와 Q&A/리뷰 첨부파일 정합성 강화 (`13807a0`). Q&A/리뷰 첨부 4개 테이블(`inquiry_image`, `inquiry_reply`, `review`, `review_image`) 스키마를 `db/recovery_qna_review_schema.sql` recovery migration으로 보존
- `myPage.jsp`: nullable·비정상 형식 회원정보(전화번호·생년월일·성별·이메일) 파싱 시 HTTP 500 방지 (legacy 최소 보정)
- PHASE 5A: 관리자 상품 mutation 보호. `/ProductServlet` action별 read/mutation 구분, mutation(insert/update/delete)은 POST 전용 + 관리자 CSRF, 이미지 업로드 실제 decode 검증(`Security/ProductImageInput`), 상세·이미지 단일 트랜잭션과 insert 실패 보상 (`8765bfc`, `bbedd10`)
- PHASE 5B: 관리자 공지(notice) mutation 보호
  - 관리자 notice mutation(insert/update/delete/updateStatus) POST 전용 + 관리자 CSRF 보호, 하드코딩 `adminId` fallback 제거
  - 입력 검증(양의 정수 ID, 파라미터 중복 차단) 및 `updateStatus` CSV ID 목록 배치 transaction
  - 내부 예외 메시지의 사용자 노출 제거(고정 문구 + 상태 코드)
  - 관리자 내용 조회(`getContent`)가 조회수를 증가시키던 부수 변경 제거
  - 관리자·사용자 notice 출력 및 검색어 escape
  - targeted DB/HTTP regression 61/61 PASS
- PHASE 6: 미검증 Legacy 결제 경로를 실제 거래 없는 Demo로 안전 비활성화
  - `payInsert.jsp`: `PaymentDAO.insertPay`·`OrderDAO.insertOrder`·`DeliveryDAO.insertDelivery` 호출 제거. 직접 GET 호출을 받아도 payment/orders/delivery 를 만들지 않고 `{"result":"demo",...}` 반환
  - `payComplete.jsp`: `updatePointForOrder`·`updatePointWhenOrder`·`deleteCartAfterOrder` 부수효과 제거, "결제 데모" 정적 안내 화면
  - `payProc.jsp`: PortOne/Iamport SDK 및 `IMP.request_pay`, 죽은 `/payments/complete` AJAX, `payInsert`/`sendMSG` 호출 제거. "Demo 환경 — 실제 PG 결제 미실행" 안내만 제공(외부 PG popup/API 미호출)
  - `sendMSG.jsp`: `PhoneSMS.sendMSG` 호출 제거(실제 SMS 미발송), `{"result":"demo","sent":false}` 반환. `PhoneSMS.java`·회원가입/인증 SMS 경로는 무변경
  - `pay.jsp`: 주문서 상단에 "DEMO STORE — 실제 결제·주문·배송 없음" 배너 추가(계산 UI 구조는 유지)
  - 실제 PortOne 서버 검증 API 및 PG refund 연동은 구현하지 않았다. 관리자 refund workflow 는 여전히 DB 상태관리이며 실제 PG cancellation 이 아니다
- PHASE 7 공개 전 정리 완료
  - PHASE 7A: 미사용 테스트/trash JSP·전용 CSS, dev SQL, 개인 handle 포함 legacy seed, 관리자 계정 열람 디버그 endpoint(`AdminCheckServlet`), 고아 테스트 업로드 제거 (`4d8ccdc`)
  - PHASE 7B: Google/Kakao OAuth redirect URI 및 개인 DDNS 하드코딩 제거 → 환경변수 외부화, 미설정 시 안전 비활성화 (`ff858d9`)
  - PHASE 7C: 제3자 스크래핑 상품/이미지 데이터(`src/main/java/Product.sql`, 실제 브랜드명·가격·외부 CDN 이미지 URL) 저장소에서 제거. 공개용 완전 합성 demo dataset `db/demo_product_sample.sql`(상품 24개, 자체 placeholder 이미지) 추가. **라이브 recovery DB(:3307) 및 검증된 baseline(product 1518 / product_detail 3513 / product_image 7410, phase4 digest)은 변경하지 않았다** — demo sample 은 from-scratch 데모용이며 baseline 을 대체하지 않는다. **(PHASE 8에서 이 제외 결정을 되돌리고 원본 카탈로그를 복원했다. 아래 참고.)**
- **PHASE 8: 원본 상품 카탈로그·원본 시각 요소 선택적 복원 (사용자 확정 요구사항).**
  - PHASE 7C에서 제거했던 원본 상품 데이터를 `everyWEAR_recovered` 저장소 commit `ff858d9`(PHASE 7C 직전)에서 다시 추출해 `db/original_product_catalog.sql`로 복원했다(product 1,518 / product_detail 3,513 / product_image 7,410, 실제 상품명·가격·외부 CDN 이미지 URL 포함). 원본 크롤링 당시 상대경로였던 이미지 URL 181건은 `db/original_product_image_url_fix.sql`로 별도 보정했다. `db/demo_product_sample.sql`은 원본 카탈로그와 PK가 충돌하므로 제거했다.
  - `main2.jsp`와 관련 이미지/영상(`videos/mainvideo-white.mp4`, `main-cloth1~5.png`, `main-model.png`, `bald.png`, `bald2.jpg`, `mainac1~8.jpg`, `mainac10~11.png`, `tk.jpg`) 및 `review1.jpg`, `orderHistory3.jpg`, `productList/New/Best.jsp`, `pdListAll.jsp`, `review.jsp`, `postMn.jsp`, `orderHistory2.jsp`, `pay.jsp`를 `everyWEAR_recovered` commit `36a9cb2`(PHASE 7C 이후 보안 복구가 모두 반영된 최신 상태) 기준으로 복원했다. 각 파일은 사전에 diff를 확인해 차이가 공개 정리 당시의 asset/placeholder 치환뿐임을 검증한 뒤에만 복원했다.
  - 로그인 화면은 원본 team UI의 `login.jsp`/`css/login.css`와 `images/Google.png`/`images/kakao.png`를 복원했다(레이아웃·CSS는 `36a9cb2` 기준, 현재 보안 로직 — RedirectSanitizer, OAuth env 설정, `naverOAuthState`, `aria-disabled` 판정 등 — 은 그대로 유지). **Naver 로그인 버튼은 이번 복원 범위에서 제외**하고 화면에서 제거했다. `NaverLoginServlet.java`와 관련 `Security` 로직, `images/Naver.png`는 삭제하지 않고 보존했으며, login.jsp의 Naver 관련 스크립틀릿은 JSP 주석으로 재도입 경로를 남겼다. `myPage.jsp`/`css/myPage.css`/`crm/basic.jsp`의 Google/Kakao/Naver 아이콘 표시도 함께 복원했다(로그인 버튼이 아닌 계정 provider 표시 배지이므로 Naver 제외 대상이 아니다).
  - 공개 정리 과정에서 추가됐던 대체 이미지 `images/google-signin.png`, `images/kakao-login.png`는 repo 전체 참조 0건을 확인한 뒤 제거했다.
  - disposable MySQL 8.0.46 + Tomcat 9(기존 실행 환경과 완전히 분리된 port·socket·datadir)에서 검증했다. row count 일치, PK 중복 0, orphan FK 0, URL 보정 후 상대경로 잔존 0, Java 21 전체 75개 소스 compile PASS, `main2.jsp`/`productList.jsp`(전 카테고리)/`productNew.jsp`/`productBest.jsp`/`pdDetail.jsp`/`login.jsp` HTTP 200, 대표 보안 회귀(POST 미사용 mutation 405 거부, admin 미인증 접근 302 리다이렉트, 외부 redirect 파라미터 내부 경로로 정규화) 확인. 108개 JSP 전체 precompile과 로그인 세션·cart/wish DB 연동 회귀는 이번 세션에서 미수행.
  - 되돌리지 않은 보안 개선: PBKDF2, CSRF/POST 보호, IDOR 방어, 세션 보호, OTP/grant, 관리자 보호, OAuth env 설정, redirect 검증, `pdDetail` 입력 검증, `cart2` 세션 보호, `pay.jsp` Demo 결제 차단, Q&A/review 보안, DAO Windows 절대경로 제거, dependency/license 정리 — PHASE 7A/7B/공개 의존성 정리 commit 전부 유지.

Naver 실제 OAuth 로그인은 외부 Naver 애플리케이션과 callback 설정이 필요하므로 외부 E2E 완료로 보지 않는다. PHASE 8 이후 로그인 화면 자체에는 Naver 옵션을 제공하지 않는다.

## 완료된 과거 단계 (참고)

- README 최종 검토 및 데이터 출처·라이선스 고지 작성 — PHASE 7 당시 완료.
- GitHub 공개 및 Legacy 포트폴리오(Notion) 반영 — PHASE 7 당시 완료.

## 미완료

1. **PHASE 8 결과(원본 카탈로그·원본 시각 요소 복원)를 release repo/GitHub/포트폴리오에 재반영.** 현재 PHASE 8은 작업 저장소(`everyWEAR_legacy_public`)에만 반영되어 있으며, `everyWEAR_legacy_release`와 GitHub 공개본, Notion 포트폴리오는 아직 PHASE 7 기준 상태다.
2. 사용자의 실제 화면 수동 확인 및 승인 (PHASE 8 결과물).
3. ~~108개 JSP 전체 precompile, 로그인 세션·cart/wish DB 연동 기능 회귀~~ — disposable 환경에서 108/108 precompile PASS, 로그인 세션 기반 cart/wish add·수량변경·delete·IDOR 방어 PASS 완료(FINAL PRE-COMMIT VERIFICATION, 2026-09-16). 남은 항목은 외부 CDN 4개 host 전수 이미지 로딩률 측정(현재는 host별 제한 표본만 확인)과 실제 Google/Kakao OAuth live E2E.

Park/V3 신규 기능 병합은 종료했다. Spring Boot 현대화는 위 Legacy 마감 후 별도 단계다.
