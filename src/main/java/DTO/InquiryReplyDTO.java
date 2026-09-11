package DTO;

public class InquiryReplyDTO {
	private int ir_id;
	private int i_id;
	private String admin_id;
	private String ir_content;
	private String created_at;
	
	public InquiryReplyDTO() {}

	public InquiryReplyDTO(int ir_id, int i_id, String admin_id, String ir_content, String created_at) {
		super();
		this.ir_id = ir_id;
		this.i_id = i_id;
		this.admin_id = admin_id;
		this.ir_content = ir_content;
		this.created_at = created_at;
	}

	public int getIr_id() {
		return ir_id;
	}

	public void setIr_id(int ir_id) {
		this.ir_id = ir_id;
	}

	public int getI_id() {
		return i_id;
	}

	public void setI_id(int i_id) {
		this.i_id = i_id;
	}

	public String getAdmin_id() {
		return admin_id;
	}

	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
	}

	public String getIr_content() {
		return ir_content;
	}

	public void setIr_content(String ir_content) {
		this.ir_content = ir_content;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}
	
	
}
