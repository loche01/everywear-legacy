package DAO;

import java.sql.*;
import java.util.*;

public class CategoryDAO {
    private DBConnectionMgr pool;

    public CategoryDAO() {
        pool = DBConnectionMgr.getInstance();
    }

    // 모든 카테고리 정보 가져오기
    public List<Map<String, String>> getAllCategories() {
        List<Map<String, String>> categories = new ArrayList<>();
        String sql = "SELECT category_name, top_category FROM category ORDER BY category_name";

        try (Connection con = pool.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, String> category = new HashMap<>();
                category.put("name", rs.getString("category_name"));
                category.put("parent", rs.getString("top_category"));
                categories.add(category);
            }
        } catch (Exception e) {
            System.out.println("getAllCategories 오류: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categories;
    }
    
    // 최상위 카테고리 가져오기 (top_category가 NULL인 카테고리)
    public List<String> getTopCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT category_name FROM category WHERE top_category IS NULL ORDER BY category_name";

        try (Connection con = pool.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                categories.add(rs.getString("category_name"));
            }
        } catch (Exception e) {
            System.out.println("getTopCategories 오류: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categories;
    }
    
    // 특정 상위 카테고리에 속한 하위 카테고리 가져오기
    public List<String> getSubCategories(String topCategory) {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT category_name FROM category WHERE top_category = ? ORDER BY category_name";

        try (Connection con = pool.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setString(1, topCategory);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    categories.add(rs.getString("category_name"));
                }
            }
        } catch (Exception e) {
            System.out.println("getSubCategories 오류: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categories;
    }
    
    // 전체 카테고리 계층 구조 구하기 (3단계 계층 지원)
    public Map<String, Map<String, List<String>>> getCategoryHierarchy() {
        Map<String, Map<String, List<String>>> hierarchy = new HashMap<>();
        
        // 모든 카테고리 정보 가져오기
        List<Map<String, String>> allCategories = getAllCategories();
        
        // 최상위 카테고리 가져오기
        List<String> topCategories = getTopCategories();
        
        // 각 최상위 카테고리별 처리
        for (String topCategory : topCategories) {
            Map<String, List<String>> subCategoryMap = new HashMap<>();
            hierarchy.put(topCategory, subCategoryMap);
            
            // 상위 카테고리 바로 아래의 하위 카테고리들
            List<String> directSubCategories = getSubCategories(topCategory);
            
            // 각 하위 카테고리별 처리
            for (String subCategory : directSubCategories) {
                // 하위 카테고리의 추가 하위 카테고리들
                List<String> thirdLevelCategories = getSubCategories(subCategory);
                subCategoryMap.put(subCategory, thirdLevelCategories);
            }
        }
        
        return hierarchy;
    }
} 