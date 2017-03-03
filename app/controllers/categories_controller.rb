class CategoriesController < ApplicationController
  def index; end

  def show
    @category = Category.find_by(params[:id])
    if @category.blank?
      flash[:danger] = "Không tìm thấy danh mục"
      return redirect_to root_path
    end
    @last_products = Category.lastest_products(@category)
    @products = @category.products.page(params[:page])
    render template: "products/index"
  end
end
