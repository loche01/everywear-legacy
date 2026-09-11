# 알려진 문제와 보류 항목

## Legacy 종료 전에 처리

- 첫 공개용 커밋 전에 스냅샷의 credential, 테스트 fixture 및 개인정보 후보를 확인한다. 복구 저장소의 기존 Git history는 이 공개본에 포함하지 않는다.

## 해결됨

- 권리 근거가 확인되지 않은 메인 영상은 공개본에서 제외했다. `main2.jsp`는 저장소 자체 `images/product-placeholder.svg`를 사용한다.
- 미사용 Windows 업로드 절대경로와 호출자 없는 구형 리뷰 삭제 오버로드를 공개본에서 제거했다. 보호된 리뷰 삭제 경로는 유지한다.

- PHASE 6: 미검증 결제 경로 안전 마감. `payInsert.jsp`/`payComplete.jsp`/`payProc.jsp`/`sendMSG.jsp` 에서 payment·orders·delivery 생성, 적립금 변경, 장바구니 삭제, 실제 SMS 발송, PortOne SDK 호출을 모두 제거하고 `pay.jsp` 에 Demo 표기를 추가했다. 클라이언트가 결제 성공을 위조해 주문/결제를 확정할 수 있던 경로가 차단되었다.

## 남은 한계 (Legacy Demo로 유지)

- Google/Kakao/Naver 실제 OAuth E2E는 수행하지 않았다.

- 실제 PortOne 서버 검증 API(`GET /payments/{imp_uid}`) 및 실 PG 결제 연동은 구현하지 않았다. 결제는 Demo 안내로만 종료된다.
- 관리자 refund workflow 는 `refund` 테이블 상태관리(`rf_status`)일 뿐 실제 PG cancellation/환불 호출이 아니다.
- **이메일 변경 재인증(OTP)은 구현하지 않았다.** `myPage.jsp` → `updateEmail.jsp` 경로는 POST + 로그인 + CSRF + 형식·길이 검증까지만 적용되며, 새 주소 소유 확인이나 기존 주소 통지는 없다. 이메일은 이 프로젝트에서 계정 복구 인자가 아니므로(비밀번호 찾기는 id+name+email 3중 확인) H-2 범위에서 제외했다.
- **관리자 로그인 OTP(`AdminAuthServlet` / `AdminLogin`)는 전면 재설계하지 않았다.** H-2 에서는 무인증 외부 메일 relay 만 차단했다(POST·form 인코딩·파라미터 중복 거부·수신자를 DB 등록 주소로 고정·발송 실패 전달·SecureRandom). 인증번호를 세션에 평문 저장하고 만료 시각이 별도로 없으며 로그인 성공 후에도 소비되지 않는 문제는 남아 있다. 다만 관리자 로그인은 비밀번호·이메일 일치와 DB 5회 실패 잠금으로 보완된다.
- **OTP 발송 남용 억제는 세션 단위 쿨다운(약 60초)까지만이다.** 세션을 새로 발급받으면 우회할 수 있다. IP·수신번호 단위 rate limiting 은 reverse proxy/WAF 영역이라 Legacy JSP 범위를 넘는다.
- **실제 CoolSMS / Gmail 발송 E2E 는 수행하지 않았다.** credential 이 없으면 발송 경로는 안전 비활성화 상태(`{"result":"fail"}`, 500·스택트레이스 없음)로 동작한다. 실제 단말 수신, 문자 본문, 발신번호 사전등록 규정 준수는 미검증이다.
- `review_comment` / `review_report` 테이블이 recovery DB 에 미복구 상태다. 이 때문에 관리자 CRM 의 리뷰 상세관리(`crm/reviewAdmin.jsp` — 리뷰 댓글 등록/삭제, 리뷰 신고 조회, 리뷰 삭제)는 Legacy 에서 안전 비활성화했다. GET 은 안내 화면만 반환하고, mutation(POST) 요청은 `AdminAuthFilter` 에서 DAO 호출 없이 410 으로 거부된다. `crm/post.jsp` 의 리뷰 상세관리 팝업 진입도 제거했다(회원 리뷰/문의 조회는 유지).

## 품질 개선 후보


- review/Q&A 첨부는 PHASE 4에서 DB 성공 후 파일 저장·삭제를 보상 로직으로 맞추도록 정리했다. 분산 transaction은 아니므로 커밋과 파일 조작 사이 비정상 종료 시 고아 파일 가능성이 남는다.
- Tomcat 종료 시 MySQL JDBC cleanup thread/driver deregistration 경고가 남아 있다.
- 일부 legacy DAO의 `printStackTrace`와 debug 출력, 예외 삼키기, resource cleanup을 범위별로 정리해야 한다.
- JSP 출력의 HTML escaping이 전체 적용된 상태가 아니다.
- favicon 404와 일부 legacy UI 자원 경고가 남아 있다.

## Legacy 이후로 보류

- 전체 DAO/transaction 구조 리팩터링
- 모든 JSP의 MVC 전환
- 전역 예외·logging framework 재설계
- Spring Boot 현대화
- Park/V3의 CRM, 쿠폰, 추가 회원관리 등 신규 기능 병합

Spring Boot 작업은 Legacy GitHub 공개, README와 포트폴리오 마감 이후 별도 기준선에서 시작한다.
