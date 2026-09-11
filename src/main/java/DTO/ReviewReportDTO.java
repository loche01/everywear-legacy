package DTO;

public class ReviewReportDTO {
	private int rr_id;
	private String user_id;
	private String user_type;
	private int rr_target_id;
	private String rr_target_type;
	private String rr_reason_code;
	private String rr_reason_text;
	private String reported_at;
	
	public ReviewReportDTO() {}

	public ReviewReportDTO(int rr_id, String user_id, String user_type, int rr_target_id, String rr_target_type, String rr_reason_code,
			String rr_reason_text, String reported_at) {
		super();
		this.rr_id = rr_id;
		this.user_id = user_id;
		this.user_type = user_type;
		this.rr_target_id = rr_target_id;
		this.rr_target_type = rr_target_type;
		this.rr_reason_code = rr_reason_code;
		this.rr_reason_text = rr_reason_text;
		this.reported_at = reported_at;
	}

	public int getRr_id() {
		return rr_id;
	}

	public void setRr_id(int rr_id) {
		this.rr_id = rr_id;
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

	public int getRr_target_id() {
		return rr_target_id;
	}

	public void setRr_target_id(int rr_target_id) {
		this.rr_target_id = rr_target_id;
	}

	public String getRr_target_type() {
		return rr_target_type;
	}

	public void setRr_target_type(String rr_target_type) {
		this.rr_target_type = rr_target_type;
	}

	public String getRr_reason_code() {
		return rr_reason_code;
	}

	public void setRr_reason_code(String rr_reason_code) {
		this.rr_reason_code = rr_reason_code;
	}

	public String getRr_reason_text() {
		return rr_reason_text;
	}

	public void setRr_reason_text(String rr_reason_text) {
		this.rr_reason_text = rr_reason_text;
	}

	public String getReported_at() {
		return reported_at;
	}

	public void setReported_at(String reported_at) {
		this.reported_at = reported_at;
	}
	
	
}
