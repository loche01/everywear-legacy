package DTO;

public class UserDTO {
	private String user_id;
	private String user_pwd;
	private String user_type;
	private String user_name;
	private String user_birth;
	private String user_gender;
	private int user_height;
	private int user_weight;
	private String user_email;
	private String created_at;
	private String user_phone;
	private String user_account_state;
	private String user_wd_date;
	private String user_wd_reason;
	private String user_wd_detail_reason;
	private int user_fail_login;
	private String user_lock_state;
	private String user_marketing_state;
	private int user_point;
	private String user_rank;

	public UserDTO() {
	}

	public UserDTO(String user_id, String user_pwd, String user_type, String user_name, String user_birth,
			String user_gender, int user_height, int user_weight, String user_email, String created_at,
			String user_phone, String user_account_state, String user_wd_date, String user_wd_reason,
			String user_wd_detail_reason, int user_fail_login, String user_lock_state, String user_marketing_state,
			int user_point, String user_rank) {
		super();
		this.user_id = user_id;
		this.user_pwd = user_pwd;
		this.user_type = user_type;
		this.user_name = user_name;
		this.user_birth = user_birth;
		this.user_gender = user_gender;
		this.user_height = user_height;
		this.user_weight = user_weight;
		this.user_email = user_email;
		this.created_at = created_at;
		this.user_phone = user_phone;
		this.user_account_state = user_account_state;
		this.user_wd_date = user_wd_date;
		this.user_wd_reason = user_wd_reason;
		this.user_wd_detail_reason = user_wd_detail_reason;
		this.user_fail_login = user_fail_login;
		this.user_lock_state = user_lock_state;
		this.user_marketing_state = user_marketing_state;
		this.user_point = user_point;
		this.user_rank = user_rank;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getUser_pwd() {
		return user_pwd;
	}

	public void setUser_pwd(String user_pwd) {
		this.user_pwd = user_pwd;
	}

	public String getUser_type() {
		return user_type;
	}

	public void setUser_type(String user_type) {
		this.user_type = user_type;
	}

	public String getUser_name() {
		return user_name;
	}

	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}

	public String getUser_birth() {
		return user_birth;
	}

	public void setUser_birth(String user_birth) {
		this.user_birth = user_birth;
	}

	public String getUser_gender() {
		return user_gender;
	}

	public void setUser_gender(String user_gender) {
		this.user_gender = user_gender;
	}

	public int getUser_height() {
		return user_height;
	}

	public void setUser_height(int user_height) {
		this.user_height = user_height;
	}

	public int getUser_weight() {
		return user_weight;
	}

	public void setUser_weight(int user_weight) {
		this.user_weight = user_weight;
	}

	public String getUser_email() {
		return user_email;
	}

	public void setUser_email(String user_email) {
		this.user_email = user_email;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}

	public String getUser_phone() {
		return user_phone;
	}

	public void setUser_phone(String user_phone) {
		this.user_phone = user_phone;
	}

	public String getUser_account_state() {
		return user_account_state;
	}

	public void setUser_account_state(String user_account_state) {
		this.user_account_state = user_account_state;
	}

	public String getUser_wd_date() {
		return user_wd_date;
	}

	public void setUser_wd_date(String user_wd_date) {
		this.user_wd_date = user_wd_date;
	}

	public String getUser_wd_reason() {
		return user_wd_reason;
	}

	public void setUser_wd_reason(String user_wd_reason) {
		this.user_wd_reason = user_wd_reason;
	}

	public String getUser_wd_detail_reason() {
		return user_wd_detail_reason;
	}

	public void setUser_wd_detail_reason(String user_wd_detail_reason) {
		this.user_wd_detail_reason = user_wd_detail_reason;
	}

	public int getUser_fail_login() {
		return user_fail_login;
	}

	public void setUser_fail_login(int user_fail_login) {
		this.user_fail_login = user_fail_login;
	}

	public String getUser_lock_state() {
		return user_lock_state;
	}

	public void setUser_lock_state(String user_lock_state) {
		this.user_lock_state = user_lock_state;
	}

	public String getUser_marketing_state() {
		return user_marketing_state;
	}

	public void setUser_marketing_state(String user_marketing_state) {
		this.user_marketing_state = user_marketing_state;
	}

	public int getUser_point() {
		return user_point;
	}

	public void setUser_point(int user_point) {
		this.user_point = user_point;
	}

	public String getUser_rank() {
		return user_rank;
	}

	public void setUser_rank(String user_rank) {
		this.user_rank = user_rank;
	}

}
