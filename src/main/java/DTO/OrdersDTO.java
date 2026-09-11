package DTO;

public class OrdersDTO {
	private int o_id;
	private String user_id;
	private String user_type;
	private int pd_id;
	private String o_num;
	private String o_isMember;
	private String o_name;
	private String o_phone;
	private int quantity;
	private String created_at;
	private int o_total_amount;
	private int pay_id;
	private int rf_id;
	
	public OrdersDTO() {}

	public OrdersDTO(int o_id, String user_id, String user_type, int pd_id, String o_num, String o_isMember, String o_name,
			String o_phone, int quantity, String created_at, int o_total_amount, int pay_id, int rf_id) {
		super();
		this.o_id = o_id;
		this.user_id = user_id;
		this.user_type = user_type;
		this.pd_id = pd_id;
		this.o_num = o_num;
		this.o_isMember = o_isMember;
		this.o_name = o_name;
		this.o_phone = o_phone;
		this.quantity = quantity;
		this.created_at = created_at;
		this.o_total_amount = o_total_amount;
		this.pay_id = pay_id;
		this.rf_id = rf_id;
	}

	public int getO_id() {
		return o_id;
	}

	public void setO_id(int o_id) {
		this.o_id = o_id;
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

	public int getPd_id() {
		return pd_id;
	}

	public void setPd_id(int pd_id) {
		this.pd_id = pd_id;
	}

	public String getO_num() {
		return o_num;
	}

	public void setO_num(String o_num) {
		this.o_num = o_num;
	}

	public String getO_isMember() {
		return o_isMember;
	}

	public void setO_isMember(String o_isMember) {
		this.o_isMember = o_isMember;
	}

	public String getO_name() {
		return o_name;
	}

	public void setO_name(String o_name) {
		this.o_name = o_name;
	}

	public String getO_phone() {
		return o_phone;
	}

	public void setO_phone(String o_phone) {
		this.o_phone = o_phone;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}

	public int getO_total_amount() {
		return o_total_amount;
	}

	public void setO_total_amount(int o_total_amount) {
		this.o_total_amount = o_total_amount;
	}

	public int getPay_id() {
		return pay_id;
	}

	public void setPay_id(int pay_id) {
		this.pay_id = pay_id;
	}

	public int getRf_id() {
		return rf_id;
	}

	public void setRf_id(int rf_id) {
		this.rf_id = rf_id;
	}
	
	
}
