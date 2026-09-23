from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import NoSuchElementException
import pandas as pd
import time
import os
import re

def collect_products_in_category(wd, category_no, category_name):
    """
    - cate_no=category_no 페이지 접속
    - 'VIEW MORE' 버튼을 반복 클릭 -> 전체 상품 로드
    - BUY WITH 제외(.product-list.product-list-lg)
    - 추출된 상품번호 리스트 반환
    """
    base_url = "https://nomanual-shop.com/product/list.html?cate_no="
    url = f"{base_url}{category_no}"
    wd.get(url)
    time.sleep(3)

    print(f"[카테고리: {category_name}] {url} 접속 완료")

    while True:
        try:
            current_elem = wd.find_element(By.CSS_SELECTOR, "#more_current_page_11")
            total_elem = wd.find_element(By.CSS_SELECTOR, "#more_total_page_11")

            current_page = int(current_elem.text.strip())
            total_page = int(total_elem.text.strip())

            if current_page >= total_page:
                print(f"  모든 상품이 로드됨 (현재: {current_page}/{total_page})")
                break

            try:
                more_btn = wd.find_element(By.XPATH, "//a[contains(text(),'VIEW MORE')]")
                if more_btn.is_displayed():
                    print(f"  VIEW MORE 클릭 (현재 {current_page}/{total_page})")
                    wd.execute_script("arguments[0].click();", more_btn)
                    time.sleep(2)
                else:
                    print("  VIEW MORE 버튼 더 이상 표시되지 않음")
                    break
            except NoSuchElementException:
                print("  VIEW MORE 버튼 찾지 못함, 종료")
                break

        except NoSuchElementException:
            print("  #more_current_page_11 / #more_total_page_11 요소가 없음 -> 중단")
            break
        except ValueError:
            print("  페이지 값이 비어있거나 변환 불가 -> VIEW MORE 중단")
            break
        except Exception as e:
            print(f"  예외 발생: {e}")
            break

    product_links = []
    try:
        main_prod_links = wd.find_elements(By.CSS_SELECTOR, ".product-list.product-list-lg a[href*='product_no=']")
        for a_tag in main_prod_links:
            href = a_tag.get_attribute("href")
            if href and "product_no=" in href:
                product_links.append(href)
    except Exception as e:
        print(f"  상품 링크 수집 중 예외: {e}")

    product_links = list(set(product_links))
    print(f"  [카테고리 {category_name}] 상품 링크 수: {len(product_links)}개")

    product_nos = []
    for link in product_links:
        match = re.search(r"product_no=(\d+)", link)
        if match:
            product_nos.append(match.group(1))

    product_nos = list(set(product_nos))
    print(f"  => 실제 추출된 상품번호: {len(product_nos)}개")
    return product_nos


def extract_product_info(wd, product_no, category_name):
    """
    상품 상세페이지 -> SIZE/GUIDE(.toggle-item.active .toggle-item-content) 우선,
    없으면 #prdDetail fallback
    """
    detail_url = f"https://nomanual-shop.com/product/detail.html?product_no={product_no}"
    wd.get(detail_url)
    time.sleep(2)

    html_source = wd.page_source
    if ("상품이 존재하지 않습니다" in html_source) or (len(html_source) < 5000):
        print(f"    상품번호 {product_no} 존재하지 않는 상품")
        return None

    p_name = f"상품명 없음({product_no})"
    try:
        meta_author = wd.find_element(By.CSS_SELECTOR, "meta[name='author']")
        if meta_author:
            p_name = meta_author.get_attribute("content")
    except:
        pass

    if "상품명 없음" in p_name:
        try:
            name_elem = wd.find_element(By.CSS_SELECTOR, ".infoArea .name, p.name.fs-l5.fs-md-l4")
            if name_elem:
                p_name = name_elem.text.strip()
        except:
            pass

    p_price = 0
    try:
        body_text = wd.find_element(By.TAG_NAME, "body").text
        match = re.search(r"KRW\s+([\d,]+)", body_text)
        if match:
            price_str = match.group(1).replace(",", "")
            p_price = int(price_str)
    except:
        pass

    # SIZE/GUIDE
    p_text = ""
    try:
        guide_elem = wd.find_element(By.CSS_SELECTOR, ".toggle-item.active .toggle-item-content")
        if guide_elem:
            p_text = guide_elem.text.strip()
    except NoSuchElementException:
        pass
    except Exception as e:
        print(f"    SIZE/GUIDE 설명 예외: {e}")

    # fallback #prdDetail
    if not p_text or len(p_text) < 5:
        try:
            detail_area = wd.find_element(By.CSS_SELECTOR, "#prdDetail")
            fallback_desc = detail_area.text.strip()
            if fallback_desc:
                p_text = fallback_desc
        except NoSuchElementException:
            pass

    p_color = "정보 없음"
    if "-" in p_name:
        tail = p_name.split("-")[-1].strip()
        if len(tail) < 20:
            p_color = tail

    p_disc = "null"
    created_at = time.strftime("%Y-%m-%d %H:%M:%S")

    data = {
        "p_id": product_no,
        "p_category": category_name,
        "p_name": p_name,
        "p_price": p_price,
        "p_disc": p_disc,
        "p_text": p_text,
        "p_color": p_color,
        "created_at": created_at
    }

    print(f"    [디버깅] Info p_id={product_no}, name={p_name}, price={p_price}")
    return data


