package DTO;

public class CouponDTO {
	private int cp_id;
	private String cp_name;
	private String cp_type;
	private int cp_price;
	private String cp_start;
	private String cp_end;
	private String cp_usable_state;
	private int cp_min_price;
	private String cp_user_rank;
	
	public CouponDTO() {}

	public CouponDTO(int cp_id, String cp_name, String cp_type, int cp_price, String cp_start, String cp_end,
			String cp_usable_state, int cp_min_price, String cp_user_rank) {
		super();
		this.cp_id = cp_id;
		this.cp_name = cp_name;
		this.cp_type = cp_type;
		this.cp_price = cp_price;
		this.cp_start = cp_start;
		this.cp_end = cp_end;
		this.cp_usable_state = cp_usable_state;
		this.cp_min_price = cp_min_price;
		this.cp_user_rank = cp_user_rank;
	}

	public int getCp_id() {
		return cp_id;
	}

	public void setCp_id(int cp_id) {
		this.cp_id = cp_id;
	}

	public String getCp_name() {
		return cp_name;
	}

	public void setCp_name(String cp_name) {
		this.cp_name = cp_name;
	}

	public String getCp_type() {
		return cp_type;
	}

	public void setCp_type(String cp_type) {
		this.cp_type = cp_type;
	}

	public int getCp_price() {
		return cp_price;
	}

	public void setCp_price(int cp_price) {
		this.cp_price = cp_price;
	}

	public String getCp_start() {
		return cp_start;
	}

	public void setCp_start(String cp_start) {
		this.cp_start = cp_start;
	}

	public String getCp_end() {
		return cp_end;
	}

	public void setCp_end(String cp_end) {
		this.cp_end = cp_end;
	}

	public String getCp_usable_state() {
		return cp_usable_state;
	}

	public void setCp_usable_state(String cp_usable_state) {
		this.cp_usable_state = cp_usable_state;
	}

	public int getCp_min_price() {
		return cp_min_price;
	}

	public void setCp_min_price(int cp_min_price) {
		this.cp_min_price = cp_min_price;
	}

	public String getCp_user_rank() {
		return cp_user_rank;
	}

	public void setCp_user_rank(String cp_user_rank) {
		this.cp_user_rank = cp_user_rank;
	}

	
	
	
}
