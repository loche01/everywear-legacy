#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pandas as pd
import pymysql

def main():
    # 1) 엑셀 파일 읽기
    #    - nomanual_products.xlsx 에 p_id, p_text 열이 있다고 가정
    #    - engine="openpyxl"는 pandas가 Excel을 읽는 표준 방식
    df = pd.read_excel("nomanual_products.csv", engine="openpyxl")

    # 2) DB 연결
    connection = pymysql.connect(
        host='127.0.0.1',
        user='db_user',
        password='db_password',
        db='LeeDB',
        charset='utf8mb4'  # 멀티바이트 문자 처리
    )
    cursor = connection.cursor()

    # 3) 각 행을 순회하며 DB UPDATE
    updated_count = 0
    for idx, row in df.iterrows():
        p_id   = row['p_id']   # 상품번호 (INT)
        p_text = row['p_text'] # 여러 줄 텍스트

        # UPDATE 쿼리
        # - p_text만 바꾸고, 다른 칼럼은 유지
        # - p_id가 AUTO_INCREMENT PK라고 하셨으니, WHERE p_id=? 로 식별
        sql = """
        UPDATE product
           SET p_text = %s
         WHERE p_id = %s
        """
        cursor.execute(sql, (p_text, p_id))
        updated_count += 1

    # 최종 커밋
    connection.commit()
    cursor.close()
    connection.close()

    print(f"{updated_count}개 행의 p_text가 엑셀 내용으로 갱신되었습니다.")

if __name__ == "__main__":
    main()
