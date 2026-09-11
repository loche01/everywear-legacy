package DTO;

public class FavoriteDTO {
	private int f_id;
	private String user_id;
	private String user_type;
	private int pd_id;
	private String f_type;
	private int f_quantity;
	private String created_at;
	
	public FavoriteDTO() {}

	public FavoriteDTO(int f_id, String user_id, String user_type, int pd_id, String f_type, int f_quantity, String created_at) {
		super();
		this.f_id = f_id;
		this.user_id = user_id;
		this.user_type = user_type;
		this.pd_id = pd_id;
		this.f_type = f_type;
		this.f_quantity = f_quantity;
		this.created_at = created_at;
	}

	public int getF_id() {
		return f_id;
	}

	public void setF_id(int f_id) {
		this.f_id = f_id;
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

	public String getF_type() {
		return f_type;
	}

	public void setF_type(String f_type) {
		this.f_type = f_type;
	}

	public int getF_quantity() {
		return f_quantity;
	}

	public void setF_quantity(int f_quantity) {
		this.f_quantity = f_quantity;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}
	
	
}
