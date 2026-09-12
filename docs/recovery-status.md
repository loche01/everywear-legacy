# Legacy 복구 현황

복구 기준: `36a9cb2`의 소스 스냅샷. 공개 root commit `af336ab` 생성 완료. 이 문서의 `36a9cb2` 및 PHASE별 과거 commit은 복구 기준 저장소의 이력이며, 현재 공개 저장소의 Git history에 포함되지 않는다.

## 완료

- **FINAL INTEGRATED REGRESSION 완료 — PASS WITH LIMITATIONS. Legacy 기능/보안 검증 종료.**
- C-1/H-1/H-2 consolidated fixture E2E PASS. cleanup 후 20/20 table count와 PK 정렬 SHA-256 digest가 실행 직전 baseline과 완전 일치. marker 잔존 0, 기존 데이터 불변.
- 상품 상세 입력 검증 및 장바구니 stale 세션 보호를 복구 기준에 포함했다.
- 공개본에서는 권리 근거가 없는 메인 영상을 제외하고 자체 placeholder로 대체했다. 미사용 Windows 절대경로와 구형 리뷰 삭제 오버로드를 제거했다.

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
- PHASE 7 공개 전 정리 (진행 중)
  - PHASE 7A: 미사용 테스트/trash JSP·전용 CSS, dev SQL, 개인 handle 포함 legacy seed, 관리자 계정 열람 디버그 endpoint(`AdminCheckServlet`), 고아 테스트 업로드 제거 (`4d8ccdc`)
  - PHASE 7B: Google/Kakao OAuth redirect URI 및 개인 DDNS 하드코딩 제거 → 환경변수 외부화, 미설정 시 안전 비활성화 (`ff858d9`)
  - PHASE 7C: 제3자 스크래핑 상품/이미지 데이터(`src/main/java/Product.sql`, 실제 브랜드명·가격·외부 CDN 이미지 URL) 저장소에서 제거. 공개용 완전 합성 demo dataset `db/demo_product_sample.sql`(상품 24개, 자체 placeholder 이미지) 추가. **라이브 recovery DB(:3307) 및 검증된 baseline(product 1518 / product_detail 3513 / product_image 7410, phase4 digest)은 변경하지 않았다** — demo sample 은 from-scratch 데모용이며 baseline 을 대체하지 않는다

Naver 실제 OAuth 로그인은 외부 Naver 애플리케이션과 callback 설정이 필요하므로 외부 E2E 완료로 보지 않는다.

## 미완료

1. README 및 데이터 출처·라이선스 고지 작성
2. GitHub 공개 및 Legacy 포트폴리오 마감

Park/V3 신규 기능 병합은 종료했다. Spring Boot 현대화는 위 Legacy 마감 후 별도 단계다.
