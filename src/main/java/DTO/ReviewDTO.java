package DTO;

public class ReviewDTO {
	private int r_id;
	private String user_id;
	private String user_type;
	private int pd_id;
	private String r_content;
	private int r_rating;
	private String created_at;
	private String updated_at;
	private int r_report_count;
	private String r_isHidden;
	
	public ReviewDTO() {}

	public ReviewDTO(int r_id, String user_id, String user_type, int pd_id, String r_content, int r_rating,
			String created_at, String updated_at, int r_report_count, String r_isHidden) {
		super();
		this.r_id = r_id;
		this.user_id = user_id;
		this.user_type = user_type;
		this.pd_id = pd_id;
		this.r_content = r_content;
		this.r_rating = r_rating;
		this.created_at = created_at;
		this.updated_at = updated_at;
		this.r_report_count = r_report_count;
		this.r_isHidden = r_isHidden;
	}

	public int getR_id() {
		return r_id;
	}

	public void setR_id(int r_id) {
		this.r_id = r_id;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	
	public String getUser_type() {
		return user_type;
	}
	
	public void setUser_type(String user_type) {
		this.user_type = user_type;
	}
	
	public int getPd_id() {
		return pd_id;
	}

	public void setPd_id(int pd_id) {
		this.pd_id = pd_id;
	}

	public String getR_content() {
		return r_content;
	}

	public void setR_content(String r_content) {
		this.r_content = r_content;
	}

	public int getR_rating() {
		return r_rating;
	}

	public void setR_rating(int r_rating) {
		this.r_rating = r_rating;
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

	public int getR_report_count() {
		return r_report_count;
	}

	public void setR_report_count(int r_report_count) {
		this.r_report_count = r_report_count;
	}

	public String getR_isHidden() {
		return r_isHidden;
	}

	public void setR_isHidden(String r_isHidden) {
		this.r_isHidden = r_isHidden;
	}

	
	


	
	
}
