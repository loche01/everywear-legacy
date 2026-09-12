# 계정·인증 보안 상태

## 적용 완료

- 일반 사용자 cart/wish/address/account/Q&A/review mutation의 공통 인증·POST·CSRF·소유권 검증
- 관리자 상품·공지 mutation 보호

- PBKDF2WithHmacSHA256, 600,000 iterations, 사용자별 random salt, constant-time 비교
- self-describing PBKDF2 저장값과 malformed hash fail-closed
- 일반 사용자와 관리자 legacy plaintext 로그인 성공 시 점진적 PBKDF2 migration
- 신규 가입·비밀번호 변경·reset의 PBKDF2 저장, 소셜 계정의 `NULL` 비밀번호 유지
- 일반·관리자·Naver 로그인 성공 시 session ID 회전
- 일반 로그인 내부 redirect 검증과 외부 URL·scheme-relative·backslash·CRLF·traversal 차단
- 관리자 URL 인증 Filter, POST 강제, session CSRF, 안전한 로그아웃
- FORGOT/UNLOCK 목적 분리, SecureRandom OTP, 5분 만료, 일회성 32-byte reset token의 digest만 session 저장
- reset 대상·사용자 유형·session·목적·token 검증과 재사용 차단
- UNLOCK의 비밀번호·계정상태·실패횟수·잠금상태 단일 transaction
- 일반 사용자 로그아웃 POST·CSRF·session invalidate
- 마이페이지 비밀번호 확인·변경에서 비밀번호 query string 전달 제거

## 검증 범위

- Java 21 compile과 관련 JSP compile
- reset·unlock·logout 및 JDBC failure mock 96건
- 격리 MySQL과 Browser를 사용한 FORGOT, UNLOCK, 로그인, logout/CSRF E2E
- 당시 인증 복구 단계에서 fixture 정리 후 15개 테이블 count/digest 기준선 일치(과거 단계 기록)
- 이후 FINAL INTEGRATED REGRESSION의 consolidated fixture E2E에서 cleanup 후 20/20 table count와 PK 정렬 SHA-256 digest가 실행 직전 기준선과 완전 일치. 최종 판정은 PASS WITH LIMITATIONS([복구 현황](recovery-status.md)).

실제 SMS/Gmail, Naver OAuth는 외부 서비스 호출 없이 내부 grant·callback 구조까지만 검증했다. 실제 외부 E2E 완료로 표현하지 않는다.

## 남은 범위

- OTP 발송은 세션 cooldown을 적용했다. IP·수신자 단위 제한과 외부 provider 운영 검증은 미완료.
- 향후 공개 변경분의 credential·개인정보 재검사. 복구 저장소의 기존 history 감사와 별개로, 현재 공개본은 새 root commit `af336ab`에서 시작하며 초기 스냅샷 검사를 완료했다. 기존 recovery history는 포함하지 않는다.
