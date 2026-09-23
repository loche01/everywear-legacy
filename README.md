# everyWEAR Legacy

Java/JSP 기반 의류 쇼핑몰 팀 프로젝트를 프로젝트 종료 후 개인적으로 복구·보안 개선하고, 공개 가능한 **Legacy Demo** 형태로 정리한 프로젝트입니다.

기존 코드의 실행환경과 DB 계약을 복구하고, 인증·데이터 변경 경로의 위험을 줄인 뒤 공개 SQL만으로 신규 설치와 주요 기능을 검증했습니다.

## 프로젝트 상태

- **원본 상품 카탈로그 복원 — PASS:** 당시 크롤링한 원본 상품 데이터(product 1,518 / product_detail 3,513 / product_image 7,410, 실제 상품명·가격·외부 이미지 URL 포함)를 공개 SQL로 복원했습니다. 합성 24개 Demo seed로 대체하지 않습니다.
- **PUBLIC FRESH INSTALL — PASS:** 공개 SQL과 원본 상품 카탈로그로 신규 설치·로그인·상품 목록/NEW/BEST/상세·장바구니·찜·텍스트 Q&A 검증 완료.
- **FINAL INTEGRATED REGRESSION — PASS WITH LIMITATIONS:** 별도의 복구 기준 DB에서 통합 회귀 검증 완료.
- 실제 결제·주문·배송을 수행하지 않는 Demo입니다. 외부 인증·문자·메일 서비스의 live E2E는 미검증입니다.
- 공개 저장소는 복구 기준 저장소와 분리된 새 Git history로 시작합니다.
- 상품 이미지는 당시 크롤링 대상 쇼핑몰(nomanual-shop.com)과 제휴 CDN(musinsa, msscdn, sixshop)의 외부 URL을 그대로 사용합니다. 자체 호스팅 이미지가 아니므로 외부 서비스 상태에 따라 일부 이미지가 로드되지 않을 수 있습니다.

## 팀 프로젝트와 나의 역할

### 팀 프로젝트

컴퓨터공학 전공 과정에서 Java/JSP/Servlet/JDBC/MySQL 기반 의류 쇼핑몰을 팀으로 개발했습니다. 상품·회원·주문과 관리자 화면 등 기존 기능과 구조는 팀 프로젝트의 결과물입니다.

### 당시 역할

팀장으로 프로젝트 진행을 조율하고, 상품·회원·주문 등 기능 간 관계와 DB 구조·관계 설계 조율에 참여했습니다.

### 이후 개인 복구·개선

프로젝트 종료 후 여러 Legacy 작업본을 분석해 실행환경과 DB를 복구하고, 보안·데이터 정합성 개선, 공개 부적합 데이터·파일 제거, Demo 정리와 회귀 검증을 개인적으로 수행했습니다.

## 주요 복구·개선 사례

| 문제 | 개인 복구·개선 | 결과·확인 범위 |
|---|---|---|
| 작업본마다 실행환경과 schema/DAO 계약이 달랐음 | Java 21·Tomcat 9 기준 정리, JDBC 설정의 환경변수 분리, schema migration 재구성 | 공개 SQL 8개와 합성 seed만으로 신규 설치 및 주요 runtime 동작 검증 |
| 평문 비밀번호와 본인확인 결과의 재사용 위험 | PBKDF2 저장·점진적 해시 전환, OTP 목적·수신자 결합, SecureRandom·SHA-256 digest·TTL·시도 제한, 일회성 VerificationGrant 소비 | 인증 회귀 검증 및 신규 설치 계정의 정상 로그인·해시 전환 확인. 이메일 변경 OTP·관리자 OTP 전체 재설계는 제외 |
| 로그인 여부만으로 데이터 변경을 허용하거나 타인 ID를 신뢰하는 경로 | 대상 사용자 mutation의 인증·POST·CSRF·소유권 검증, 관리자 상품·공지 등 변경 경로 보호 | 대표 사용자·관리자 mutation E2E로 정상 동작과 거부 경로 확인 |
| DB 변경과 첨부파일 처리 실패 시 데이터 불일치 위험 | 범위별 transaction·rollback, 업로드 형식·내용·크기 검증, 파일 처리 실패 보상 | 대표 fixture 정리 후 DB 기준선 일치. 파일과 DB의 완전한 원자성을 보장하는 구조는 아님 |
| 실제 PG 검증 없이 결제 완료를 신뢰하던 경로 | 결제·주문 생성, 적립금 변경, 결제 후 장바구니 삭제·SMS·PG 호출을 Demo 안내로 대체 | 실제 거래 없이 종료되는 안전 비활성화 상태 |

