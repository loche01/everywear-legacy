package DTO;

public class UserAddrDTO {
	private int addr_id;
	private String user_id;
	private String user_type;
	private String addr_zipcode;
	private String addr_road;
	private String addr_detail;
	private String addr_isDefault;
	private String created_at;
	private String addr_label;
	
	public UserAddrDTO() {}

	public UserAddrDTO(int addr_id, String user_id, String user_type, String addr_zipcode, String addr_road, String addr_detail,
			String addr_isDefault, String created_at, String addr_label) {
		super();
		this.addr_id = addr_id;
		this.user_id = user_id;
		this.user_type = user_type;
		this.addr_zipcode = addr_zipcode;
		this.addr_road = addr_road;
		this.addr_detail = addr_detail;
		this.addr_isDefault = addr_isDefault;
		this.created_at = created_at;
		this.addr_label = addr_label;
	}

	public int getAddr_id() {
		return addr_id;
	}

	public void setAddr_id(int addr_id) {
		this.addr_id = addr_id;
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

	public String getAddr_zipcode() {
		return addr_zipcode;
	}

	public void setAddr_zipcode(String addr_zipcode) {
		this.addr_zipcode = addr_zipcode;
	}

	public String getAddr_road() {
		return addr_road;
	}

	public void setAddr_road(String addr_road) {
		this.addr_road = addr_road;
	}

	public String getAddr_detail() {
		return addr_detail;
	}

	public void setAddr_detail(String addr_detail) {
		this.addr_detail = addr_detail;
	}

	public String getAddr_isDefault() {
		return addr_isDefault;
	}

	public void setAddr_isDefault(String addr_isDefault) {
		this.addr_isDefault = addr_isDefault;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}

	public String getAddr_label() {
		return addr_label;
	}

	public void setAddr_label(String addr_label) {
		this.addr_label = addr_label;
	}

	
	
	
}
