# Legacy 검증 가이드

## 사전 확인

1. `git status`, branch, HEAD, repository-local Git identity와 remote 유무를 확인한다.
2. 격리 MySQL이 `127.0.0.1:3307/everywear_recovery`인지 확인한다.
3. 실제 credential을 출력하거나 테스트 파일에 복사하지 않는다.
4. 기존 forensic 원본과 시스템 MySQL은 사용하지 않는다.

## 정적 검증

- Java 21로 전체 Java source를 compile한다.
- 영향받은 JSP를 Tomcat 9/Jasper로 precompile하고 생성 Java도 Java 21로 확인한다.
- `git -c core.whitespace=cr-at-eol diff --check`로 CRLF-aware 검사를 한다.
- 변경 파일, diff stat, staged 파일을 명시적으로 확인한다.
- 변경·신규 라인에서 password, API key, secret, token, fixture/helper/runtime 흔적을 검사한다. 이 검사는 전체 Git history 감사와 별개다.

## Browser 회귀

HTTP 200만으로 성공 판정하지 않는다. 실제 DOM, console warning/error, network error와 Tomcat exception을 함께 확인한다.

- 사용자: main → login/logout → signup → 상품 목록 → 상품 상세/사이즈·재고 → cart
- 계정 보안: FORGOT → reset → 로그인, UNLOCK → reset → 로그인, POST·CSRF logout
- 관리자: login/logout → 주문 목록·검색·상세 → 결제 정보 → 배송·송장 → 환불 조회·생성·상태 전이

Naver, Gmail, CoolSMS, PortOne은 외부 credential과 운영 설정이 없는 상태에서 성공으로 판정하지 않는다.

## DB E2E

- fixture 계획에 생성 행, 기존 참조 행, marker, 정확한 cleanup SQL을 적는다.
- write 직전 port/schema와 기준 count를 재확인하고 승인을 기다린다.
- 명시적 컬럼과 generated key를 사용하며 예상 AUTO_INCREMENT 값을 하드코딩하지 않는다.
- 실패 시 rollback하고 조건을 완화하거나 전체 migration을 재실행하지 않는다.
- cleanup은 FK 역순과 정확한 PK·marker로 수행한다. 이후 기준 count와 sorted digest를 비교한다.

검증 후에도 `git add`/`commit` 직전에 diff와 민감정보 검사 결과를 보고하고 STOP한다.