## 주요 기능

- **신규 Demo에서 검증:** 상품 목록·NEW·BEST·상세, 일반 로그인, 장바구니 추가·수량 변경·삭제, 찜 추가·삭제, 텍스트 Q&A 생성·수정·삭제.
- **Legacy 구현 포함:** 회원정보·배송지 관리, 회원가입·본인확인 경로, 관리자 상품·공지·회원·주문 관련 화면. 외부 서비스가 필요한 흐름과 관리자 화면은 기본 Demo 계정만으로 모두 체험할 수 없습니다.
- **제한된 기능:** 리뷰 조회·일부 보호 로직은 남아 있으나 신규 Demo의 작성·관리 흐름은 완전하지 않습니다. 결제는 Demo 안전 비활성화 상태입니다.

## 기술 스택

| 영역 | 사용 기술 |
|---|---|
| 서버 | Java 21, JSP, Servlet 4.0, JDBC |
| DB / 실행환경 | MySQL 8, Apache Tomcat 9 |
| 화면 | HTML, CSS, JavaScript |
| 포함 라이브러리 | JSTL 1.2 등(`WEB-INF/lib`에 포함). MySQL Connector/J 8.0.32는 별도 준비 필요 — [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) 및 아래 실행 방법 참고 |

Eclipse Dynamic Web Project 구조이며 Maven/Gradle 빌드 프로젝트가 아닙니다. 라이브러리는 `src/main/webapp/WEB-INF/lib`에 포함되어 있습니다.

## 프로젝트 구조

```text
src/main/java/
  Servlet/        요청 처리
  DAO/            JDBC 데이터 접근
  DTO/            데이터 전달 객체
  Filter/         사용자·관리자 요청 보호
  Security/       비밀번호·OTP·CSRF·업로드 검증
src/main/webapp/   JSP, CSS, JavaScript, 이미지, WEB-INF
config/           값 없는 환경변수 설정 예시
db/               복구 schema migration과 합성 Demo seed
docs/             복구 과정·검증 범위·제한사항
```

## 로컬 실행 방법

### 1. 실행환경 준비

JDK 21, Tomcat 9, MySQL 8을 준비합니다. 신규 설치는 독립 MySQL 8.0.46 환경에서 검증했습니다. 기존 데이터가 없는 별도 MySQL 환경을 사용하세요.

Eclipse의 **Existing Projects into Workspace**로 프로젝트를 가져오고 JDK 21과 Tomcat 9 runtime을 지정합니다. 저장소의 배포 설정은 `src/main/webapp`을 웹 루트로, Java 컴파일 결과를 `WEB-INF/classes`로 배포하며 context root는 `JSPTP`입니다.

### 2. MySQL Connector/J 준비

이 공개 저장소에는 `mysql-connector-j-8.0.32.jar`를 포함하지 않습니다. 실제 credential과 마찬가지로 이 바이너리도 저장소에 커밋하지 않는 방식을 택했습니다(사유는 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) 참고).

로컬 실행 전, 아래 중 한 곳에서 **정확히 8.0.32 버전**을 받아 `src/main/webapp/WEB-INF/lib/`에 추가하세요.

- 공식 배포: https://dev.mysql.com/downloads/connector/j/ (버전 8.0.32 선택)
- Maven Central: `com.mysql:mysql-connector-j:8.0.32`