def extract_product_images_custom(wd, product_no):
    """
    (1) 썸네일(first_thumb) => product/tiny 만 저장 (정렬순서=1)
    (2) 추가이미지영역(.xans-product-addimage) vs 상세정보영역(.detail-area)
        - 각각 이미지 개수를 조사
        - 둘 중 더 많은 이미지가 있는 쪽만 수집
        - URL에 'product/small'이 포함된 것은 크롤링 제외
        - BUT 중복 URL은 '마지막으로 등장한' 정보가 우선
          => dict에 (appear_index, pid, url, ctime)로 저장, 계속 덮어쓰기
        - 최종적으로 등장 순으로 정렬 & pi_orders 재부여
    """
    product_url = f"https://nomanual-shop.com/product/detail.html?product_no={product_no}"
    wd.get(product_url)
    time.sleep(2)

    html_source = wd.page_source
    if ("상품이 존재하지 않습니다" in html_source) or (len(html_source) < 5000):
        print(f"    [이미지] 상품번호 {product_no} 존재하지 않음")
        return []

    created_at = time.strftime("%Y-%m-%d %H:%M:%S")

    # ================== dict 기반 중복 제거 (마지막 우선) ===================
    images_dict = {}  # key=url, value=(appear_index, product_no, url, created_at)
    appear_index = 1  # 등장 순서 (1부터)

    # --- 썸네일 ---
    try:
        thumb_area = wd.find_element(By.CSS_SELECTOR, ".thumb-image-area")
        thumb_imgs = thumb_area.find_elements(By.CSS_SELECTOR, ".thumb-wrap img")

        if thumb_imgs:
            first_thumb = thumb_imgs[0]
            thumb_src = first_thumb.get_attribute("src")
            # 썸네일은 'product/tiny'일 때만
            if thumb_src and ("product/tiny" in thumb_src):
                images_dict[thumb_src] = (appear_index, product_no, thumb_src, created_at)
                appear_index += 1
    except NoSuchElementException:
        print("    [이미지] 썸네일 영역 없음")
    except Exception as e:
        print(f"    썸네일 크롤링 중 예외: {e}")

    # --- 추가이미지 vs 상세정보 중 택1 ---
    add_img_urls = []
    try:
        add_block = wd.find_element(By.CSS_SELECTOR, ".xans-product-addimage")
        add_imgs = add_block.find_elements(By.TAG_NAME, "img")
        for img in add_imgs:
            src = img.get_attribute("src")
            if src and ("product/small" not in src):
                add_img_urls.append(src)
    except NoSuchElementException:
        pass
    except Exception as e:
        print(f"    추가 이미지 수집 예외: {e}")

    detail_img_urls = []
    try:
        detail_area = wd.find_element(By.CSS_SELECTOR, ".detail-area")
        detail_imgs = detail_area.find_elements(By.TAG_NAME, "img")
        for img in detail_imgs:
            data_src = img.get_attribute("ec-data-src")
            normal_src = img.get_attribute("src")
            final_src = data_src if data_src else normal_src
            if final_src and ("product/small" not in final_src):
                detail_img_urls.append(final_src)
    except NoSuchElementException:
        pass
    except Exception as e:
        print(f"    상세정보 이미지 수집 예외: {e}")

    if len(add_img_urls) >= len(detail_img_urls):
        chosen_imgs = add_img_urls
        chosen_area = "추가이미지영역"
    else:
        chosen_imgs = detail_img_urls
        chosen_area = "상세정보영역"

    # chosen_imgs를 순서대로 dict에 넣되, 동일 url이면 이전값 덮어쓰기
    for url in chosen_imgs:
        images_dict[url] = (appear_index, product_no, url, created_at)
        appear_index += 1

    # === dict -> list 변환: 마지막 등장 우선 (덮어쓰기) => 최종적으로 "등장 순서"로 정렬
    images_list = list(images_dict.values())  # (appear_index, p_id, url, created_at)
    images_list.sort(key=lambda x: x[0])  # appear_index 오름차순 정렬

    # === pi_orders 재배정 ===
    results = []
    for i, (a_idx, pid, url, ctime) in enumerate(images_list, start=1):
        results.append({
            "p_id": pid,
            "pi_url": url,
            "pi_orders": i,
            "created_at": ctime
        })

    print(f"    [디버깅] Images p_id={product_no}, "
          f"chosen_area={chosen_area}, total={len(results)}")
    return results


