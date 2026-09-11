package DTO;

public class RefundDTO {
	private int rf_id;
	private int rf_amount;
	private int rf_quantity;
	private String rf_reason_code;
	private String rf_reason_text;
	private String refunded_at;
	private String admin_id;
	private String rf_status;
	
	public RefundDTO() {}

	public RefundDTO(int rf_id, int rf_amount, int rf_quantity, String rf_reason_code, String rf_reason_text,
			String refunded_at, String admin_id, String rf_status) {
		super();
		this.rf_id = rf_id;
		this.rf_amount = rf_amount;
		this.rf_quantity = rf_quantity;
		this.rf_reason_code = rf_reason_code;
		this.rf_reason_text = rf_reason_text;
		this.refunded_at = refunded_at;
		this.admin_id = admin_id;
		this.rf_status = rf_status;
	}

	public int getRf_id() {
		return rf_id;
	}

	public void setRf_id(int rf_id) {
		this.rf_id = rf_id;
	}

	public int getRf_amount() {
		return rf_amount;
	}

	public void setRf_amount(int rf_amount) {
		this.rf_amount = rf_amount;
	}

	public int getRf_quantity() {
		return rf_quantity;
	}

	public void setRf_quantity(int rf_quantity) {
		this.rf_quantity = rf_quantity;
	}

	public String getRf_reason_code() {
		return rf_reason_code;
	}

	public void setRf_reason_code(String rf_reason_code) {
		this.rf_reason_code = rf_reason_code;
	}

	public String getRf_reason_text() {
		return rf_reason_text;
	}

	public void setRf_reason_text(String rf_reason_text) {
		this.rf_reason_text = rf_reason_text;
	}

	public String getRefunded_at() {
		return refunded_at;
	}

	public void setRefunded_at(String refunded_at) {
		this.refunded_at = refunded_at;
	}

	public String getAdmin_id() {
		return admin_id;
	}

	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
	}

	public String getRf_status() {
		return rf_status;
	}

	public void setRf_status(String rf_status) {
		this.rf_status = rf_status;
	}
	
	
}
