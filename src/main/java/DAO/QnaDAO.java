package DAO;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import DTO.InquiryDTO;
import DTO.InquiryImgDTO;
import DTO.InquiryReplyDTO;

public class QnaDAO {
		private DBConnectionMgr pool;
		
		public QnaDAO() {
			pool = DBConnectionMgr.getInstance();
		}
		
		public static final String ENCTYPE = "UTF-8";
		public static int MAXSIZE = 5*1024*1024;
		
		private final SimpleDateFormat SDF_DATE = new SimpleDateFormat("yyyy-MM-dd");
		
		//공통 Q&A 등록
		public boolean insertQna(String id, String type, HttpServletRequest req) { return saveQna(id,type,req,false,false); }
		
		//전체 공통Q&A 출력
		public Vector<InquiryDTO> showAllQna(){
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			Vector<InquiryDTO> qlist = new Vector<InquiryDTO>();
			try {
				con = pool.getConnection();
				sql = "select * from inquiry where p_id is null and o_id is null order by created_at desc";
				pstmt = con.prepareStatement(sql);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					qlist.add(new InquiryDTO(rs.getInt(1), rs.getString(2), 
							rs.getString(3), rs.getInt(4), rs.getInt(5),
							rs.getString(6), rs.getString(7), SDF_DATE.format(rs.getDate(8)), rs.getString(9), rs.getString(10)));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return qlist;
		}
		
		//한 Q&A 상세 출력
		public InquiryDTO showOneQna(int id) {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			InquiryDTO qna = null;
			try {
				con = pool.getConnection();
				sql = "select * from inquiry where i_id = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, id);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					qna = new InquiryDTO(rs.getInt(1), rs.getString(2), 
							rs.getString(3), rs.getInt(4), rs.getInt(5), 
							rs.getString(6), rs.getString(7), SDF_DATE.format(rs.getDate(8)), rs.getString(9), rs.getString(10));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return qna;
		}
		
		//한 Q&A 이미지 출력
		public InquiryImgDTO showOneQnaImage(int id) {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			InquiryImgDTO qna = null;
			try {
				con = pool.getConnection();
				sql = "select * from inquiry_image where i_id = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, id);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					qna = new InquiryImgDTO(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return qna;
		}
		
		//한 Q&A 댓글 출력
		public InquiryReplyDTO showOneQnaReply(int id) {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			InquiryReplyDTO qna = null;
			try {
				con = pool.getConnection();
				sql = "select * from inquiry_reply where i_id = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, id);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					qna = new InquiryReplyDTO(
							rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4), SDF_DATE.format(rs.getDate(5))); 
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return qna;
		}
		
		//한 Q&A 수정
		public boolean updateQna(HttpServletRequest req) { return saveQna((String)req.getSession(false).getAttribute("id"),(String)req.getSession(false).getAttribute("userType"),req,true,false); }

		
		//한 Q&A 삭제
		public boolean deleteQna(int i_id, String id, String type, HttpServletRequest req) {
            return deleteOwnedPost("inquiry","i_id","inquiry_image","ii_url","Q&A_images",i_id,id,type,req);
        }
        private boolean saveQna(String id,String type,HttpServletRequest req,boolean update,boolean product) {
            Connection con=null;boolean reusable=false,success=false,commitAttempt=false,rolledBack=false;
            java.nio.file.Path directory=null;String saved=null;boolean replaceImage=false;java.util.List<String> oldFiles=new java.util.ArrayList<>();
            try{
                Security.AttachmentInput form=Security.AttachmentInput.read(req);
                String title=form.fields.get("title"),content=form.fields.get("content");
                if(title==null||title.isBlank()||title.length()>30||content==null||content.isBlank()||content.length()>10000) return false;
                replaceImage=form.image!=null || "Y".equals(form.fields.get("removeImage"));
                int iid=update?Integer.parseInt(form.fields.get("i_id")):0;
                int pid=product?Integer.parseInt(form.fields.get("p_id")):0;
                directory=Security.AttachmentInput.directory(req,"Q&A_images");
                con=pool.getConnection();con.setAutoCommit(false);reusable=true;
                if(update){
                    try(PreparedStatement q=con.prepareStatement("SELECT i_id FROM inquiry WHERE i_id=? AND user_id=? AND user_type=? FOR UPDATE")){
                        q.setInt(1,iid);q.setString(2,id);q.setString(3,type);try(ResultSet r=q.executeQuery()){if(!r.next())throw new java.sql.SQLException("Post unavailable.");}}
                    if(replaceImage)try(PreparedStatement q=con.prepareStatement("SELECT ii_url FROM inquiry_image WHERE i_id=?")){
                        q.setInt(1,iid);try(ResultSet r=q.executeQuery()){while(r.next())oldFiles.add(r.getString(1));}}
                }
                saved=form.save(directory);
                if(update){
                    try(PreparedStatement st=con.prepareStatement("UPDATE inquiry SET i_title=?,i_content=?,i_isPrivate=? WHERE i_id=? AND user_id=? AND user_type=?")){
                        st.setString(1,title);st.setString(2,content);st.setString(3,"on".equals(form.fields.get("private"))?"Y":"N");
                        st.setInt(4,iid);st.setString(5,id);st.setString(6,type);if(st.executeUpdate()!=1)throw new java.sql.SQLException("Post unavailable.");}
                    if(replaceImage)try(PreparedStatement st=con.prepareStatement("DELETE FROM inquiry_image WHERE i_id=?")){st.setInt(1,iid);st.executeUpdate();}
                }else{
                    try(PreparedStatement st=con.prepareStatement("INSERT INTO inquiry (user_id,user_type,p_id,i_title,i_content,created_at,i_isPrivate) VALUES (?,?,?,?,?,NOW(),?)",java.sql.Statement.RETURN_GENERATED_KEYS)){
                        st.setString(1,id);st.setString(2,type);if(product)st.setInt(3,pid);else st.setNull(3,java.sql.Types.INTEGER);
                        st.setString(4,title);st.setString(5,content);st.setString(6,"on".equals(form.fields.get("private"))?"Y":"N");
                        if(st.executeUpdate()!=1)throw new java.sql.SQLException("Post not saved.");
                        try(ResultSet keys=st.getGeneratedKeys()){if(!keys.next())throw new java.sql.SQLException("Post not saved.");iid=keys.getInt(1);if(iid<=0||keys.next())throw new java.sql.SQLException("Post not saved.");}}
                }
                if(saved!=null)try(PreparedStatement st=con.prepareStatement("INSERT INTO inquiry_image (i_id,ii_url) VALUES (?,?)")){
                    st.setInt(1,iid);st.setString(2,saved);if(st.executeUpdate()!=1)throw new java.sql.SQLException("Attachment not saved.");}
                commitAttempt=true;reusable=false;con.commit();reusable=true;success=true;
            }catch(Exception ignored){if(con!=null)try{con.rollback();rolledBack=true;}catch(Exception error){reusable=false;}}
            finally{
                if(con!=null){if(reusable)try{con.setAutoCommit(true);}catch(Exception error){reusable=false;}
                    if(reusable)pool.freeConnection(con);else pool.removeConnection(con);}
                if(success){for(String file:oldFiles)removeUnreferenced(directory,file, "inquiry_image", "ii_url");}
                else if(!commitAttempt&&rolledBack&&saved!=null)Security.AttachmentInput.remove(directory,saved);
            }
            return success;
        }
        private void removeUnreferenced(java.nio.file.Path directory,String file,String images,String column) {
            Connection connection=null;
            try {
                connection=pool.getConnection();
                try(PreparedStatement q=connection.prepareStatement("SELECT COUNT(*) FROM "+images+" WHERE "+column+"=?")){
                    q.setString(1,file);try(ResultSet r=q.executeQuery()){if(r.next()&&r.getInt(1)==0)Security.AttachmentInput.remove(directory,file);}
                }
            }catch(Exception ignored){ /* Keep orphan files when reference verification is unavailable. */ }
            finally{pool.freeConnection(connection);}
        }
        public boolean deleteOwnedPost(String table,String key,String images,String url,String folder,int postId,String id,String type,HttpServletRequest req) {
            if(!((table.equals("inquiry")&&key.equals("i_id")&&images.equals("inquiry_image")&&url.equals("ii_url")&&folder.equals("Q&A_images"))
                ||(table.equals("review")&&key.equals("r_id")&&images.equals("review_image")&&url.equals("ri_url")&&folder.equals("review_images"))))return false;
            Connection con=null;boolean reusable=false,success=false;java.util.List<String> files=new java.util.ArrayList<>();java.nio.file.Path directory=null;
            try{
                directory=Security.AttachmentInput.directory(req,folder);
                con=pool.getConnection();con.setAutoCommit(false);reusable=true;
                try(PreparedStatement q=con.prepareStatement("SELECT "+key+" FROM "+table+" WHERE "+key+"=? AND user_id=? AND user_type=? FOR UPDATE")){
                    q.setInt(1,postId);q.setString(2,id);q.setString(3,type);try(ResultSet r=q.executeQuery()){if(!r.next())throw new java.sql.SQLException("Post unavailable.");}}
                try(PreparedStatement q=con.prepareStatement("SELECT "+url+" FROM "+images+" WHERE "+key+"=?")){
                    q.setInt(1,postId);try(ResultSet r=q.executeQuery()){while(r.next())files.add(r.getString(1));}}
                try(PreparedStatement st=con.prepareStatement("DELETE FROM "+images+" WHERE "+key+"=?")){st.setInt(1,postId);st.executeUpdate();}
                try(PreparedStatement st=con.prepareStatement("DELETE FROM "+table+" WHERE "+key+"=? AND user_id=? AND user_type=?")){
                    st.setInt(1,postId);st.setString(2,id);st.setString(3,type);if(st.executeUpdate()!=1)throw new java.sql.SQLException("Post unavailable.");}
                reusable=false;con.commit();reusable=true;success=true;
            }catch(Exception ignored){if(con!=null)try{con.rollback();}catch(Exception error){reusable=false;}}
            finally{if(con!=null){if(reusable)try{con.setAutoCommit(true);}catch(Exception error){reusable=false;}
                if(reusable)pool.freeConnection(con);else pool.removeConnection(con);}}
            if(success)for(String file:files)removeUnreferenced(directory,file,images,url);
            return success;
        }
		
		//한사람이 쓴 모든 Q&A 출력
		public Vector<InquiryDTO> showUserQna(String id, String type){
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			Vector<InquiryDTO> qlist = new Vector<InquiryDTO>();
			try {
				con = pool.getConnection();
				sql = "select * from inquiry where user_id = ? and user_type = ? order by created_at desc";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, id);
				pstmt.setString(2, type);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					qlist.add(new InquiryDTO(rs.getInt(1), rs.getString(2), 
							rs.getString(3), rs.getInt(4), rs.getInt(5), rs.getString(6), 
							rs.getString(7), SDF_DATE.format(rs.getDate(8)), rs.getString(9), rs.getString(10)));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return qlist;
		}
		
		//한 상품의 Q&A 가져오기
		public Vector<InquiryDTO> getQnaForPd(int p_id){
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			Vector<InquiryDTO> qlist = new Vector<InquiryDTO>();
			try {
				con = pool.getConnection();
				sql = "select * from inquiry where p_id = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, p_id);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					qlist.add(new InquiryDTO(rs.getInt(1), rs.getString(2), 
							rs.getString(3), rs.getInt(4), rs.getInt(5), rs.getString(6), 
							rs.getString(7), SDF_DATE.format(rs.getDate(8)), rs.getString(9), rs.getString(10)));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return qlist;
		}
		
		//상품 Q&A 등록
		public boolean insertQna2(String id, String type, HttpServletRequest req) { return saveQna(id,type,req,false,true); }
}
