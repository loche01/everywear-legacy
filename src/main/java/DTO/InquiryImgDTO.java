package DTO;

public class InquiryImgDTO {
	private int ii_id;
	private int i_id;
	private String ii_url;
	private String uploaded_at;
	
	public InquiryImgDTO() {}

	public InquiryImgDTO(int ii_id, int i_id, String ii_url, String uploaded_at) {
		super();
		this.ii_id = ii_id;
		this.i_id = i_id;
		this.ii_url = ii_url;
		this.uploaded_at = uploaded_at;
	}

	public int getIi_id() {
		return ii_id;
	}

	public void setIi_id(int ii_id) {
		this.ii_id = ii_id;
	}

	public int getI_id() {
		return i_id;
	}

	public void setI_id(int i_id) {
		this.i_id = i_id;
	}

	public String getIi_url() {
		return ii_url;
	}

	public void setIi_url(String ii_url) {
		this.ii_url = ii_url;
	}

	public String getUploaded_at() {
		return uploaded_at;
	}

	public void setUploaded_at(String uploaded_at) {
		this.uploaded_at = uploaded_at;
	}
	
	
}
