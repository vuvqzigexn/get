class CategoriesController < ApplicationController
  def index; end

  def show
    @category = Category.find(params[:id])
    if @category.blank?
      flash[:danger] = "Không tìm thấy danh mục"
      return redirect_to root_path
    end
    @last_products = @category.products.last(8)
    @products = @category.products.page(params[:page]).per(12)
    render template: "products/index"
  end
end
