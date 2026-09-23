# everyWEAR Legacy

Java/JSP 기반 의류 쇼핑몰 팀 프로젝트를, 프로젝트가 끝난 뒤 개인적으로 다시 실행 가능한 상태로 복구하고 보안 문제를 고친 저장소입니다.

흩어져 있던 여러 작업본을 비교해 실행환경과 DB를 복구했고, 인증·결제·데이터 변경 경로의 취약점을 정리했습니다. 공개된 SQL만으로 새 DB에 설치해 주요 기능이 동작하는 것을 확인했습니다.

## 프로젝트 개요

| 항목 | 내용 |
|---|---|
| 형태 | 팀 프로젝트(컴퓨터공학 전공 과정, 4명) → 종료 후 개인 복구·개선 |
| 기간 | 2025.04.18 ~ 2025.05.16 (팀 프로젝트) |
| 서비스 | 의류 쇼핑몰 (상품·회원·장바구니·찜·주문·Q&A·관리자) |
| 규모 | Java 소스 75개, JSP 108개, 상품 데이터 1,518개 |
| 기술 | Java 21, JSP/Servlet, JDBC, MySQL 8, Tomcat 9 |

## 나의 역할

**팀 프로젝트 (2025.04.18 ~ 2025.05.16, 4명) — 팀장**

- 일정 관리, 팀원 코드 통합, 최종 발표
- 관리자 기능 전체 개발: 이메일 인증 로그인, 대시보드, 회원·탈퇴 회원 관리, CRM, 상품 관리(등록·수정·이미지 업로드·3단계 카테고리 필터), 공지, 주문·배송·환불 처리
- 상품 데이터 수집 전담: Selenium 크롤러로 상품 1,518개·사이즈 3,513건·이미지 7,410건을 수집하고 DB 적재용 SQL로 변환 ([crawler/](crawler/))
- 함께 작업: DB 설계, DB 연결 관리, 로그인·회원가입, 상품 목록, 주문 내역·결제, 전체 기획과 화면 설계 (세부 UI 구현은 팀원 담당)

**프로젝트 종료 후 복구·개선 (개인)**

- 버전이 서로 다른 작업본을 비교해 하나의 실행 기준을 만들고, Java 21·Tomcat 9 기준으로 복구
- 보안 모듈 설계·구현: PBKDF2 비밀번호, CSRF, 본인확인 토큰, 업로드 검증, 관리자·사용자 접근 필터
- 결제 금액 위조 차단, 외부 서비스 키 분리, 공개 전 설정값·개인정보 정리
- 원본 상품 데이터·화면 복원과 사용자·관리자 기능 전체 검증(화면 79개)

## 주요 개선 사례

| 문제 | 해결 | 확인 |
|---|---|---|
| 작업본마다 DB 구조와 DAO 코드가 서로 맞지 않아 실행되지 않음 | 코드가 실제로 사용하는 테이블·컬럼을 기준으로 schema SQL을 다시 작성, DB 접속 정보를 환경변수로 분리 | 빈 MySQL에 공개 SQL만 적용해 설치·로그인·상품·장바구니 동작 확인 |
| 비밀번호가 평문으로 저장됨 | PBKDF2 해시로 저장, 기존 평문 계정은 로그인 성공 시 해시로 자동 전환 | 신규 설치 계정으로 로그인 후 해시 전환 확인 |
| 본인확인(OTP) 결과를 다른 용도·다른 사용자에게 재사용할 수 있음 | OTP를 목적·수신자와 묶고, 유효시간·시도 횟수 제한, 인증 결과를 1회만 쓰도록 변경 | 인증 흐름 회귀 테스트 |
| 로그인만 하면 다른 사람의 데이터를 수정할 수 있는 요청 경로 | 사용자·관리자 변경 요청에 POST 강제, CSRF 토큰, 본인 소유 여부 검증 추가 | GET 변경 요청 405 거부, 미인증 관리자 접근 차단 확인 |
| 클라이언트가 보낸 결제 금액을 검증 없이 저장해 금액 위조가 가능 | 결제는 아임포트 테스트 결제창까지만 진행하고 결과를 DB에 저장하지 않도록 변경, 입력값 escape와 금액 범위 검증 추가 | 결제 처리 페이지에서 주문·결제·배송 데이터를 만드는 코드 제거 |
| Java 21에서 인증 메일이 전혀 발송되지 않음 | JavaMail이 Java 21에서 막힌 TLS 1.0으로 연결하던 것을 TLS 1.2로 지정 | 관리자 인증번호 메일 실제 수신 확인 |
| DB 저장과 첨부파일 처리 중 한쪽만 실패하면 데이터가 어긋남 | 작업 단위 transaction·rollback, 업로드 파일 형식·크기 검증, 실패 시 파일 정리 | 테스트 후 DB 상태가 기준선과 일치 |

