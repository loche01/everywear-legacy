package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Vector;

import DTO.FavoriteDTO;

public class FavoriteDAO {
	private DBConnectionMgr pool;
	
	public FavoriteDAO() {
		pool = DBConnectionMgr.getInstance();
	}
	private final SimpleDateFormat SDF_DATE = new SimpleDateFormat("yyyy-MM-dd");
	
    public boolean updateCart(int fid, int quantity, int pdid, String id, String type) {
        if (quantity < 1) return false;
        Connection con = null;
        try {
            con = pool.getConnection();
            try (PreparedStatement st = con.prepareStatement("UPDATE favorite f JOIN product_detail p ON f.pd_id=p.pd_id "
                    + "SET f.f_quantity=? WHERE f.f_id=? AND f.pd_id=? AND f.user_id=? AND f.user_type=? "
                    + "AND f.f_type='장바구니' AND p.pd_stock>=?")) {
                st.setInt(1,quantity); st.setInt(2,fid); st.setInt(3,pdid); st.setString(4,id); st.setString(5,type); st.setInt(6,quantity);
                return st.executeUpdate()==1;
            }
        } catch(Exception ignored) { return false; } finally { pool.freeConnection(con); }
    }
    public boolean deleteOwned(int[] ids, String id, String type, String kind) {
        if(ids==null || ids.length==0 || ids.length>100 || new java.util.HashSet<Integer>(java.util.Arrays.stream(ids).boxed().toList()).size()!=ids.length) return false;
        Connection con=null; boolean reusable=false, success=false;
        try {
            con=pool.getConnection(); con.setAutoCommit(false); reusable=true;
            for(int fid:ids) {
                try(PreparedStatement st=con.prepareStatement("DELETE FROM favorite WHERE f_id=? AND user_id=? AND user_type=? AND f_type=?")) {
                    st.setInt(1,fid);st.setString(2,id);st.setString(3,type);st.setString(4,kind);
                    if(st.executeUpdate()!=1) throw new java.sql.SQLException("Selection unavailable.");
                }
            }
            reusable=false;con.commit();reusable=true;success=true;
        }catch(Exception ignored){if(con!=null)try{con.rollback();}catch(Exception error){reusable=false;}}
        finally{if(con!=null){if(reusable)try{con.setAutoCommit(true);}catch(Exception error){reusable=false;success=false;}
            if(reusable)pool.freeConnection(con);else pool.removeConnection(con);}}
        return success;
    }
	//한 유저의 장바구니 출력
	public Vector<FavoriteDTO> getUserCart(String id, String type) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<FavoriteDTO> flist = new Vector<FavoriteDTO>();
		try {
			con = pool.getConnection();
			sql = "select * from favorite where user_id = ? and user_type = ? and f_type = '장바구니'";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, type);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				flist.add(new FavoriteDTO(rs.getInt(1), rs.getString(2), rs.getString(3), 
						rs.getInt(4), rs.getString(5), rs.getInt(6), SDF_DATE.format(rs.getDate(7))));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return flist;
	}
	
	//한 유저의 장바구니 수정(수량)
	public boolean updateCart(int f_id, int quantity, int pd_id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		int stock = 0;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "select pd_stock from product_detail where pd_id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, pd_id);
			rs = pstmt.executeQuery();
			if(rs.next())
				stock = rs.getInt(1);
			pstmt.close();
			rs.close();
			
			if(stock >= quantity) {
				sql = "update favorite set f_quantity = ? where f_id = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, quantity);
				pstmt.setInt(2, f_id);
				if(pstmt.executeUpdate() == 1)
					flag = true;
			} else {
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return flag;
	}
	
	//장바구니 삭제
	public boolean deleteCart(int f_id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "delete from favorite where f_id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, f_id);
			if(pstmt.executeUpdate() == 1)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	//한 장바구니 출력
	public FavoriteDTO getOneFavorite(int f_id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		FavoriteDTO f = null;
		try {
			con = pool.getConnection();
			sql = "select * from favorite where f_id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, f_id);
			rs = pstmt.executeQuery();
			if(rs.next())
				f = new FavoriteDTO(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getInt(4), rs.getString(5), rs.getInt(6), SDF_DATE.format(rs.getDate(7)));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return f;
	}
	
	//구매 후 장바구니 삭제
	public void deleteCartAfterOrder(int f_id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = pool.getConnection();
			sql = "delete from favorite where f_id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, f_id);
			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	//찜 목록 출력
	public Vector<FavoriteDTO> getUserWish(String id, String type){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<FavoriteDTO> wlist = new Vector<FavoriteDTO>();
		try {
			con = pool.getConnection();
			sql = "select * from favorite where user_id = ? and user_type = ? and f_type = '찜'";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, type);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				wlist.add(new FavoriteDTO(rs.getInt(1), rs.getString(2), 
						rs.getString(3), rs.getInt(4), rs.getString(5), rs.getInt(6), SDF_DATE.format(rs.getDate(7))));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return wlist;
	}
	
	//찜에서 장바구니로 추가
	public boolean addCartFromWish(String id, String type, int pd_id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "insert favorite values (null, ?, ?, ?, '장바구니', 1, now())";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, type);
			pstmt.setInt(3, pd_id);
			if(pstmt.executeUpdate() == 1)
				flag = true;

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	//찜 삭제
	public boolean deleteWish(int f_id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "delete from favorite where f_id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, f_id);
			if(pstmt.executeUpdate() == 1)
				flag = true;

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	//장바구니 추가
	public boolean addCart(String id, String type, int pd_id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "insert favorite values (null, ?, ?, ?, '장바구니', 1, now())";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, type);
			pstmt.setInt(3, pd_id);
			if(pstmt.executeUpdate() == 1)
				flag = true;

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	//찜 추가
	public boolean addWish(String id, String type, int pd_id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "insert favorite values (null, ?, ?, ?, '찜', 1, now())";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, type);
			pstmt.setInt(3, pd_id);
			if(pstmt.executeUpdate() == 1)
				flag = true;

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
}
