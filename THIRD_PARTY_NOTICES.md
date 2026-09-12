# Third-Party Notices

이 저장소는 `src/main/webapp/WEB-INF/lib/`에 포함된 라이브러리와 `src/main/webapp/images/`의 일부 로그인 브랜드 자산에 대해 각 원 저작자의 라이선스를 따릅니다. 아래 목록은 이 저장소가 실제로 포함·사용하는 third-party 구성요소 전체입니다.

`mysql-connector-j`(MySQL Connector/J)는 라이선스 사유로 이 저장소에 바이너리를 포함하지 않습니다. 로컬 실행 시 준비 방법은 [README.md](README.md)를 참고하세요.

---

## Bundled JAR (`src/main/webapp/WEB-INF/lib/`)

### activation.jar

- **Component:** JavaBeans Activation Framework (JAF)
- **Version:** 1.1.x 계열로 추정됨 — jar manifest에 버전 문자열이 없어 exact version not identified. 클래스 빌드 타임스탬프(2009-09-27)가 공식 1.1.1 릴리스일(2009-10-23)보다 앞서 있어, 정식 1.1.1 배포본과 동일하다고 단정하지 않음.
- **Upstream:** Oracle / Sun Microsystems
- **License:** CDDL 1.0 (JAF 1.1.x 계열 공식 라이선스)
- **Usage in everyWEAR:** `src/main/java/DAO/GmailSend.java` — `mail.jar`(JavaMail)의 필수 동반 의존성
- **Redistribution notes:** CDDL 1.0은 소스 배포 시에만 소스 공개 의무가 발생하며, object code(바이너리) 재배포는 라이선스 사본 동봉만 요구함
- **Required notice:** 라이선스 사본 포함
- **License source:** [licenses/CDDL-1.0.txt](licenses/CDDL-1.0.txt) — jar 자체에는 라이선스 텍스트가 동봉되어 있지 않아 별도 보관

### cos.jar

- **Component:** com.oreilly.servlet (일명 "cos")
- **Version:** 공식 버전 태그 없음(빌드 타임스탬프 2008-12-26 기준)
- **Upstream:** Jason Hunter, https://www.servlets.com/cos/
- **License:** Jason Hunter 커스텀 라이선스(OSI 미승인 커스텀 라이선스)
- **Usage in everyWEAR:** `src/main/java/Security/AttachmentInput.java` — Q&A 첨부파일 업로드(`com.oreilly.servlet.multipart.MultipartParser`/`Part`/`ParamPart`/`FilePart`)
- **Redistribution notes:** 비상업적 제품에 한해 object code(class/jar) 형태로 재배포 허용. 아래 필수 조건을 모두 충족해야 함(전문은 [licenses/cos-license.txt](licenses/cos-license.txt) 참고):
  1. object code 형태로만, 제품의 주요 기능의 일부로 재배포
  2. 제품이 비상업적일 것
  3. 패키지의 public interface가 제품의 일반적 사용 중에는 최종 사용자에게 노출되지 않을 것
  4. SDK/OS/라이브러리/개발도구의 일부로 배포 시 저작권자의 서면 허가 필요
  5. 아래 Required notice 문구 포함
  6. 라이선스 조건 전문과 면책조항을 함께 배포
- **Required notice(원문 그대로 포함):** "The source code, object code, and documentation in the com.oreilly.servlet package is copyright and owned by Jason Hunter."
- **License source:** [licenses/cos-license.txt](licenses/cos-license.txt)(servlets.com 공식 원문)
- **참고:** 이 라이선스는 컴파일된 웹앱 배포를 전제로 작성되어, "소스 코드 형태로 공개된 저장소"에 조건 3(public interface 비노출)이 어떻게 적용되는지는 원문 자체가 명확히 다루지 않음. 법률적 확정 판단이 아니라 원문 기준의 위험 인지 사항으로 기록함.

### javaSDK-2.2.jar

- **Component:** CoolSMS Java SDK
- **Version:** 2.2
- **Upstream:** Nurigo, https://github.com/coolsms/java-sdk (archived, 유지보수 중단 상태)
- **License:** Apache License 2.0 — Maven Central POM(`net.nurigo:javaSDK:2.2`)에서 확인
- **Usage in everyWEAR:** `src/main/java/DAO/PhoneSMS.java` — CoolSMS 문자 발송
- **Redistribution notes:** 표준 Apache-2.0 조건(라이선스 사본 포함, 저작권 고지 유지)
- **Required notice:** 라이선스 사본 포함
- **License source:** [licenses/APACHE-2.0.txt](licenses/APACHE-2.0.txt) — jar 자체에는 라이선스 텍스트가 동봉되어 있지 않아 별도 보관

