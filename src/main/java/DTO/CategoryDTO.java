package DTO;

public class CategoryDTO {
	private String category_name;
	private String top_category;
	
	public CategoryDTO() {}

	public CategoryDTO(String category_name, String top_category) {
		super();
		this.category_name = category_name;
		this.top_category = top_category;
	}

	public String getCategory_name() {
		return category_name;
	}

	public void setCategory_name(String category_name) {
		this.category_name = category_name;
	}

	public String getTop_category() {
		return top_category;
	}

	public void setTop_category(String top_category) {
		this.top_category = top_category;
	}
	
	
}
