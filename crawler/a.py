#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pandas as pd

def multiline_to_html(text):
    """
    멀티라인 문자열 text를:
    - 줄바꿈(\n)을 <br>로 변환
    - 빈 줄은 <br><br>
    - 전체를 <p>...</p></div>로 감싸 리턴
    """
    lines = text.splitlines()  # or text.split('\n')
    output = []
    for line in lines:
        line_stripped = line.strip()
        if line_stripped == "":
            # 빈 줄 => <br><br>
            output.append("<br><br>")
        else:
            # 일반 줄 => line + <br>
            # 필요한 경우 line 내부의 <, >를 이스케이프 처리 가능
            output.append(line_stripped + "<br>")

    # 합치고 앞뒤에 <p>...</p></div>
    result = "<p>" + "".join(output) + "</p></div>"
    return result

def main():
    # 1) 엑셀 파일에서 p_id, p_text 읽기
    df = pd.read_excel("nomanual_products.xlsx", engine="openpyxl")

    # 2) SQL 문장들을 저장할 리스트
    sql_statements = []

    for _, row in df.iterrows():
        # p_id와 p_text 추출
        p_id = row['p_id']
        raw_text = str(row['p_text']) if pd.notna(row['p_text']) else ""

        # 멀티라인 -> HTML 변환
        html_text = multiline_to_html(raw_text)

        # SQL 구문에서 따옴표(')를 이스케이프(''로)해서 문법 깨지지 않도록
        html_text_escaped = html_text.replace("'", "''")

        # UPDATE 문
        # 예: UPDATE product SET p_text='~~~' WHERE p_id=123;
        # (id가 숫자라면 그냥 {p_id} 사용 가능)
        sql = f"UPDATE product SET p_text='{html_text_escaped}' WHERE p_id={p_id};"

        sql_statements.append(sql)

    # 3) 결과 SQL 파일로 저장
    output_file = "nomanual_update_ptext.sql"
    with open(output_file, "w", encoding="utf-8") as f:
        # 필요시 세미콜론 후 개행
        for stmt in sql_statements:
            f.write(stmt + "\n")

    print(f"{len(sql_statements)}개의 UPDATE 문을 {output_file}에 생성했습니다.")

if __name__ == "__main__":
    main()
