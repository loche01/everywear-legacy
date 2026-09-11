package DTO;

public class UserCouponDTO {
	private int user_cp_id;
	private String user_id;
	private String user_type;
	private int cp_id;
	private String admin_id;
	private String cp_provide_date;
	private String cp_using_date;
	private String cp_using_state;
	private CouponDTO coupon;
	
	public UserCouponDTO() {}

	public UserCouponDTO(int user_cp_id, String user_id, String user_type, int cp_id, String admin_id,
			String cp_provide_date, String cp_using_date, String cp_using_state, CouponDTO coupon) {
		super();
		this.user_cp_id = user_cp_id;
		this.user_id = user_id;
		this.user_type = user_type;
		this.cp_id = cp_id;
		this.admin_id = admin_id;
		this.cp_provide_date = cp_provide_date;
		this.cp_using_date = cp_using_date;
		this.cp_using_state = cp_using_state;
		this.coupon = coupon;
	}

	public int getUser_cp_id() {
		return user_cp_id;
	}

	public void setUser_cp_id(int user_cp_id) {
		this.user_cp_id = user_cp_id;
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

	public int getCp_id() {
		return cp_id;
	}

	public void setCp_id(int cp_id) {
		this.cp_id = cp_id;
	}

	public String getAdmin_id() {
		return admin_id;
	}

	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
	}

	public String getCp_provide_date() {
		return cp_provide_date;
	}

	public void setCp_provide_date(String cp_provide_date) {
		this.cp_provide_date = cp_provide_date;
	}

	public String getCp_using_date() {
		return cp_using_date;
	}

	public void setCp_using_date(String cp_using_date) {
		this.cp_using_date = cp_using_date;
	}

	public String getCp_using_state() {
		return cp_using_state;
	}

	public void setCp_using_state(String cp_using_state) {
		this.cp_using_state = cp_using_state;
	}

	public CouponDTO getCoupon() {
		return coupon;
	}

	public void setCoupon(CouponDTO coupon) {
		this.coupon = coupon;
	}

	
	

	
	
}
