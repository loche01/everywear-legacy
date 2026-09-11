package DTO;

public class UserLogDTO {
	private int log_id;
	private String user_id;
	private String user_type;
	private String log_date;
	private String log_type;
	private String log_ip;

	public UserLogDTO() {
	}

	public UserLogDTO(int log_id, String user_id, String user_type, String log_date, String log_type, String log_ip) {
		super();
		this.log_id = log_id;
		this.user_id = user_id;
		this.user_type = user_type;
		this.log_date = log_date;
		this.log_type = log_type;
		this.log_ip = log_ip;
	}

	public int getLog_id() {
		return log_id;
	}

	public void setLog_id(int log_id) {
		this.log_id = log_id;
	}

	public String getUser_id() {
		return user_id;
	}

	public String getUser_type() {
		return user_type;
	}

	public void setUser_type(String user_type) {
		this.user_type = user_type;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getLog_date() {
		return log_date;
	}

	public void setLog_date(String log_date) {
		this.log_date = log_date;
	}

	public String getLog_type() {
		return log_type;
	}

	public void setLog_type(String log_type) {
		this.log_type = log_type;
	}

	public String getLog_ip() {
		return log_ip;
	}

	public void setLog_ip(String log_ip) {
		this.log_ip = log_ip;
	}

}
