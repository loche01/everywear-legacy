package DTO;

public class AdminLogDTO {
	private int log_id;
	private String admin_id;
	private String log_date;
	private String log_type;
	private String log_ip;
	
	public AdminLogDTO() {}

	public AdminLogDTO(int log_id, String admin_id, String log_date, String log_type, String log_ip) {
		super();
		this.log_id = log_id;
		this.admin_id = admin_id;
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

	public String getAdmin_id() {
		return admin_id;
	}

	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
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
