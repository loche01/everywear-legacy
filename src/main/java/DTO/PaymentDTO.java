package DTO;

public class PaymentDTO {
	private int pay_id;
	private String user_id;
	private String user_type;
	private String pay_status;
	private String paid_at;
	private String pay_imp_uid;
	private String pay_apply_num;
	private String pay_card_name;
	
	public PaymentDTO() {}

	public PaymentDTO(int pay_id, String user_id, String user_type, String pay_status, String paid_at,
			String pay_imp_uid, String pay_apply_num, String pay_card_name) {
		super();
		this.pay_id = pay_id;
		this.user_id = user_id;
		this.user_type = user_type;
		this.pay_status = pay_status;
		this.paid_at = paid_at;
		this.pay_imp_uid = pay_imp_uid;
		this.pay_apply_num = pay_apply_num;
		this.pay_card_name = pay_card_name;
	}

	public int getPay_id() {
		return pay_id;
	}

	public void setPay_id(int pay_id) {
		this.pay_id = pay_id;
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

	public String getPay_status() {
		return pay_status;
	}

	public void setPay_status(String pay_status) {
		this.pay_status = pay_status;
	}

	public String getPaid_at() {
		return paid_at;
	}

	public void setPaid_at(String paid_at) {
		this.paid_at = paid_at;
	}

	public String getPay_imp_uid() {
		return pay_imp_uid;
	}

	public void setPay_imp_uid(String pay_imp_uid) {
		this.pay_imp_uid = pay_imp_uid;
	}

	public String getPay_apply_num() {
		return pay_apply_num;
	}

	public void setPay_apply_num(String pay_apply_num) {
		this.pay_apply_num = pay_apply_num;
	}

	public String getPay_card_name() {
		return pay_card_name;
	}

	public void setPay_card_name(String pay_card_name) {
		this.pay_card_name = pay_card_name;
	}




	
}
