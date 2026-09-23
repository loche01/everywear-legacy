# make_sql_from_excel.py

import pandas as pd

def generate_sql_from_csv(csv_path: str, sql_path: str):
    # 1) CSV 읽기 (NA 허용)
    df = pd.read_csv(csv_path, keep_default_na=True)

    # 2) p_id, pd_stock 은 결측치 없애고 int 로 변환
    df["p_id"]      = df["p_id"].fillna(0).astype(int)
    df["pd_stock"]  = df["pd_stock"].fillna(0).astype(int)
    # 3) pd_size 는 빈 문자열로 채우고 따옴표 이스케이프
    df["pd_size"]   = df["pd_size"].fillna("").astype(str).str.replace("'", "''")

    with open(sql_path, "w", encoding="utf-8") as f:
        f.write("-- missing product_detail INSERT statements\n")
        for _, row in df.iterrows():
            p_id  = row["p_id"]
            size  = row["pd_size"]
            stock = row["pd_stock"]
            # pd_id 는 AUTO_INCREMENT 이므로 INSERT 에 포함하지 않습니다
            f.write(
                f"INSERT INTO product_detail (p_id, pd_size, pd_stock)\n"
                f"VALUES ({p_id}, '{size}', {stock});\n"
            )

if __name__ == "__main__":
    generate_sql_from_csv(
        csv_path="missing_product_detail.csv",
        sql_path="insert_missing_product_detail.sql"
    )
    print("✅ insert_missing_product_detail.sql 파일 생성 완료")