### json-20250107.jar

- **Component:** org.json (JSON-java)
- **Version:** 20250107
- **Upstream:** https://github.com/stleary/JSON-java
- **License:** Public Domain — 2022-09-24(20220924) 릴리스부터 프로젝트의 "Good, not Evil" 조항이 제거되고 LICENSE가 "Public Domain."으로 교체됨. 20250107은 그 이후 버전이므로 구 JSON License 조항이 적용되지 않음.
- **Usage in everyWEAR:** `Servlet/GoogleLoginServlet.java`, `Servlet/AdminLogin.java`, `Servlet/NaverLoginServlet.java`, `Servlet/KakaoLoginServlet.java`, `DAO/PhoneSMS.java`
- **Redistribution notes:** 사실상 제한 없음
- **Required notice:** 불필요(권장 수준)
- **License source:** https://raw.githubusercontent.com/stleary/JSON-java/master/LICENSE

### json-simple-1.1.1.jar

- **Component:** JSON.simple
- **Version:** 1.1.1
- **Upstream:** com.googlecode.json-simple
- **License:** Apache License 2.0 (jar manifest `Bundle-License` 확인)
- **Usage in everyWEAR:** `src/main/java/DAO/PhoneSMS.java`
- **Redistribution notes:** 표준 Apache-2.0 조건
- **Required notice:** 라이선스 사본 포함
- **License source:** [licenses/APACHE-2.0.txt](licenses/APACHE-2.0.txt) — jar 자체에는 라이선스 텍스트가 동봉되어 있지 않아 별도 보관

### jstl-1.2.jar

- **Component:** JavaServer Pages Standard Tag Library (JSTL) Reference Implementation
- **Version:** 1.2
- **Upstream:** Sun Microsystems / Oracle
- **License:** CDDL 1.0
- **Usage in everyWEAR:** JSP core taglib(`<%@ taglib %>`)
- **Redistribution notes:** 표준 CDDL 1.0 조건
- **Required notice:** jar 내부 `META-INF/LICENSE.txt`에 이미 동봉되어 있어 별도 조치 불필요
- **License source:** jar 내부 `META-INF/LICENSE.txt`(공식 원문과 동일 — [licenses/CDDL-1.0.txt](licenses/CDDL-1.0.txt) 참고 가능)

### mail.jar

- **Component:** JavaMail API
- **Version:** 1.4.6
- **Upstream:** Oracle
- **License:** CDDL 1.0 (GPLv2 + Classpath Exception 선택 가능, 이중 라이선스)
- **Usage in everyWEAR:** `src/main/java/DAO/GmailSend.java`
- **Redistribution notes:** 표준 CDDL 1.0 조건
- **Required notice:** jar 내부 `META-INF/LICENSE.txt`에 이미 동봉되어 있어 별도 조치 불필요
- **License source:** jar 내부 `META-INF/LICENSE.txt`(= [licenses/CDDL-1.0.txt](licenses/CDDL-1.0.txt), 이 파일에서 그대로 가져옴 — GPLv2 Classpath Exception 대안 조항도 함께 포함되어 있음)

### standard-1.1.2.jar

