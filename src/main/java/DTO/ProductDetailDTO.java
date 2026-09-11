package DTO;

public class ProductDetailDTO {
	private int pd_id;
	private int p_id;
	private String pd_size;
	private int pd_stock;
	
	public ProductDetailDTO() {}

	public ProductDetailDTO(int pd_id, int p_id, String pd_size, int pd_stock) {
		super();
		this.pd_id = pd_id;
		this.p_id = p_id;
		this.pd_size = pd_size;
		this.pd_stock = pd_stock;
	}

	public int getPd_id() {
		return pd_id;
	}

	public void setPd_id(int pd_id) {
		this.pd_id = pd_id;
	}

	public int getP_id() {
		return p_id;
	}

	public void setP_id(int p_id) {
		this.p_id = p_id;
	}

	public String getPd_size() {
		return pd_size;
	}

	public void setPd_size(String pd_size) {
		this.pd_size = pd_size;
	}

	public int getPd_stock() {
		return pd_stock;
	}

	public void setPd_stock(int pd_stock) {
		this.pd_stock = pd_stock;
	}
	
	
}
