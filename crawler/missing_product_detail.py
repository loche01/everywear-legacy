# crawl_missing_sizes.py
import requests
import pandas as pd
from bs4 import BeautifulSoup
from tqdm import tqdm
import time

BASE_URL = "https://nomanual-shop.com/product/detail.html?product_no={}"

def fetch_sizes(product_no: int) -> list[str]:
    """
    detail.html 페이지에서 SIZE 옵션(ul[option_title="SIZE"] li span)을 모두 리턴.
    """
    url = BASE_URL.format(product_no)
    resp = requests.get(url, headers={"User-Agent": "Mozilla/5.0"})
    resp.raise_for_status()
    soup = BeautifulSoup(resp.text, "html.parser")

    ul = soup.find("ul", attrs={"option_title": "SIZE"})
    if not ul:
        return []  # 옵션 자체가 없으면 빈 리스트

    sizes = []
    for li in ul.find_all("li"):
        span = li.find("span")
        if span and span.text.strip():
            sizes.append(span.text.strip())
    return sizes

def main():
    # 1) missing_ids.csv 에 p_id 컬럼이 있다고 가정
    df_ids = pd.read_csv("missing_ids.csv", dtype=int)
    rows = []

    for p_id in tqdm(df_ids["p_id"], desc="크롤링 중"):
        try:
            sizes = fetch_sizes(p_id)
        except Exception as e:
            print(f"  ❌ {p_id} 크롤링 실패:", e)
            sizes = []

        # 옵션이 하나도 없으면 그래도 한 줄 남기거나 스킵
        if not sizes:
            rows.append({"p_id": p_id, "pd_size": "",    "pd_stock": 100})
        else:
            for sz in sizes:
                rows.append({"p_id": p_id, "pd_size": sz,  "pd_stock": 100})

        time.sleep(0.5)  # 서버 부담을 줄이기 위해 잠시 대기

    # 2) DataFrame 으로 만든 뒤 CSV 저장
    df_out = pd.DataFrame(rows, columns=["p_id","pd_size","pd_stock"])
    df_out.to_csv("missing_product_detail.csv", index=False, encoding="utf-8-sig")
    print(f"\n✅ {len(df_out)}개 레코드 → missing_product_detail.csv")

if __name__ == "__main__":
    main()
