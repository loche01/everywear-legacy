# crawl_missing_details.py
# -*- coding: utf-8 -*-

import pandas as pd
import time

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.common.exceptions import NoSuchElementException

# --- 설정만 바꿔주세요 ---
MISSING_IDS_CSV = "missing_ids.csv"               # 누락된 p_id 리스트 (한 열에 p_id만)
OUTPUT_CSV      = "missing_product_detail.csv"    # 출력될 파일명
BASE_URL        = "https://nomanual-shop.com/product/detail.html?product_no={}"
# -----------------------

def main():
    # 1) 크롬 드라이버 자동 설치 & 헤드리스 옵션
    opts = Options()
    opts.add_argument("--headless")
    opts.add_argument("--disable-gpu")
    service = Service(ChromeDriverManager().install())
    driver  = webdriver.Chrome(service=service, options=opts)

    # 2) 누락된 p_id 목록 불러오기
    df_ids = pd.read_csv(MISSING_IDS_CSV, dtype=int)
    ids = df_ids["p_id"].tolist()

    records = []
    for pid in ids:
        driver.get(BASE_URL.format(pid))
        time.sleep(1)  # 페이지 렌더링 대기 (필요하면 늘리세요)

        # 3) 가능한 모든 사이즈 버튼을 순회하며 재고 읽기
        size_buttons = driver.find_elements("css selector", "ul.ec-product-button li")
        if not size_buttons:
            # 옵션 자체가 없으면 빈값으로 기록
            records.append({"p_id": pid, "pd_size": None, "pd_stock": None})
            continue

        for btn in size_buttons:
            size = btn.text.strip()
            try:
                btn.click()
                time.sleep(0.2)
            except:
                pass

            # 재고를 담고 있는 엘리먼트(예: .quantity_price)에서 텍스트 추출
            try:
                stock_txt = driver.find_element("css selector", ".quantity_price").text
                # "3,000" 같은 문자를 숫자만 뽑아 정수로
                stock = int("".join(filter(str.isdigit, stock_txt)))
            except NoSuchElementException:
                stock = 0

            records.append({
                "p_id":     pid,
                "pd_size":  size,
                "pd_stock": stock
            })

    driver.quit()

    # 4) CSV로 저장
    out_df = pd.DataFrame(records, columns=["p_id","pd_size","pd_stock"])
    out_df.to_csv(OUTPUT_CSV, index=False, encoding="utf-8-sig")
    print(f"✅ 완료: {len(records)}개 레코드 → {OUTPUT_CSV}")

if __name__ == "__main__":
    main()
