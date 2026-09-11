package DTO;

public class InquiryDTO {
	private int i_id;
	private String user_id;
	private String user_type;
	private int p_id;
	private int o_id;
	private String i_title;
	private String i_content;
	private String created_at;
	private String i_isPrivate;
	private String i_status;
	
	public InquiryDTO() {}

	public InquiryDTO(int i_id, String user_id, String user_type, int p_id, int o_id, String i_title, String i_content,
			String created_at, String i_isPrivate, String i_status) {
		super();
		this.i_id = i_id;
		this.user_id = user_id;
		this.user_type = user_type;
		this.p_id = p_id;
		this.o_id = o_id;
		this.i_title = i_title;
		this.i_content = i_content;
		this.created_at = created_at;
		this.i_isPrivate = i_isPrivate;
		this.i_status = i_status;
	}

	public int getI_id() {
		return i_id;
	}

	public void setI_id(int i_id) {
		this.i_id = i_id;
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

	public int getP_id() {
		return p_id;
	}

	public void setP_id(int p_id) {
		this.p_id = p_id;
	}

	public int getO_id() {
		return o_id;
	}

	public void setO_id(int o_id) {
		this.o_id = o_id;
	}

	public String getI_title() {
		return i_title;
	}

	public void setI_title(String i_title) {
		this.i_title = i_title;
	}

	public String getI_content() {
		return i_content;
	}

	public void setI_content(String i_content) {
		this.i_content = i_content;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}

	public String getI_isPrivate() {
		return i_isPrivate;
	}

	public void setI_isPrivate(String i_isPrivate) {
		this.i_isPrivate = i_isPrivate;
	}

	public String getI_status() {
		return i_status;
	}

	public void setI_status(String i_status) {
		this.i_status = i_status;
	}

	
	
	
}
