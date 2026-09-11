package DTO;

public class AdminDTO {
	private String admin_id;
	private String admin_pwd;
	private String admin_name;
	private String admin_roll;
	private String admin_email;
	private int admin_fail_login;
	private String admin_lock_state;
	
	public AdminDTO() {}

	public AdminDTO(String admin_id, String admin_pwd, String admin_name, String admin_roll, String admin_email,
			int admin_fail_login, String admin_lock_state) {
		super();
		this.admin_id = admin_id;
		this.admin_pwd = admin_pwd;
		this.admin_name = admin_name;
		this.admin_roll = admin_roll;
		this.admin_email = admin_email;
		this.admin_fail_login = admin_fail_login;
		this.admin_lock_state = admin_lock_state;
	}

	public String getAdmin_id() {
		return admin_id;
	}

	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
	}

	public String getAdmin_pwd() {
		return admin_pwd;
	}

	public void setAdmin_pwd(String admin_pwd) {
		this.admin_pwd = admin_pwd;
	}

	public String getAdmin_name() {
		return admin_name;
	}

	public void setAdmin_name(String admin_name) {
		this.admin_name = admin_name;
	}

	public String getAdmin_roll() {
		return admin_roll;
	}

	public void setAdmin_roll(String admin_roll) {
		this.admin_roll = admin_roll;
	}

	public String getAdmin_email() {
		return admin_email;
	}

	public void setAdmin_email(String admin_email) {
		this.admin_email = admin_email;
	}

	public int getAdmin_fail_login() {
		return admin_fail_login;
	}

	public void setAdmin_fail_login(int admin_fail_login) {
		this.admin_fail_login = admin_fail_login;
	}

	public String getAdmin_lock_state() {
		return admin_lock_state;
	}

	public void setAdmin_lock_state(String admin_lock_state) {
		this.admin_lock_state = admin_lock_state;
	}
	
	
}