## 화면

| 메인 | 상품 목록 |
|---|---|
| <img src="docs/images/main.jpg" width="400"> | <img src="docs/images/product-list.jpg" width="400"> |
| **장바구니** | **테스트 결제창** |
| <img src="docs/images/cart.jpg" width="400"> | <img src="docs/images/test-payment.jpg" width="400"> |

<img src="docs/images/admin-orders.jpg" width="810">

관리자 주문 관리 화면 (샘플 주문 데이터)

## 주요 기능

- **상품** — 목록(카테고리별), NEW, BEST, 상세
- **회원** — 일반 로그인, Google·Kakao 로그인, 회원정보·배송지 관리, 비밀번호 찾기·계정 잠금 해제
- **쇼핑** — 장바구니 추가·수량 변경·삭제, 찜, 테스트 결제창
- **게시판** — Q&A 작성·수정·삭제, FAQ, 공지
- **관리자** — 이메일 인증 로그인, 대시보드, 회원·상품·공지 관리, 주문·배송·환불 처리

## 기술 스택

| 영역 | 기술 |
|---|---|
| Backend | Java 21, JSP, Servlet 4.0, JDBC |
| DB / Server | MySQL 8, Apache Tomcat 9 |
| Frontend | HTML, CSS, JavaScript |
| 외부 연동 | Google·Kakao OAuth, 아임포트(테스트), CoolSMS, Gmail SMTP |

Maven/Gradle 없이 Eclipse Dynamic Web Project 구조를 그대로 유지했습니다. 라이브러리는 `src/main/webapp/WEB-INF/lib`에 들어 있습니다.

## 프로젝트 구조

```text
src/main/java/
  Servlet/     요청 처리
  DAO/         DB 접근
  DTO/         데이터 전달 객체
  Filter/      사용자·관리자 접근 제어
  Security/    비밀번호 해시, OTP, CSRF, 업로드 검증
src/main/webapp/  JSP, CSS, JavaScript, 이미지
config/           환경변수 예시
db/               DB schema와 상품 데이터 SQL
crawler/          상품 데이터 수집에 쓴 Python 크롤러
docs/             복구 과정, 보안 변경, 알려진 문제
```

## 로컬 실행

### 1. 준비

- JDK 21, Tomcat 9, MySQL 8
- Eclipse에서 **Existing Projects into Workspace**로 가져온 뒤 JDK 21과 Tomcat 9 runtime 지정 (context root: `JSPTP`)
- MySQL Connector/J **8.0.32**를 받아 `src/main/webapp/WEB-INF/lib/`에 추가 (저장소에는 포함하지 않았습니다 — [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md))
  - https://dev.mysql.com/downloads/connector/j/ 또는 Maven `com.mysql:mysql-connector-j:8.0.32`

### 2. DB 초기화

**비어 있는 MySQL**에 `utf8mb4`로 접속해 저장소 루트에서 아래 순서대로 한 번만 실행합니다. 첫 파일이 `everywear_recovery` DB를 만듭니다.

```bash
mysql --default-character-set=utf8mb4 -h <DB_HOST> -P <DB_PORT> -u <ADMIN_USER> -p
```

```sql
SOURCE db/recovery_minimal.sql;
SOURCE db/recovery_cart_schema.sql;
SOURCE db/recovery_signup_schema.sql;
SOURCE db/recovery_admin_auth_schema.sql;
SOURCE db/recovery_order_schema.sql;
SOURCE db/recovery_qna_review_schema.sql;
SOURCE db/recovery_notice_schema.sql;
SOURCE db/recovery_faq_schema.sql;
SOURCE db/recovery_category_schema.sql;
SOURCE db/original_product_catalog.sql;
SOURCE db/original_product_image_url_fix.sql;
SOURCE db/original_product_detail_supplement.sql;
```

- 재실행에 안전하지 않은 구문이 있으므로 오류가 나면 다음 파일로 넘어가지 말고 원인을 확인하세요.
- `db/legacy-original/`은 참고용 원본이며 설치에 쓰지 않습니다.
- 자세한 내용은 [DB 복구와 데이터 구분](docs/db-recovery.md)을 참고하세요.

### 3. 환경변수