def main():
    results = []
    all_images = []

    category_mapping = {
        "102": "HEAVY OUTER",
        "153": "JUMPER",
        "155": "VEST",
        "103": "JACKET",
        "172": "HOODED ZIP-UP",
        "154": "WIND BREAKER",
        "156": "HOODIE",
        "159": "SWEAT SHIRT",
        "157": "T-SHIRT",
        "161": "SHIRT",
        "158": "LONG SLEEVE",
        "178": "SLEEVESS",
        "160": "KNIT/CARDIGAN",
        "162": "PANTS",
        "163": "DENIM",
        "164": "SHORTS",
        "165": "TRAINING PANTS",
        "171": "HEADGEAR",
        "167": "BAG",
        "168": "KEYRING",
        "169": "MUFFLER",
        "170": "ETC"
    }

    csv_products = os.path.join(os.getcwd(), "nomanual_products.csv")
    csv_images   = os.path.join(os.getcwd(), "nomanual_product_images.csv")

    chrome_options = Options()
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")

    try:
        wd = webdriver.Chrome(options=chrome_options)
        wd.maximize_window()
        print("Chrome 드라이버 초기화 성공")
    except Exception as e:
        print("Chrome 드라이버 초기화 오류:", e)
        return

    try:
        print("===== 카테고리 순회 시작 =====")
        for category_no, category_name in category_mapping.items():
            print(f"\n### 카테고리 {category_no}: {category_name}")

            product_nos = collect_products_in_category(wd, category_no, category_name)
            print(f" => 상품번호 {len(product_nos)}개 발견")

            for idx, pno in enumerate(product_nos, start=1):
                print(f"  ({idx}/{len(product_nos)}) 상품번호 {pno} 크롤링 중...")

                # 1) 상품 기본 정보
                product_data = extract_product_info(wd, pno, category_name)
                if not product_data:
                    continue

                # 가격 0원은 스킵
                if product_data["p_price"] == 0:
                    print("    → 0원, 스킵")
                    continue

                results.append(product_data)

                # 2) 이미지 (썸네일 + 둘 중 한 곳에서만), 중복 시 "마지막"을 유효화
                image_list = extract_product_images_custom(wd, pno)
                if image_list:
                    all_images.extend(image_list)

                # === 10개마다 중간 저장 ===
                if len(results) % 10 == 0:
                    df_prod = pd.DataFrame(results)
                    prod_cols = ["p_id","p_category","p_name","p_price","p_disc","p_text","p_color","created_at"]
                    df_prod = df_prod[prod_cols]
                    df_prod.to_csv(csv_products, index=False, encoding="utf-8-sig")

                    df_img = pd.DataFrame(all_images)
                    img_cols = ["p_id","pi_url","pi_orders","created_at"]
                    df_img = df_img[img_cols]
                    df_img.to_csv(csv_images, index=False, encoding="utf-8-sig")

                    print(f"  [중간 저장] 상품 {len(results)}개, 이미지 {len(all_images)}개")

            print(f"[{category_name}] 카테고리 끝")

        print("\n===== 모든 카테고리 크롤링 완료 =====")
        print(f"총 {len(results)}개 상품, 이미지 {len(all_images)}개 수집됨")

    except Exception as e:
        print("크롤링 중 오류:", e)

    finally:
        wd.quit()
        print("웹드라이버 종료")

        if results:
            df_prod = pd.DataFrame(results)
            prod_cols = ["p_id","p_category","p_name","p_price","p_disc","p_text","p_color","created_at"]
            df_prod = df_prod[prod_cols]
            df_prod.to_csv(csv_products, index=False, encoding="utf-8-sig")
            print(f"최종 상품 {len(results)}개 → {csv_products}")

        if all_images:
            df_img = pd.DataFrame(all_images)
            img_cols = ["p_id","pi_url","pi_orders","created_at"]
            df_img = df_img[img_cols]
            df_img.to_csv(csv_images, index=False, encoding="utf-8-sig")
            print(f"최종 이미지 {len(all_images)}개 → {csv_images}")
        else:
            print("추출된 이미지가 없습니다.")


if __name__ == "__main__":
    main()
