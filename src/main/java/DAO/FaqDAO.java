package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import DTO.FaqDTO;

public class FaqDAO {
	
	private DBConnectionMgr pool;
	
	public FaqDAO() {
		pool = DBConnectionMgr.getInstance();
	}
	
	//FAQ 출력
	public Vector<FaqDTO> showFaq(){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<FaqDTO> vlist = new Vector<FaqDTO>();
		try {
			con = pool.getConnection();
			sql = "select * from faq";
			pstmt = con.prepareStatement(sql);

			rs = pstmt.executeQuery();
			while(rs.next()) {
				FaqDTO faq = new FaqDTO();
				faq.setFaq_id(rs.getInt(1));
				faq.setFaq_title(rs.getString(2));
				faq.setFaq_content(rs.getString(3));
				vlist.add(faq);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
}
