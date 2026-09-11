package DTO;

public class NotificationDTO {
	private int notifi_id;
	private String user_id;
	private String user_type;
	private int o_id;
	private String notifi_title;
	private String notifi_content;
	private String notified_at;
	private String notifi_isRead;
	
	public NotificationDTO() {}

	public NotificationDTO(int notifi_id, String user_id, String user_type, int o_id, String notifi_title, String notifi_content,
			String notified_at, String notifi_isRead) {
		super();
		this.notifi_id = notifi_id;
		this.user_id = user_id;
		this.user_type = user_type;
		this.o_id = o_id;
		this.notifi_title = notifi_title;
		this.notifi_content = notifi_content;
		this.notified_at = notified_at;
		this.notifi_isRead = notifi_isRead;
	}

	public int getNotifi_id() {
		return notifi_id;
	}

	public void setNotifi_id(int notifi_id) {
		this.notifi_id = notifi_id;
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

	public int getO_id() {
		return o_id;
	}

	public void setO_id(int o_id) {
		this.o_id = o_id;
	}

	public String getNotifi_title() {
		return notifi_title;
	}

	public void setNotifi_title(String notifi_title) {
		this.notifi_title = notifi_title;
	}

	public String getNotifi_content() {
		return notifi_content;
	}

	public void setNotifi_content(String notifi_content) {
		this.notifi_content = notifi_content;
	}

	public String getNotified_at() {
		return notified_at;
	}

	public void setNotified_at(String notified_at) {
		this.notified_at = notified_at;
	}

	public String getNotifi_isRead() {
		return notifi_isRead;
	}

	public void setNotifi_isRead(String notifi_isRead) {
		this.notifi_isRead = notifi_isRead;
	}
	
	
}
