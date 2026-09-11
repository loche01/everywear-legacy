package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import java.util.stream.Collectors;

import DTO.CouponDTO;
import DTO.UserCouponDTO;

public class CouponDAO {
		private DBConnectionMgr pool;
		
		public CouponDAO() {
			pool = DBConnectionMgr.getInstance();
		}
		private final SimpleDateFormat SDF_DATE = new SimpleDateFormat("yyyy-MM-dd");
		
		//한 유저의 모든 쿠폰 출력
		public Vector<UserCouponDTO> getUserAllCoupon(String id, String type) {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			Vector<UserCouponDTO> uclist = new Vector<UserCouponDTO>();
			try {
				con = pool.getConnection();
				sql = "select * from user_coupon where user_id = ? and user_type = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, id);
				pstmt.setString(2, type);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					UserCouponDTO uDto = new UserCouponDTO();
					uDto.setUser_cp_id(rs.getInt(1));
					uDto.setUser_id(rs.getString(2));
					uDto.setUser_type(rs.getString(3));
					uDto.setCp_id(rs.getInt(4));
					uDto.setAdmin_id(rs.getString(5));
					uDto.setCp_provide_date(SDF_DATE.format(rs.getDate(6)));
					uDto.setCp_using_date(rs.getDate(7) == null ? "" : SDF_DATE.format(rs.getDate(7)));
					uDto.setCp_using_state(rs.getString(8));
					uclist.add(uDto);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return uclist;
		}
		
		//쿠폰의 정보 출력
		public CouponDTO getCouponInfo(int cp_id) {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			CouponDTO cDto = null;
			try {
				con = pool.getConnection();
				sql = "select * from coupon where cp_id = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, cp_id);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					cDto = new CouponDTO(rs.getInt(1), rs.getString(2), rs.getString(3), 
							rs.getInt(4), SDF_DATE.format(rs.getDate(5)), 
							SDF_DATE.format(rs.getDate(6)), rs.getString(7), rs.getInt(8), rs.getString(9));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return cDto;
		}
		
		//한 유저의 쿠폰 만료일 순
		public List<UserCouponDTO> getUserCouponsByEndDate(String userId) {
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    String sql = null;
		    List<UserCouponDTO> list = new ArrayList<>();

		    try {
		        con = pool.getConnection();
		        sql = "SELECT " +
		              "  uc.user_cp_id, " +
		              "  uc.user_id, " +
		              "  uc.user_type, " +
		              "  uc.cp_id, " +
		              "  uc.admin_id, " +
		              "  uc.cp_provide_date, " +
		              "  uc.cp_using_date, " +
		              "  uc.cp_using_state, " +
		              "  c.cp_id, " +
		              "  c.cp_name, " +
		              "  c.cp_type, " +
		              "  c.cp_price, " +
		              "  c.cp_start, " +
		              "  c.cp_end, " +
		              "  c.cp_usable_state, " +
		              "  c.cp_min_price, " +
		              "  c.cp_user_rank " +
		              "FROM user_coupon uc " +
		              "JOIN coupon c ON uc.cp_id = c.cp_id " +
		              "WHERE uc.user_id = ? " +
		              "ORDER BY STR_TO_DATE(c.cp_end, '%Y-%m-%d') ASC";
		        
		        pstmt = con.prepareStatement(sql);
		        pstmt.setString(1, userId);
		        rs = pstmt.executeQuery();

		        while (rs.next()) {
		            // CouponDTO
		            CouponDTO cDto = new CouponDTO(
		                rs.getInt("cp_id"),
		                rs.getString("cp_name"),
		                rs.getString("cp_type"),
		                rs.getInt("cp_price"),
		                SDF_DATE.format(rs.getTimestamp("cp_start")),
		                SDF_DATE.format(rs.getTimestamp("cp_end")),
		                rs.getString("cp_usable_state"),
		                rs.getInt("cp_min_price"),
		                rs.getString("cp_user_rank")
		            );

		            // UserCouponDTO
		            UserCouponDTO uDto = new UserCouponDTO();
		            uDto.setUser_cp_id(rs.getInt("user_cp_id"));
		            uDto.setUser_id(rs.getString("user_id"));
		            uDto.setUser_type(rs.getString("user_type"));
		            uDto.setCp_id(rs.getInt("cp_id"));
		            uDto.setAdmin_id(rs.getString("admin_id"));
		            uDto.setCp_provide_date(SDF_DATE.format(rs.getDate("cp_provide_date")));
		            uDto.setCp_using_date(rs.getDate("cp_using_date") == null ? "" : SDF_DATE.format(rs.getDate("cp_using_date")));
		            uDto.setCp_using_state(rs.getString("cp_using_state"));
		            uDto.setCoupon(cDto); // 포함된 쿠폰 정보

		            list.add(uDto);
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        pool.freeConnection(con, pstmt, rs);
		    }

		    return list;
		}
		
		//상품 구매 시 사용 가능한 쿠폰 보여주기
		public List<Integer> getUserCouponIds(String userId, String userType) throws SQLException {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
		    List<Integer> cpIdList = new ArrayList<>();
			try {
				con = pool.getConnection();
				sql = "SELECT cp_id FROM user_coupon WHERE user_id = ? AND user_type = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, userId);
		        pstmt.setString(2, userType);
				rs = pstmt.executeQuery();
				while(rs.next())
					cpIdList.add(rs.getInt("cp_id"));
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
		    return cpIdList;
		}

		public List<Integer> getSortedCouponIdsByCpEnd(List<Integer> cpIdList) throws SQLException {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			List<Integer> sortedCpIds = new ArrayList<>();
			String placeholders = cpIdList.stream().map(id -> "?").collect(Collectors.joining(","));
			
			 if (cpIdList.isEmpty()) return sortedCpIds;
			
			try {
				con = pool.getConnection();
				 // SQL에서 IN 절을 동적으로 구성
			    sql = "SELECT cp_id FROM coupon WHERE cp_id IN (" + placeholders + ") ORDER BY STR_TO_DATE(cp_end, '%Y-%m-%d') ASC";
				pstmt = con.prepareStatement(sql);
				for (int i = 0; i < cpIdList.size(); i++) {
		            pstmt.setInt(i + 1, cpIdList.get(i));
		        }
				rs = pstmt.executeQuery();
				while (rs.next()) {
		            sortedCpIds.add(rs.getInt("cp_id"));
		        }
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
		    return sortedCpIds;
		}

		public List<UserCouponDTO> getUserCouponsInOrder(String userId, String userType, List<Integer> sortedCpIds) throws SQLException {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			List<UserCouponDTO> result = new ArrayList<>();
			try {
				con = pool.getConnection();
				sql = "SELECT * FROM user_coupon WHERE user_id = ? AND user_type = ? AND cp_id = ?";
				pstmt = con.prepareStatement(sql);
				 for (Integer cpId : sortedCpIds) {
			            pstmt.setString(1, userId);
			            pstmt.setString(2, userType);
			            pstmt.setInt(3, cpId);

			            rs = pstmt.executeQuery();
			            if (rs.next()) {
			                UserCouponDTO dto = new UserCouponDTO();
			                dto.setUser_cp_id(rs.getInt(1));
			                dto.setUser_id(rs.getString(2));
			                dto.setUser_type(rs.getString(3));
			                dto.setCp_id(rs.getInt(4));
			                dto.setAdmin_id(rs.getString(5));
			                dto.setCp_provide_date(SDF_DATE.format(rs.getDate(6)));
			                dto.setCp_using_date(rs.getDate(7) == null ? "" : SDF_DATE.format(rs.getDate(7)));
			                dto.setCp_using_state(rs.getString(8));
			                result.add(dto);
			            }
			        }

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
		    return result;
		}

}