`.gitignore`에 `src/main/webapp/WEB-INF/lib/mysql-connector-j-*.jar` 패턴이 등록되어 있어, 추가한 파일이 실수로 다시 커밋되지 않습니다.

### 3. DB 초기화

저장소 루트에서 신규 MySQL에 관리자 계정으로 접속한 뒤, **같은 MySQL 세션에서** 다음 순서대로 실행합니다. 접속 host·port가 기존 데이터베이스를 가리키지 않는지 먼저 확인하세요.

접속 시 `mysql --default-character-set=utf8mb4 -h <DB_HOST> -P <DB_PORT> -u <ADMIN_USER> -p`처럼 client charset을 명시적으로 `utf8mb4`로 지정합니다. client가 `latin1`로 동작하면 `복구사용자` 등의 한글 literal 적용이 실패할 수 있습니다.

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
```

`recovery_minimal.sql`이 `everywear_recovery` schema를 생성하고 선택하므로 CREATE DATABASE를 별도로 선실행하지 않습니다. 오류가 발생하면 다음 파일을 적용하지 말고 원인을 확인하세요.

- 빈 DB 기준 **1회 적용** 순서입니다. 일부 CREATE/ALTER와 seed는 재실행에 안전하지 않습니다. minimal SQL의 테스트 계정을 별도로 다시 INSERT하지 않습니다.
- schema 이름을 바꿀 경우 저장소 밖 SQL 사본의 `CREATE DATABASE`·`USE` 등 동일 schema 식별자를 모두 바꿉니다. 접속 시 기본 DB 이름만 바꾸어서는 격리되지 않습니다.
- `db/legacy-original/`은 참고 자료이며 초기화에 사용하지 않습니다. 실제 복구 baseline의 비공개 원본 데이터는 필요하지 않습니다.
- **1단계 — 상품 데이터 적재:** [원본 상품 카탈로그](db/original_product_catalog.sql)는 당시 크롤링한 원본 상품 product 1,518 · product_detail 3,513 · product_image 7,410 을 그대로 넣습니다. 실제 상품명·가격·설명·색상과 외부 CDN 이미지 URL을 포함합니다. 초기 테이블은 22개입니다. 상품 관련 3개 테이블, 사용자 1행, FAQ 21건, 카테고리 25건을 제외한 나머지 16개 테이블은 비어 있습니다.
- **2단계 — 최종 URL 보정 (1단계 직후 1회):** [이미지 URL 보정](db/original_product_image_url_fix.sql)은 원본 크롤링 당시 상대경로로 저장된 이미지 URL 181건만 `nomanual-shop.com` 기준 절대 URL로 보정합니다. 원본 카탈로그 SQL 내용 자체는 수정하지 않습니다.
- 과거 합성 24개 Demo seed(`db/demo_product_sample.sql`)는 제거했습니다. 원본 카탈로그와 함께 적용할 경우 `product_detail`의 고정 PK(1~65)가 충돌하므로 두 파일을 함께 적용하지 않습니다.

### 4. DB 계정과 환경변수

설치 후 전용 앱 DB 계정을 만들고 해당 schema에만 `SELECT, INSERT, UPDATE, DELETE` 권한을 부여합니다. 앱 실행에 관리자 계정이나 DDL 권한은 필요하지 않습니다.

[환경변수 예시](config/recovery.env.example)를 참고해 아래 값을 **실제 Tomcat 프로세스에 전달**합니다.

| 변수 | 설정 |
|---|---|
| `EVERYWEAR_DB_URL` | `jdbc:mysql://127.0.0.1:<DB_PORT>/everywear_recovery` — 실제 port/schema에 맞게 설정 |
| `EVERYWEAR_DB_USER` | 전용 앱 DB 계정 |
| `EVERYWEAR_DB_PASSWORD` | 해당 계정의 로컬 비밀번호 |
| `EVERYWEAR_DB_DRIVER` | 선택 사항. 기본값 `com.mysql.cj.jdbc.Driver` |

