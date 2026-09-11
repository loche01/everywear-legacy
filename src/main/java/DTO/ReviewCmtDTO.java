package DTO;

public class ReviewCmtDTO {
	private int rc_id;
	private int r_id;
	private String rc_author_id;
	private String rc_author_type;
	private String rc_content;
	private String created_at;
	private String updated_at;
	private String rc_isDeleted;
	
	public ReviewCmtDTO() {}

	public ReviewCmtDTO(int rc_id, int r_id, String rc_author_id, String rc_author_type, String rc_content, String created_at,
			String updated_at, String rc_isDeleted) {
		super();
		this.rc_id = rc_id;
		this.r_id = r_id;
		this.rc_author_id = rc_author_id;
		this.rc_author_type = rc_author_type;
		this.rc_content = rc_content;
		this.created_at = created_at;
		this.updated_at = updated_at;
		this.rc_isDeleted = rc_isDeleted;
	}

	public int getRc_id() {
		return rc_id;
	}

	public void setRc_id(int rc_id) {
		this.rc_id = rc_id;
	}

	public int getR_id() {
		return r_id;
	}

	public void setR_id(int r_id) {
		this.r_id = r_id;
	}

	public String getRc_author_id() {
		return rc_author_id;
	}

	public void setRc_author_id(String rc_author_id) {
		this.rc_author_id = rc_author_id;
	}

	public String getRc_author_type() {
		return rc_author_type;
	}
	
	public void setRc_content(String rc_content) {
		this.rc_content = rc_content;
	}

	public String getRc_content() {
		return rc_content;
	}

	public void setRc_author_type(String rc_author_type) {
		this.rc_author_type = rc_author_type;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}

	public String getUpdated_at() {
		return updated_at;
	}

	public void setUpdated_at(String updated_at) {
		this.updated_at = updated_at;
	}

	public String getRc_isDeleted() {
		return rc_isDeleted;
	}

	public void setRc_isDeleted(String rc_isDeleted) {
		this.rc_isDeleted = rc_isDeleted;
	}
	
	
}
