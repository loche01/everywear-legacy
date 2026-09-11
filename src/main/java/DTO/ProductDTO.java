package DTO;

public class ProductDTO {
	private int p_id;
	private String p_category;
	private String p_name;
	private int p_price;
	private int p_disc;
	private String p_text;
	private String p_color;
	private String created_at;
	
	public ProductDTO() {}

	public ProductDTO(int p_id, String p_category, String p_name, int p_price, int p_disc,
			String p_text, String p_color, String created_at) {
		super();
		this.p_id = p_id;
		this.p_category = p_category;
		this.p_name = p_name;
		this.p_price = p_price;
		this.p_disc = p_disc;
		this.p_text = p_text;
		this.p_color = p_color;
		this.created_at = created_at;
	}

	public int getP_id() {
		return p_id;
	}

	public void setP_id(int p_id) {
		this.p_id = p_id;
	}

	public String getP_category() {
		return p_category;
	}

	public void setP_category(String p_category) {
		this.p_category = p_category;
	}

	public String getP_name() {
		return p_name;
	}

	public void setP_name(String p_name) {
		this.p_name = p_name;
	}

	public int getP_price() {
		return p_price;
	}

	public void setP_price(int p_price) {
		this.p_price = p_price;
	}

	public int getP_disc() {
		return p_disc;
	}

	public void setP_disc(int p_disc) {
		this.p_disc = p_disc;
	}

	public String getP_text() {
		return p_text;
	}

	public void setP_text(String p_text) {
		this.p_text = p_text;
	}

	public String getP_color() {
		return p_color;
	}

	public void setP_color(String p_color) {
		this.p_color = p_color;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}
	
	
}