필요한 JDBC 연결 옵션은 로컬 MySQL의 인증·TLS·시간대 설정에 맞춥니다. 예시 파일의 `replace_me`는 실제 설정값이 아닙니다. `.env` 자동 로딩 기능은 없으며, Eclipse Tomcat 실행 구성의 Environment 또는 별도 Tomcat의 외부 `setenv.sh` 등으로 전달해야 합니다. 실제 비밀번호는 저장소에 넣지 않습니다.

기본 Demo 체험에는 OAuth·SMS·Gmail·PG credential을 설정하지 않습니다. 회원가입·아이디 찾기·전화번호 변경·비밀번호 복구 등 외부 발송이 필요한 흐름은 이 설정만으로 완료할 수 없습니다.

### 5. 실행과 Demo 로그인

프로젝트를 Tomcat에 추가해 빌드·배포하고 `/JSPTP/main2.jsp`에 접속합니다. Tomcat HTTP 포트가 8080이면 주소는 `http://localhost:8080/JSPTP/main2.jsp`입니다.

| 항목 | 값 |
|---|---|
| ID | `recovery_user` |
| Password | `recovery_test_only` |

**로컬 Demo 전용 계정이며 실제 서비스 credential이 아닙니다.** 공개 SQL에 포함되고 첫 정상 로그인에서 비밀번호가 해시로 전환됩니다. 관리자 계정은 공개 seed에 없습니다.

## 검증 결과

### 원본 카탈로그 복원 — PASS (disposable 환경, 정적+런타임 검증)

원본 크롤링 데이터 소스(`everyWEAR_recovered` 저장소, PHASE 7C 직전 commit)에서 상품 SQL을 추출해 별도 disposable MySQL 8.0.46·Tomcat 9(기존 실행 환경과 완전히 분리된 port/socket/datadir)에 적용해 검증했습니다.

- row count: `product` 1,518 / `product_detail` 3,513 / `product_image` 7,410 — 모두 기대값과 일치.
- PK 중복 0, `product_detail`·`product_image` orphan FK 0, 이미지가 없는 상품 0, `pi_orders=1` 이미지가 상품마다 정확히 1개.
- 이미지 URL 보정 적용 후 상대경로(`/web/...`) 잔존 0건.
- Java 21 전체 75개 소스 compile PASS(사전 존재하던 `finalize()` deprecation 경고 외 신규 오류·경고 없음).
- HTTP 200 확인: `main2.jsp`, `productList.jsp?cat=all/outer/top/bottom/acc`, `productNew.jsp`, `productBest.jsp`, `pdDetail.jsp`(사이즈 있는 상품·사이즈 없는 상품 모두), `login.jsp`. `productList.jsp?cat=all`은 실제로 1,518개 항목을 렌더링함을 확인.
- 보안 회귀 스팟체크: POST 미사용 mutation 요청 405 거부, 관리자 미인증 접근 시 `admin_login.jsp`로 302 리다이렉트, `login.jsp`의 외부 redirect 파라미터가 내부 경로로 정규화됨을 확인.
- 이번 세션에서는 108개 JSP 전체 precompile과 DB 연동 기능 회귀(로그인 세션, cart/wish CRUD)까지는 수행하지 않았습니다. 다음 단계 검증 대상입니다.

### 공개 SQL 신규 설치 — PUBLIC FRESH INSTALL: PASS (합성 Demo 24개 기준, 이전 세션)

2026-09-12, 독립 MySQL 8.0.46에 공개 SQL 8개(당시 `db/demo_product_sample.sql` 포함)를 순차 적용했습니다. 이 기록은 **원본 카탈로그 복원 이전**의 합성 24개 Demo seed 기준 검증이며, 현재 설치 절차는 위 원본 카탈로그로 대체되었습니다. Java 21 전체 소스 compile, JSP 108/108 precompile, 일반 로그인·장바구니·찜·텍스트 Q&A CRUD를 포함한 전체 절차는 과거 기록으로 유지합니다.