앱 전용 DB 계정을 만들어 `everywear_recovery`에 `SELECT, INSERT, UPDATE, DELETE` 권한만 주고, 아래 값을 Tomcat 실행 환경(Eclipse 실행 구성의 Environment 또는 `setenv.sh`)에 넣습니다. `.env` 파일을 자동으로 읽지는 않습니다.

| 변수 | 값 |
|---|---|
| `EVERYWEAR_DB_URL` | `jdbc:mysql://127.0.0.1:<DB_PORT>/everywear_recovery` |
| `EVERYWEAR_DB_USER` | 앱 전용 DB 계정 |
| `EVERYWEAR_DB_PASSWORD` | 해당 계정 비밀번호 |

소셜 로그인·SMS·메일은 선택 사항입니다. 필요한 변수 이름은 [config/recovery.env.example](config/recovery.env.example)에 있습니다. 설정하지 않아도 기본 쇼핑 기능은 동작하며, 회원가입·아이디 찾기처럼 문자·메일 발송이 필요한 흐름만 완료할 수 없습니다.

### 4. 실행

Tomcat에 배포한 뒤 `http://localhost:8080/JSPTP/main2.jsp`에 접속합니다.

| ID | Password |
|---|---|
| `recovery_user` | `recovery_test_only` |

로컬 확인용 테스트 계정입니다. 관리자 계정은 공개 SQL에 포함하지 않았습니다.

## 검증

원본 상품 데이터와 샘플 회원·주문을 넣은 로컬 서버에서 사용자·관리자 기능을 실행하며 화면 79개를 촬영해 기록했습니다.

- **데이터** — 상품 1,518 / 상세 3,513 / 이미지 7,410건이 모두 들어가고, 중복 키와 연결이 끊긴 행이 없음
- **사용자** — 로그인, 상품 목록·상세, 장바구니·찜, 주문 내역, 마이페이지, Q&A 작성
- **관리자** — 이메일 인증번호 로그인(실제 메일 수신), 회원정보 수정, 상품 수정, 공지 등록, 배송 상태 변경, 환불 처리
- **외부 연동** — Google·Kakao 실제 계정 로그인, 이니시스 테스트 결제창 호출
- **보안** — 변경 요청의 GET 차단, 미인증 관리자 접근 차단, 외부 주소 redirect 차단, 첫 로그인 시 비밀번호 해시 전환
- **빌드** — Java 소스 전체 컴파일

절차와 범위는 [검증 가이드](docs/test-guide.md)에 정리했습니다.

## 제한사항

- 결제는 테스트 결제창까지만 동작하며 주문·결제 내역은 저장하지 않습니다. 실제 PG 결제·환불은 구현하지 않았습니다.
- 문자 인증(CoolSMS)은 키를 설정하지 않아 휴대폰 인증이 필요한 회원가입·아이디 찾기를 끝까지 진행할 수 없습니다.
- Kakao는 개인 개발자 앱에 이메일을 주지 않아 회원번호로 회원을 식별합니다. Naver 로그인은 화면에서 제외했습니다(코드는 남아 있음).
- 상품 이미지는 원본 크롤링 당시의 외부 이미지 주소를 그대로 사용하므로 일부가 표시되지 않을 수 있습니다.
- 상품 1,518개 중 10개는 사이즈 정보를 찾지 못해 장바구니에 담을 수 없습니다. 재고 수량은 당시 일괄 입력한 값(100)입니다.
- 이메일 변경 재인증, 관리자 OTP 재설계, JSP 전체 HTML escaping은 아직 하지 않았습니다.

전체 목록은 [알려진 문제](docs/known-issues.md)에 있습니다.

## 관련 문서

- [복구 상태](docs/recovery-status.md)
- [DB 복구와 데이터 구분](docs/db-recovery.md)
- [계정·인증 보안](docs/auth-security.md)
- [검증 가이드](docs/test-guide.md)
- [알려진 문제](docs/known-issues.md)

## 다음 계획

이 저장소는 Legacy 상태로 유지하고, 별도 프로젝트에서 Spring Boot로 다시 만들 계획입니다. Controller–Service–Repository 구조, Spring Security, 트랜잭션 경계, 테스트 자동화를 적용하는 것이 목표입니다.

## 라이선스

원래 팀 프로젝트였던 코드이므로 별도의 오픈소스 라이선스를 부여하지 않습니다. 포함된 외부 라이브러리와 로그인 버튼 이미지는 각 원 라이선스와 브랜드 가이드라인을 따릅니다 — [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)
