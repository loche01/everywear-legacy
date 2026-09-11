package DTO;

public class NoticeDTO {
	private int noti_id;
	private String admin_id;
	private String noti_title;
	private String content;
	private String created_at;
	private int noti_views;
	private String noti_isPinned;
	
	public NoticeDTO() {}

	public NoticeDTO(int noti_id, String admin_id, String noti_title, String content, String created_at,
			int noti_views, String noti_isPinned) {
		super();
		this.noti_id = noti_id;
		this.admin_id = admin_id;
		this.noti_title = noti_title;
		this.content = content;
		this.created_at = created_at;
		this.noti_views = noti_views;
		this.noti_isPinned = noti_isPinned;
	}

	public int getNoti_id() {
		return noti_id;
	}

	public void setNoti_id(int noti_id) {
		this.noti_id = noti_id;
	}

	public String getAdmin_id() {
		return admin_id;
	}

	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
	}

	public String getNoti_title() {
		return noti_title;
	}

	public void setNoti_title(String noti_title) {
		this.noti_title = noti_title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}

	public int getNoti_views() {
		return noti_views;
	}

	public void setNoti_views(int noti_views) {
		this.noti_views = noti_views;
	}

	public String getNoti_isPinned() {
		return noti_isPinned;
	}

	public void setNoti_isPinned(String noti_isPinned) {
		this.noti_isPinned = noti_isPinned;
	}
	
	
}