OAuth·SMS·Gmail·PG 등 외부 서비스 live E2E는 검증 범위에서 제외했습니다.

### 복구 기준 DB 통합 회귀 — PASS WITH LIMITATIONS

공개 신규 설치와 별개로, 비공개 복구 baseline에서 FINAL INTEGRATED REGRESSION을 완료했습니다. Java compile·JSP 108/108 확인과 탈퇴회원 복구, 관리자 변경 경로, OTP 본인확인 등 대표 fixture E2E를 통과했고, cleanup 후 20/20 table row count와 PK-sorted digest가 기준선과 일치했습니다.

관련 docs는 복구 단계별 기록을 포함합니다. 그 안의 신규 설치 미검증·README 미완료 문구는 이번 작업 이전 상태이며, 공개 신규 설치의 최신 결과는 위 기록을 기준으로 합니다. 과거 복구 commit은 현재 공개 Git history의 commit이 아닙니다.

## 제한사항

- PortOne 실제 PG 결제·취소·환불은 미구현입니다. 관리자 환불은 DB 상태 관리 수준입니다.
- Google/Kakao live OAuth E2E와 CoolSMS/Gmail live E2E는 미수행입니다. Naver 로그인은 로그인 화면 자체에서 이번 복원 범위 제외로 제공하지 않습니다.
- 이메일 변경 OTP는 미구현이며 관리자 OTP 전체 보안 재설계는 미완료입니다.
- OTP 발송에는 세션 cooldown이 적용되지만 IP·수신자 단위 rate limiting은 없습니다.
- 일부 미복구 리뷰 관리·작성 경로가 제한됩니다.
- 모든 JSP의 escaping과 DAO 예외처리를 전면 재구성한 것은 아닙니다. 파일·DB 처리 사이 비정상 종료 시 고아 파일 가능성도 남습니다.
- 상품 이미지는 자체 호스팅이 아닌 원본 크롤링 당시 외부 CDN URL을 그대로 사용합니다. 외부 서비스 상태·hotlink 정책에 따라 일부 이미지가 로드되지 않을 수 있습니다.
- 원본 상품 1,518개 중 314개는 원본 크롤링 데이터 자체에 사이즈(`product_detail`) 정보가 없어 장바구니 담기가 되지 않습니다(상품 상세 화면은 정상 표시).
- 로그인 화면은 Google/Kakao만 제공합니다. Naver 로그인 버튼은 이번 복원 범위에서 제외했습니다. `NaverLoginServlet`과 관련 보안 로직, `images/Naver.png`는 삭제하지 않고 남겨 두었으며 추후 별도로 재도입할 수 있습니다.

## 라이선스 및 권리

이 저장소는 원래 팀 프로젝트였던 코드를, 프로젝트 종료 후 개인이 복구·정리하여 공개하는 Legacy Demo입니다. 프로젝트 자체(팀이 작성한 코드)에는 별도의 오픈소스 라이선스(MIT/Apache/GPL 등)를 부여하지 않습니다. 저장소에 포함된 third-party 라이브러리와 로그인 브랜드 자산은 각각 원 라이선스 및 각 사의 브랜드 가이드라인을 따르며, 자세한 내용은 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)를 참고하세요.

## 관련 문서

- [문서 안내](docs/index.md)
- [복구 상태](docs/recovery-status.md)
- [DB 복구와 데이터 구분](docs/db-recovery.md)
- [계정·인증 보안](docs/auth-security.md)
- [검증 가이드](docs/test-guide.md)
- [알려진 문제와 보류 항목](docs/known-issues.md)
- [Third-Party Notices](THIRD_PARTY_NOTICES.md)

## 향후 계획

Legacy 공개와 포트폴리오 정리를 마친 뒤 별도 프로젝트에서 Spring Boot로 현대화할 계획입니다. Controller → Service → Repository 구조, Spring Security, Validation, 트랜잭션 경계와 테스트 자동화를 다룹니다. Spring/Spring Boot는 현재 Legacy 프로젝트의 기술 스택에 포함되지 않습니다.