- **Component:** Jakarta Taglibs "standard"(JSTL 구현체)
- **Version:** 1.1.2
- **Upstream:** Apache Software Foundation — 공식 아카이브: https://archive.apache.org/dist/jakarta/taglibs/standard/binaries/jakarta-taglibs-standard-1.1.2.zip (1.1.2 릴리스일 2004-10-25를 1차 출처로 확인)
- **License:** Apache License 2.0 — 후신 프로젝트 공식 페이지(https://tomcat.apache.org/taglibs/standard/license.html)가 "The Apache Software License, Version 2.0"을 명시. 다만 1.1.2 배포 zip **내부**의 LICENSE 파일 원문을 직접 대조하지는 못했으며(다운로드 후 미해제 확인), 릴리스일이 ASF의 Apache 2.0 전환(2004년 초) 이후라는 정황 근거에 기반한 높은 신뢰도의 결론임 — 100% 원문 대조는 아님.
- **Usage in everyWEAR:** JSP core taglib(`jstl-1.2.jar`와 함께 사용)
- **Redistribution notes:** 표준 Apache-2.0 조건으로 추정
- **Required notice:** 라이선스 사본 포함 권장
- **License source:** [licenses/APACHE-2.0.txt](licenses/APACHE-2.0.txt)

---

## 로그인 브랜드 자산 (`src/main/webapp/images/`)

### google-signin.png

- **Upstream:** Google — [Sign in with Google Branding Guidelines](https://developers.google.com/identity/branding-guidelines)
- **출처:** 공식 사전승인 자산 ZIP(`https://developers.google.com/static/identity/images/signin-assets.zip`)에서 그대로 추출 — 리터칭/색상 변경/크롭 없음
- **선택 파일:** Android + Web / PNG @2x / Light / "Show text=No, Shape=Square"
- **Usage in everyWEAR:** [login.jsp](src/main/webapp/login.jsp) 소셜 로그인 버튼(아이콘, 별도 `<span>` 텍스트와 조합)
- **주의:** 브랜드 가이드는 "아이콘 단독 사용은 action button 등 제한적 경우"로만 언급하며, 계정유형 표시 등 다른 용도는 다루지 않음. 이번 정리로 myPage.jsp/crm/basic.jsp의 계정유형 표시는 이미지 대신 텍스트 배지로 전환하여 이 회색지대를 회피함.
- **상표 고지:** "Google"은 Google LLC의 상표입니다. 로고 사용은 위 공식 브랜딩 가이드라인을 따릅니다.

### kakao-login.png

- **Upstream:** Kakao — [카카오 로그인 디자인 가이드](https://developers.kakao.com/docs/latest/ko/kakaologin/design-guide), 리소스: https://developers.kakao.com/tool/resource/login
- **출처:** 공식 리소스 생성기에서 완성형(심볼+레이블+컨테이너) · English · Middle · Small 옵션으로 생성된 공식 PNG(`kakao_login_medium_narrow.png`, en)를 그대로 사용 — 리터칭/색상 변경 없음
- **Usage in everyWEAR:** [login.jsp](src/main/webapp/login.jsp) 소셜 로그인 버튼(심볼+레이블이 이미지 안에 포함된 완성형 버튼이므로 별도 텍스트 `<span>` 없이 이미지 단독 사용)
- **참고:** 공식 가이드는 "심볼 없이 카카오 로그인 버튼을 구성할 수 없다"고 명시하여, 완성형(전체) 버튼 자산만 공식적으로 제공됨. 이에 따라 myPage.jsp/crm/basic.jsp의 계정유형 표시는 이미지 대신 텍스트 배지로 전환함.
- **상표 고지:** "Kakao"는 카카오의 상표입니다. 로고 사용은 위 공식 디자인 가이드를 따릅니다.

### Naver — 이미지 자산 미포함

- 이전 `Naver.png`(출처 미확인)는 삭제했습니다.
- 이번 작업에서는 `developers.naver.com`(네이버 로그인 공식 브랜드 가이드 소재지)에 대한 접근이 이 세션의 도구 정책상 제한되어 있어 공식 자산을 확인·다운로드하지 못했습니다.
- 대신 [login.jsp](src/main/webapp/login.jsp)의 Naver 로그인 버튼은 이미지 없이 텍스트("Sign in with Naver")만 표시하도록 변경했습니다. 브랜드 색상/로고 형태를 임의로 흉내 내지 않았습니다.
- Naver OAuth 연동 로직 자체는 변경하지 않았습니다.
- 추후 https://developers.naver.com/docs/login/bi/ 에서 공식 자산을 직접 확인 후 교체하는 것을 권장합니다.

---

## 라이선스 원문 보관 (`licenses/`)

| 파일 | 대상 컴포넌트 |
|---|---|
| `licenses/APACHE-2.0.txt` | javaSDK-2.2.jar, json-simple-1.1.1.jar, standard-1.1.2.jar |
| `licenses/CDDL-1.0.txt` | activation.jar (jstl-1.2.jar/mail.jar는 jar 내부에 이미 동일 원문 동봉) |
| `licenses/cos-license.txt` | cos.jar (servlets.com 공식 원문 전체) |

`json-20250107.jar`(Public Domain)은 고지문이 짧아 이 문서 본문에 출처 링크만 남기고 별도 파일을 두지 않았습니다.
