#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
파일명: create_nomanual_products_detail.py

기능:
 1. nomanual_products.csv 파일을 로드한다.
 2. 각 상품(p_id)의 p_text 컬럼에서 사이즈 정보를 정규식으로 추출한다.
 3. 추출된 사이즈 정보로 (p_id, pd_size, pd_stock) 행을 구성한다.
 4. pd_id는 임시로 1부터 부여한다(AUTO_INCREMENT 대체).
 5. 최종 결과를 nomanual_products_detail.csv로 저장한다.
    (euckr_korean_ci 환경을 고려하여 encoding='cp949' 사용)
"""

import pandas as pd
import re

def main():
    # 1) 원본 CSV 로드
    input_file = "nomanual_products.csv"  # 실제 경로/파일명을 상황에 맞게 수정
    df = pd.read_csv(input_file, encoding='utf-8')  # 원본 파일이 utf-8이라면 'utf-8' 그대로

    # 2) p_text에서 사이즈 추출을 위한 정규식 함수
    def extract_sizes_from_text(text):
        if pd.isna(text):
            return []
        pattern = r"([A-Za-z0-9]+)\s*-\s*Length"
        matches = re.findall(pattern, text)
        # 중복 제거 및 알파벳순 정렬
        matches = sorted(set(matches))
        return matches

    # 사이즈 추출
    df['extracted_sizes'] = df['p_text'].apply(extract_sizes_from_text)

    # 3) product_detail 테이블에 들어갈 데이터 구성
    #    - pd_id    : 임시로 1부터 순차 부여 (실제 DB에선 AUTO_INCREMENT)
    #    - p_id     : 원본 df의 p_id
    #    - pd_size  : 추출된 사이즈
    #    - pd_stock : 일괄 100 (필요 시 수정)
    product_detail_rows = []
    pd_id_counter = 1

    for _, row in df.iterrows():
        p_id = row['p_id']
        sizes = row['extracted_sizes']
        # p_text에서 사이즈 정보가 전혀 없을 경우 건너뜀
        if not sizes:
            continue

        for size in sizes:
            product_detail_rows.append({
                "pd_id": pd_id_counter,
                "p_id": p_id,
                "pd_size": size,
                "pd_stock": 100
            })
            pd_id_counter += 1

    # 4) 데이터프레임 생성
    df_product_detail = pd.DataFrame(
        product_detail_rows,
        columns=["pd_id", "p_id", "pd_size", "pd_stock"]
    )

    # 5) 결과 CSV 저장
    #    euckr_korean_ci를 사용하는 MySQL 테이블에 맞추어 CSV 인코딩은 cp949 권장
    output_file = "nomanual_products_detail.csv"
    df_product_detail.to_csv(output_file, index=False, encoding='cp949')

    print(f"[완료] {output_file} 파일이 생성되었습니다.")
    print(df_product_detail.head(10))  # 확인용 출력

if __name__ == "__main__":
    main()
