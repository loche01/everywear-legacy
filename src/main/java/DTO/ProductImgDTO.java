package DTO;

public class ProductImgDTO {
	private int pi_id;
	private int p_id;
	private String pi_url;
	private int pi_orders;
	private String created_at;
	
	public ProductImgDTO() {}

	public ProductImgDTO(int pi_id, int p_id, String pi_url, int pi_orders, String created_at) {
		super();
		this.pi_id = pi_id;
		this.p_id = p_id;
		this.pi_url = pi_url;
		this.pi_orders = pi_orders;
		this.created_at = created_at;
	}

	public int getPi_id() {
		return pi_id;
	}

	public void setPi_id(int pi_id) {
		this.pi_id = pi_id;
	}

	public int getP_id() {
		return p_id;
	}

	public void setP_id(int p_id) {
		this.p_id = p_id;
	}

	public String getPi_url() {
		return pi_url;
	}

	public void setPi_url(String pi_url) {
		this.pi_url = pi_url;
	}

	public int getPi_orders() {
		return pi_orders;
	}

	public void setPi_orders(int pi_orders) {
		this.pi_orders = pi_orders;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}
	
	
}
