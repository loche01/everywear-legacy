<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
@charset "UTF-8";
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap');

:root {
    --main-color: #1e3a5f;
    --accent-color: #1abc9c;
    --text-dark: #333;
    --text-medium: #555;
    --text-light: #888;
    --bg-light: #f5f5f5;
    --bg-white: #fff;
    --shadow-sm: 0 2px 5px rgba(0,0,0,0.05);
    --shadow-md: 0 4px 8px rgba(0,0,0,0.1);
    --shadow-lg: 0 6px 15px rgba(0,0,0,0.15);
}

body {
    font-family: 'Noto Sans KR', '맑은 고딕', sans-serif;
    margin: 0;
    padding: 0;
    background-color: var(--bg-light);
    color: var(--text-dark);
    display: flex;
    flex-direction: column;
    min-height: 100vh;
    font-size: 15px;
    line-height: 1.6;
    font-weight: 400;
    letter-spacing: -0.01em;
}

/* 헤더 스타일 */
header {
    background-color: var(--main-color);
    color: white;
    padding: 0;
    box-shadow: var(--shadow-lg);
}

.header-container {
    max-width: 1300px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 20px;
    height: 70px;
}

/* 로고 스타일 */
.logo-container {
    display: flex;
    align-items: center;
}

.header-logo {
    height: 45px;
    width: auto;
    transition: transform 0.2s;
}

.header-logo:hover {
    transform: scale(1.05);
}

/* 로그아웃 버튼 스타일 */
.logout-container {
    margin-left: 20px;
}

.logout-btn {
    background-color: rgba(231, 76, 60, 0.85);
    color: white;
    padding: 9px 18px;
    border-radius: 5px;
    text-decoration: none;
    font-size: 14px;
    font-weight: 500;
    transition: all 0.3s;
    box-shadow: var(--shadow-sm);
    border: none;
    letter-spacing: 0.03em;
}

.logout-btn:hover {
    background-color: #e74c3c;
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
}

header h1 {
    margin: 0;
    font-size: 22px;
    font-weight: 500;
}

nav ul {
    display: flex;
    list-style: none;
    margin: 0;
    padding: 0;
}

nav ul li {
    margin-left: 20px;
}

nav ul li a {
    color: white;
    text-decoration: none;
    padding: 5px 10px;
    border-radius: 3px;
    transition: background-color 0.3s;
}

nav ul li a:hover, nav ul li a.active {
    background-color: var(--accent-color);
}

/* 메인 콘텐츠 스타일 */
main {
    padding: 30px 0;
    flex: 1;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    background-color: var(--bg-white);
    padding: 35px;
    border-radius: 8px;
    box-shadow: var(--shadow-sm);
}

h2 {
    margin-top: 0;
    margin-bottom: 25px;
    color: var(--main-color);
    font-size: 24px;
    font-weight: 600;
    letter-spacing: -0.02em;
}

h3 {
    font-size: 20px;
    font-weight: 500;
    color: var(--main-color);
    margin-bottom: 15px;
}

h4 {
    font-size: 18px;
    font-weight: 500;
    color: var(--text-dark);
}

p {
    margin-bottom: 15px;
    color: var(--text-medium);
    line-height: this1.7;
}

/* 버튼 스타일 */
.btn {
    padding: 9px 16px;
    border: none;
    border-radius: 4px;
    background-color: #f0f0f0;
    color: var(--text-dark);
    cursor: pointer;
    font-size: 14px;
    font-weight: 500;
    transition: all 0.3s;
    letter-spacing: 0.02em;
}

.btn:hover {
    background-color: #e0e0e0;
}

.btn-primary {
    background-color: #0a2963;
    color: white;
}

.btn-primary:hover {
    background-color: #0a2963;
    transform: translateY(-1px);
}

.btn-danger {
    background-color: #e74c3c;
    color: white;
}

.btn-danger:hover {
    background-color: #c0392b;
    transform: translateY(-1px);
}

.btn-sm {
    padding: 6px 10px;
    font-size: 13px;
}

/* 배지 스타일 */

/* 관리자 상단 메뉴 영역 */
.admin-nav {
    position: relative;
    flex: 1;
    margin: 0 30px;
}

/* 상위 메뉴 */
.main-menu {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    list-style: none;
    margin: 0;
    padding: 0;
    height: 70px;
}

.main-menu > li {
    position: relative;
    margin: 0;
    display: flex;
    align-items: center;
    justify-content: center;
}

.main-menu > li > a {
    display: block;
    width: 100%;
    height: 70px;
    line-height: 70px;
    text-align: center;
    color: white;
    font-weight: 500;
    font-size: 15px;
    text-decoration: none;
    transition: all 0.3s;
    border-bottom: 3px solid transparent;
    padding: 0;
    letter-spacing: 0.02em;
}

.main-menu > li > a:hover {
    background-color: rgba(255, 255, 255, 0.1);
    border-bottom: 3px solid var(--accent-color);
}

.main-menu > li > a.active {
    background-color: rgba(255, 255, 255, 0.15);
    border-bottom: 3px solid var(--accent-color);
    font-weight: 600;
}

/* 하위 메뉴 */
.megamenu {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    width: 100%;
    background-color: white;
    box-shadow: var(--shadow-lg);
    z-index: 1000;
    grid-template-columns: repeat(5, 1fr);
    gap: 0;
    padding: 25px 0;
    border-radius: 0 0 8px 8px;
    transition: all 0.3s;
}

/* 대시보드 메뉴에 대해서는 하위 메뉴를 표시하지 않음 */
.main-menu > li:first-child:hover + .megamenu {
    display: none;
}

.admin-nav:hover .megamenu {
    display: grid;
    animation: fadeIn 0.3s ease-in-out;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.menu-column {
    text-align: center;
    padding: 0 10px;
}

.menu-column h4 {
    font-size: 16px;
    margin-bottom: 12px;
    color: var(--main-color);
    border-bottom: 1px solid #eee;
    padding-bottom: 10px;
    font-weight: 600;
}

.menu-column a {
    display: block;
    margin-bottom: 10px;
    padding: 9px 5px;
    font-size: 14px;
    color: var(--text-medium);
    text-decoration: none;
    transition: all 0.2s;
    border-radius: 4px;
    font-weight: 400;
}

.menu-column a:hover {
    color: var(--main-color);
    background-color: #f8f9fa;
    transform: translateX(3px);
}

.menu-column a.active {
    color: var(--accent-color);
    font-weight: 500;
    background-color: #f8f9fa;
}

/* 푸터 스타일 */
footer {
    background-color: var(--main-color);
    color: white;
    padding: 20px 0;
    text-align: center;
    width: 100%;
}

.footer-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
}

footer p {
    margin: 0;
    font-size: 14px;
    opacity: 0.9;
    font-weight: 300;
}

/* 테이블 스타일 */
table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
    font-size: 14px;
}

th {
    background-color: #f8f9fa;
    color: var(--main-color);
    font-weight: 500;
    text-align: center;
    padding: 12px;
    border: 1px solid #e9ecef;
}

td {
    padding: 12px;
    border: 1px solid #e9ecef;
    text-align: center;
    color: var(--text-medium);
}

tbody tr:hover {
    background-color: #f8f9fa;
}

/* 반응형 디자인 */
@media (max-width: 768px) {
    .header-container {
        flex-direction: column;
        padding: 10px;
    }
    
    nav ul {
        flex-direction: column;
        margin-top: 10px;
    }
    
    nav ul li {
        margin: 5px 0;
    }
}
</style> 