package DTO;

public class DeliveryDTO {
	private int d_id;
	private int o_id;
	private String d_name;
	private String recv_name;
	private String recv_phone;
	private String recv_zipcode;
	private String recv_addr_road;
	private String recv_addr_detail;
	private String d_status;
	private String d_courier;
	private String d_tracking_num;
	private String shipped_at;
	private String d_started_at;
	private String d_completed_at;
	private String d_memo;
	
	public DeliveryDTO() {}

	public DeliveryDTO(int d_id, int o_id, String d_name, String recv_name, String recv_phone, String recv_zipcode,
			String recv_addr_road, String recv_addr_detail, String d_status, String d_courier, String d_tracking_num,
			String shipped_at, String d_started_at, String d_completed_at, String d_memo) {
		super();
		this.d_id = d_id;
		this.o_id = o_id;
		this.d_name = d_name;
		this.recv_name = recv_name;
		this.recv_phone = recv_phone;
		this.recv_zipcode = recv_zipcode;
		this.recv_addr_road = recv_addr_road;
		this.recv_addr_detail = recv_addr_detail;
		this.d_status = d_status;
		this.d_courier = d_courier;
		this.d_tracking_num = d_tracking_num;
		this.shipped_at = shipped_at;
		this.d_started_at = d_started_at;
		this.d_completed_at = d_completed_at;
		this.d_memo = d_memo;
	}

	public int getD_id() {
		return d_id;
	}

	public void setD_id(int d_id) {
		this.d_id = d_id;
	}

	public int getO_id() {
		return o_id;
	}

	public void setO_id(int o_id) {
		this.o_id = o_id;
	}

	public String getD_name() {
		return d_name;
	}

	public void setD_name(String d_name) {
		this.d_name = d_name;
	}

	public String getRecv_name() {
		return recv_name;
	}

	public void setRecv_name(String recv_name) {
		this.recv_name = recv_name;
	}

	public String getRecv_phone() {
		return recv_phone;
	}

	public void setRecv_phone(String recv_phone) {
		this.recv_phone = recv_phone;
	}

	public String getRecv_zipcode() {
		return recv_zipcode;
	}

	public void setRecv_zipcode(String recv_zipcode) {
		this.recv_zipcode = recv_zipcode;
	}

	public String getRecv_addr_road() {
		return recv_addr_road;
	}

	public void setRecv_addr_road(String recv_addr_road) {
		this.recv_addr_road = recv_addr_road;
	}

	public String getRecv_addr_detail() {
		return recv_addr_detail;
	}

	public void setRecv_addr_detail(String recv_addr_detail) {
		this.recv_addr_detail = recv_addr_detail;
	}

	public String getD_status() {
		return d_status;
	}

	public void setD_status(String d_status) {
		this.d_status = d_status;
	}

	public String getD_courier() {
		return d_courier;
	}

	public void setD_courier(String d_courier) {
		this.d_courier = d_courier;
	}

	public String getD_tracking_num() {
		return d_tracking_num;
	}

	public void setD_tracking_num(String d_tracking_num) {
		this.d_tracking_num = d_tracking_num;
	}

	public String getShipped_at() {
		return shipped_at;
	}

	public void setShipped_at(String shipped_at) {
		this.shipped_at = shipped_at;
	}

	public String getD_started_at() {
		return d_started_at;
	}

	public void setD_started_at(String d_started_at) {
		this.d_started_at = d_started_at;
	}

	public String getD_completed_at() {
		return d_completed_at;
	}

	public void setD_completed_at(String d_completed_at) {
		this.d_completed_at = d_completed_at;
	}

	public String getD_memo() {
		return d_memo;
	}

	public void setD_memo(String d_memo) {
		this.d_memo = d_memo;
	}
	
	
}
