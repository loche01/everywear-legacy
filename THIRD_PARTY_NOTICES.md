# Third-Party Notices

이 저장소는 `src/main/webapp/WEB-INF/lib/`에 포함된 라이브러리와 `src/main/webapp/images/`의 일부 로그인 브랜드 자산에 대해 각 원 저작자의 라이선스를 따릅니다. 아래 목록은 이 저장소가 실제로 포함·사용하는 third-party 구성요소 전체입니다.

`mysql-connector-j`(MySQL Connector/J)는 라이선스 사유로 이 저장소에 바이너리를 포함하지 않습니다. 로컬 실행 시 준비 방법은 [README.md](README.md)를 참고하세요.

---

## Bundled JAR (`src/main/webapp/WEB-INF/lib/`)

### activation.jar

- **Component:** JavaBeans Activation Framework (JAF)
- **Version:** 1.1.1
- **Artifact:** `javax.activation:activation:1.1.1`
- **Upstream:** Sun Microsystems / Oracle
- **License:** CDDL 1.0 — 공식 POM에 명시. 공식 JAR의 `META-INF/LICENSE.txt` 및 source header는 GPLv2 + Classpath Exception 선택지도 제공함. 이 저장소의 배포 안내는 CDDL 1.0 기준
- **Binary:** [Maven Central 공식 binary](https://repo.maven.apache.org/maven2/javax/activation/activation/1.1.1/activation-1.1.1.jar) — 현재 저장소의 `activation.jar`와 byte-for-byte exact match (69,409 bytes)
- **SHA-256 (공식 binary 및 repo):** `ae475120e9fcd99b4b00b38329bd61cdc5eb754eee03fe66c01f50e137724f99`
- **Source:** `javax.activation:activation:1.1.1:sources` — [Maven Central 공식 source JAR](https://repo.maven.apache.org/maven2/javax/activation/activation/1.1.1/activation-1.1.1-sources.jar). 해당 링크에서 다운로드할 수 있으며, source JAR 자체는 이 저장소에 포함하지 않음
- **Metadata:** [공식 POM](https://repo.maven.apache.org/maven2/javax/activation/activation/1.1.1/activation-1.1.1.pom), binary JAR의 `META-INF/MANIFEST.MF` 및 라이선스 고지
- **Usage in everyWEAR:** `src/main/java/DAO/GmailSend.java` — JavaMail의 필수 동반 의존성
- **Redistribution notes:** 아래 CDDL 1.0 Section 3.1 및 소스 입수 안내 참고
- **Required notice:** JAR 내부의 원 저작권·라이선스 고지를 그대로 유지하고, 소스 입수 방법 및 CDDL 사본을 함께 안내
- **License source:** JAR 내부 `META-INF/LICENSE.txt` 및 [licenses/CDDL-1.0.txt](licenses/CDDL-1.0.txt) — 별도 파일은 순수 CDDL 1.0 전문이며, JAR 내부의 제품별 추가 고지는 그대로 보존

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
- **Artifact:** `javax.servlet:jstl:1.2`
- **Upstream:** Sun Microsystems / Oracle
- **License:** CDDL 1.0 — 공식 JAR의 `META-INF/LICENSE.txt` 및 source header에서 확인
- **Binary:** [Maven Central 공식 binary](https://repo.maven.apache.org/maven2/javax/servlet/jstl/1.2/jstl-1.2.jar) — 현재 저장소의 `jstl-1.2.jar`와 byte-for-byte exact match (414,240 bytes)
- **SHA-256 (공식 binary 및 repo):** `c6273119354a41522877e663582041012b22f8204fe72bba337ed84c7e649b0a`
- **Source:** `javax.servlet:jstl:1.2:sources` — [Maven Central 공식 source JAR](https://repo.maven.apache.org/maven2/javax/servlet/jstl/1.2/jstl-1.2-sources.jar). 해당 링크에서 다운로드할 수 있으며, source JAR 자체는 이 저장소에 포함하지 않음
- **Metadata:** [공식 POM](https://repo.maven.apache.org/maven2/javax/servlet/jstl/1.2/jstl-1.2.pom), binary JAR의 `META-INF/MANIFEST.MF` 및 라이선스 고지
- **Usage in everyWEAR:** JSP core taglib(`<%@ taglib %>`)
- **Redistribution notes:** 아래 CDDL 1.0 Section 3.1 및 소스 입수 안내 참고
- **Required notice:** JAR 내부의 원 저작권·라이선스 고지를 그대로 유지하고, 소스 입수 방법 및 CDDL 사본을 함께 안내
- **License source:** JAR 내부 `META-INF/LICENSE.txt` 및 [licenses/CDDL-1.0.txt](licenses/CDDL-1.0.txt) — 별도 파일은 순수 CDDL 1.0 전문이며, JAR 내부의 제품별 추가 고지는 그대로 보존

### mail.jar

- **Component:** JavaMail API
- **Version:** 1.4.6
- **Artifact:** `com.sun.mail:javax.mail:1.4.6`
- **Upstream:** Oracle
- **License:** CDDL 1.0 또는 GPLv2 + Classpath Exception — 공식 JAR의 `META-INF/LICENSE.txt`, POM/source header에서 확인. 이 저장소의 배포 안내는 CDDL 1.0 기준
- **Binary:** [Maven Central 공식 binary](https://repo.maven.apache.org/maven2/com/sun/mail/javax.mail/1.4.6/javax.mail-1.4.6.jar) — 현재 저장소의 `mail.jar`와 byte-for-byte exact match (521,054 bytes)
- **SHA-256 (공식 binary 및 repo):** `3d6d6f401c8e7370d99fca4aba2509df5435f8ae8e20504018704fae70ef34ed`
- **Source:** `com.sun.mail:javax.mail:1.4.6:sources` — [Maven Central 공식 source JAR](https://repo.maven.apache.org/maven2/com/sun/mail/javax.mail/1.4.6/javax.mail-1.4.6-sources.jar). 해당 링크에서 다운로드할 수 있으며, source JAR 자체는 이 저장소에 포함하지 않음
- **Metadata:** [공식 POM](https://repo.maven.apache.org/maven2/com/sun/mail/javax.mail/1.4.6/javax.mail-1.4.6.pom), binary JAR의 `META-INF/MANIFEST.MF` 및 라이선스 고지
- **Usage in everyWEAR:** `src/main/java/DAO/GmailSend.java`
- **Redistribution notes:** 아래 CDDL 1.0 Section 3.1 및 소스 입수 안내 참고
- **Required notice:** JAR 내부의 원 저작권·라이선스 고지를 그대로 유지하고, 소스 입수 방법 및 CDDL 사본을 함께 안내
- **License source:** JAR 내부 `META-INF/LICENSE.txt` 및 [licenses/CDDL-1.0.txt](licenses/CDDL-1.0.txt) — 별도 파일은 순수 CDDL 1.0 전문이며, JAR 내부의 제품별 추가 고지는 그대로 보존

### standard-1.1.2.jar

- **Component:** Jakarta Taglibs "standard"(JSTL 구현체)
- **Version:** 1.1.2
- **Upstream:** Apache Software Foundation — 공식 아카이브: https://archive.apache.org/dist/jakarta/taglibs/standard/binaries/jakarta-taglibs-standard-1.1.2.zip (1.1.2 릴리스일 2004-10-25를 1차 출처로 확인)
- **License:** Apache License 2.0 — 후신 프로젝트 공식 페이지(https://tomcat.apache.org/taglibs/standard/license.html)가 "The Apache Software License, Version 2.0"을 명시. 다만 1.1.2 배포 zip **내부**의 LICENSE 파일 원문을 직접 대조하지는 못했으며(다운로드 후 미해제 확인), 릴리스일이 ASF의 Apache 2.0 전환(2004년 초) 이후라는 정황 근거에 기반한 높은 신뢰도의 결론임 — 100% 원문 대조는 아님.
- **Usage in everyWEAR:** JSP core taglib(`jstl-1.2.jar`와 함께 사용)
- **Redistribution notes:** 표준 Apache-2.0 조건으로 추정
- **Required notice:** 라이선스 사본 포함 권장
- **License source:** [licenses/APACHE-2.0.txt](licenses/APACHE-2.0.txt)

### CDDL 1.0 Section 3.1 및 소스 입수 안내

[Oracle의 공식 CDDL 1.0 원문](https://oss.oracle.com/licenses/CDDL) Section 3.1에 따르면, Covered Software를 Executable 형태로 배포하거나 제공할 때는 이에 대응하는 Source Code도 이용 가능해야 합니다. 해당 Source Code는 CDDL 조건으로 배포하고 그 사본마다 라이선스 사본을 포함해야 하며, 수령인에게 통상적인 소프트웨어 교환 매체를 통해 합리적인 방법으로 소스를 얻는 방법을 알려야 합니다. 바이너리 배포가 라이선스 사본 동봉만으로 충분하다는 의미가 아닙니다.

위 Activation, JavaMail, JSTL 항목의 공식 source JAR 링크는 각 배포 버전에 대응하는 소스 입수 위치입니다. 각 source JAR의 다운로드 가능 여부와 Java source header를 확인했습니다. Activation과 JSTL source JAR에는 독립된 LICENSE 파일이 없으므로, 소스를 재배포할 때는 기존 고지를 유지하고 [CDDL 1.0 사본](licenses/CDDL-1.0.txt)을 함께 제공해야 합니다. JavaMail source JAR에는 제품별 라이선스 파일이 포함되어 있습니다.

이 문서는 확인한 artifact와 소스 제공 방법을 기록한 것이며, 라이선스 준수에 대한 법적 보증이나 확정 판단은 아닙니다.

---

## 로그인 브랜드 자산 (`src/main/webapp/images/`)

**2026-09 업데이트:** 원본 팀 프로젝트(2025) 당시 실제로 사용했던 로그인 화면 UI를 복원하기로 결정하면서, 아래 `google-signin.png`/`kakao-login.png`(공식 브랜딩 자산으로 별도 교체했던 파일) 대신 원본 팀 프로젝트의 `Google.png`/`kakao.png`를 다시 사용합니다. 이 문서는 그 결정과 두 자산군의 출처 차이를 사실대로 기록합니다. 법적 판단이나 라이선스 적합성 보증은 아닙니다.

### Google.png, kakao.png, Naver.png (현재 사용 중 — Google/Kakao) / 보존 자산 (Naver)

- **출처:** 2025년 원본 팀 프로젝트에서부터 사용되던 파일입니다. 정확한 최초 출처(디자이너 제작, 웹 검색, 리소스 사이트 등)는 팀 프로젝트 당시 기록이 남아있지 않아 **확인되지 않습니다.**
- **크기:** `Google.png` 28×28, `kakao.png` 40×40, `Naver.png` 54×54.
- **Usage in everyWEAR:** [login.jsp](src/main/webapp/login.jsp)의 Google/Kakao 소셜 로그인 버튼(아이콘 + 별도 `<span>` 텍스트 조합), [myPage.jsp](src/main/webapp/myPage.jsp)/[crm/basic.jsp](src/main/webapp/crm/basic.jsp)의 가입 경로 표시 아이콘.
- **Naver.png는 로그인 화면에서 사용하지 않습니다.** 사용자 확정 요구사항에 따라 Naver 로그인 버튼을 로그인 화면에서 제외했습니다(OAuth 로직·`NaverLoginServlet`은 유지). 파일은 향후 재도입을 위해 미사용 자산으로 저장소에 보존합니다.
- 이 세 파일 모두 출처가 확인되지 않은 자산입니다. 사용자가 프로젝트 당시 교육기관 강사 및 대상 서비스와 상의했다고 밝힌 원본 팀 프로젝트 자산이며, 상표권자의 별도 라이선스 확인 없이 사용 중입니다.

### google-signin.png, kakao-login.png — 제거됨 (2026-09-13 추가, 2026-09-16 제거)

- 공개 정리 과정에서 한 차례 위 원본 아이콘을 대체하기 위해 각 사의 공식 브랜딩 자산으로 교체한 적이 있습니다(Google [Sign in with Google Branding Guidelines](https://developers.google.com/identity/branding-guidelines) 사전승인 자산, Kakao [로그인 디자인 가이드](https://developers.kakao.com/docs/latest/ko/kakaologin/design-guide) 공식 리소스 생성기 산출물).
- 이후 원본 팀 프로젝트 UI를 복원하기로 하면서 이 두 파일은 로그인 화면에서 더 이상 참조되지 않아 저장소에서 제거했습니다.
- Naver의 경우 이 교체 시점에 공식 대체 자산을 확인하지 못해(`developers.naver.com` 접근 제한) 기존 `Naver.png`를 삭제하고 텍스트 전용 버튼으로 전환한 이력이 있습니다. 이번 복원에서 `Naver.png` 자체는 다시 복원했으나, 로그인 화면에는 노출하지 않습니다(위 항목 참고).

---

## 라이선스 원문 보관 (`licenses/`)

| 파일 | 대상 컴포넌트 |
|---|---|
| `licenses/APACHE-2.0.txt` | javaSDK-2.2.jar, json-simple-1.1.1.jar, standard-1.1.2.jar |
| `licenses/CDDL-1.0.txt` | activation.jar, mail.jar, jstl-1.2.jar — [Oracle 공식 CDDL 1.0 전문](https://oss.oracle.com/licenses/CDDL), 행 끝 공백만 정리. JAR 내부 제품별 라이선스 고지는 별도로 유지 |
| `licenses/cos-license.txt` | cos.jar (servlets.com 공식 원문 전체) |

`json-20250107.jar`(Public Domain)은 고지문이 짧아 이 문서 본문에 출처 링크만 남기고 별도 파일을 두지 않았습니다.
