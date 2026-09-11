package DTO;

public class EventDTO {
	private int e_id;
	private String e_title;
	private String e_type;
	private String e_image_url;
	private String e_link_url;
	private String e_start;
	private String e_end;
	private String e_isActive;
	
	public EventDTO() {}

	public EventDTO(int e_id, String e_title, String e_type, String e_image_url, String e_link_url, String e_start,
			String e_end, String e_isActive) {
		super();
		this.e_id = e_id;
		this.e_title = e_title;
		this.e_type = e_type;
		this.e_image_url = e_image_url;
		this.e_link_url = e_link_url;
		this.e_start = e_start;
		this.e_end = e_end;
		this.e_isActive = e_isActive;
	}

	public int getE_id() {
		return e_id;
	}

	public void setE_id(int e_id) {
		this.e_id = e_id;
	}

	public String getE_title() {
		return e_title;
	}

	public void setE_title(String e_title) {
		this.e_title = e_title;
	}

	public String getE_type() {
		return e_type;
	}

	public void setE_type(String e_type) {
		this.e_type = e_type;
	}

	public String getE_image_url() {
		return e_image_url;
	}

	public void setE_image_url(String e_image_url) {
		this.e_image_url = e_image_url;
	}

	public String getE_link_url() {
		return e_link_url;
	}

	public void setE_link_url(String e_link_url) {
		this.e_link_url = e_link_url;
	}

	public String getE_start() {
		return e_start;
	}

	public void setE_start(String e_start) {
		this.e_start = e_start;
	}

	public String getE_end() {
		return e_end;
	}

	public void setE_end(String e_end) {
		this.e_end = e_end;
	}

	public String getE_isActive() {
		return e_isActive;
	}

	public void setE_isActive(String e_isActive) {
		this.e_isActive = e_isActive;
	}
	
	
}
