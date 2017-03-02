class CategoriesController < ApplicationController
  def index; end

  def show
    if Category.find_by(id: params[:id]).blank?
      flash[:danger] = "Không tìm thấy danh mục"
      return redirect_to root_path
    end
    @category = Category.find(params[:id])
    @products = @category.products
    render template: "products/index"
  end
end
