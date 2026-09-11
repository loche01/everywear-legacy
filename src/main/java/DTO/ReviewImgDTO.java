package DTO;

public class ReviewImgDTO {
	private int ri_id;
	private int r_id;
	private String ri_url;
	private int ri_sort_orders;
	private String created_at;
	
	public ReviewImgDTO() {}

	public ReviewImgDTO(int ri_id, int r_id, String ri_url, int ri_sort_orders, String created_at) {
		super();
		this.ri_id = ri_id;
		this.r_id = r_id;
		this.ri_url = ri_url;
		this.ri_sort_orders = ri_sort_orders;
		this.created_at = created_at;
	}

	public int getRi_id() {
		return ri_id;
	}

	public void setRi_id(int ri_id) {
		this.ri_id = ri_id;
	}

	public int getR_id() {
		return r_id;
	}

	public void setR_id(int r_id) {
		this.r_id = r_id;
	}

	public String getRi_url() {
		return ri_url;
	}

	public void setRi_url(String ri_url) {
		this.ri_url = ri_url;
	}

	public int getRi_sort_orders() {
		return ri_sort_orders;
	}

	public void setRi_sort_orders(int ri_sort_orders) {
		this.ri_sort_orders = ri_sort_orders;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}
	
	
}
