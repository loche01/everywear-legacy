#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
파일명: create_insert_statements.py

기능:
 1. nomanual_products.csv → product 테이블 INSERT 쿼리 생성
 2. nomanual_products_detail.csv → product_detail 테이블 INSERT 쿼리 생성
 3. nomanual_product_images.csv → product_image 테이블 INSERT 쿼리 생성

 - 생성된 쿼리를 nomanual_insert.sql 파일로 저장
 - 삽입 순서는 product → product_detail → product_image
   (FOREIGN KEY 제약을 위배하지 않도록)

사용 방법:
  python create_insert_statements.py
  실행 후 같은 폴더 내 'nomanual_insert.sql' 파일이 생성됩니다.
"""

import pandas as pd
import math
import os


# 문자열(특히 TEXT, VARCHAR) 컬럼에 대한 SQL escape 처리용 함수
def escape_string(value):
    """
    - None 또는 NaN -> 'NULL'
    - 문자열 내 싱글쿼트(') -> \' 로 치환
    - 문자열 양 끝에 따옴표 붙이기
    """
    if value is None or (isinstance(value, float) and math.isnan(value)):
        return "NULL"
    # 문자열 변환
    value = str(value)
    # 백슬래시, 따옴표 이스케이프
    value = value.replace("\\", "\\\\").replace("'", "\\'")
    return f"'{value}'"


# 숫자 컬럼(null 가능) 처리용 함수
def escape_number(value):
    """
    - None 또는 NaN -> 'NULL'
    - 그 외 -> 숫자 그대로
    """
    if value is None or (isinstance(value, float) and math.isnan(value)):
        return "NULL"
    return str(int(value))  # 정수로 변환 (소수점이 필요하면 float(value) 등 처리


# 날짜/시각 컬럼(null 가능) 처리용 함수
def escape_datetime(value):
    """
    - None 또는 NaN -> 'NULL'
    - 그 외 -> 'YYYY-MM-DD HH:MM:SS'
    """
    if value is None or (isinstance(value, float) and math.isnan(value)):
        return "NULL"
    # 날짜/시각 포맷에 맞춰 문자열 변환
    value = str(value).replace("T", " ")  # 혹시 '2025-03-10T12:23:00' 형태면 공백으로 치환
    # 이스케이프
    value = value.replace("'", "\\'")
    return f"'{value}'"


def main():
    # 스크립트와 동일 경로에 있는 CSV 파일명 (필요에 맞게 경로 수정)
    products_csv = "nomanual_products.csv"
    details_csv = "nomanual_products_detail.csv"
    images_csv = "nomanual_product_images.csv"

    # 결과를 저장할 SQL 파일
    output_sql_file = "nomanual_insert.sql"

    # -- 1) nomanual_products.csv → product 테이블
    #    [컬럼] p_id, p_category, p_name, p_price, p_disc, p_text, p_color, created_at
    if not os.path.exists(products_csv):
        print(f"[오류] {products_csv} 파일이 없습니다.")
        return

    df_products = pd.read_csv(products_csv, encoding='utf-8')
    insert_product_queries = []
    for _, row in df_products.iterrows():
        p_id = escape_number(row.get('p_id', None))
        p_category = escape_string(row.get('p_category', None))
        p_name = escape_string(row.get('p_name', None))
        p_price = escape_number(row.get('p_price', None))
        p_disc = escape_number(row.get('p_disc', None))
        p_text = escape_string(row.get('p_text', None))
        p_color = escape_string(row.get('p_color', None))
        created_at = escape_datetime(row.get('created_at', None))

        # INSERT INTO product (...)
        # VALUES (...);
        query = (
            f"INSERT INTO `product` "
            f"(`p_id`,`p_category`,`p_name`,`p_price`,`p_disc`,`p_text`,`p_color`,`created_at`) VALUES "
            f"({p_id},{p_category},{p_name},{p_price},{p_disc},{p_text},{p_color},{created_at});"
        )
        insert_product_queries.append(query)

    # -- 2) nomanual_products_detail.csv → product_detail 테이블
    #    [컬럼] pd_id, p_id, pd_size, pd_stock
    if not os.path.exists(details_csv):
        print(f"[오류] {details_csv} 파일이 없습니다.")
        return

    df_details = pd.read_csv(details_csv, encoding='utf-8')
    insert_product_detail_queries = []
    for _, row in df_details.iterrows():
        pd_id = escape_number(row.get('pd_id', None))
        p_id = escape_number(row.get('p_id', None))
        pd_size = escape_string(row.get('pd_size', None))
        pd_stock = escape_number(row.get('pd_stock', None))

        query = (
            f"INSERT INTO `product_detail` "
            f"(`pd_id`,`p_id`,`pd_size`,`pd_stock`) VALUES "
            f"({pd_id},{p_id},{pd_size},{pd_stock});"
        )
        insert_product_detail_queries.append(query)

    # -- 3) nomanual_product_images.csv → product_image 테이블
    #    [컬럼] pi_id, p_id, pi_url, pi_orders, created_at
    if not os.path.exists(images_csv):
        print(f"[오류] {images_csv} 파일이 없습니다.")
        return

    df_images = pd.read_csv(images_csv, encoding='utf-8')
    insert_product_image_queries = []
    for _, row in df_images.iterrows():
        pi_id = escape_number(row.get('pi_id', None))
        p_id = escape_number(row.get('p_id', None))
        pi_url = escape_string(row.get('pi_url', None))
        pi_orders = escape_number(row.get('pi_orders', None))
        created_at = escape_datetime(row.get('created_at', None))

        query = (
            f"INSERT INTO `product_image` "
            f"(`pi_id`,`p_id`,`pi_url`,`pi_orders`,`created_at`) VALUES "
            f"({pi_id},{p_id},{pi_url},{pi_orders},{created_at});"
        )
        insert_product_image_queries.append(query)

    # -- 삽입 순서: product → product_detail → product_image
    with open(output_sql_file, "w", encoding="utf-8") as f:
        f.write("-- =====================================\n")
        f.write("-- 1) PRODUCT INSERT\n")
        f.write("-- =====================================\n\n")
        for q in insert_product_queries:
            f.write(q + "\n")
        f.write("\n\n")

        f.write("-- =====================================\n")
        f.write("-- 2) PRODUCT_DETAIL INSERT\n")
        f.write("-- =====================================\n\n")
        for q in insert_product_detail_queries:
            f.write(q + "\n")
        f.write("\n\n")

        f.write("-- =====================================\n")
        f.write("-- 3) PRODUCT_IMAGE INSERT\n")
        f.write("-- =====================================\n\n")
        for q in insert_product_image_queries:
            f.write(q + "\n")

    print(f"[완료] {output_sql_file} 파일을 생성했습니다.")
    print("INSERT 쿼리 예시 (처음 3줄):")
    print("\n".join(insert_product_queries[:3]))


if __name__ == "__main__":
    main()
