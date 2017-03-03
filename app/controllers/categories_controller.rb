class CategoriesController < ApplicationController
  def index; end

  def show
    @category = Category.find_by(id: params[:id])
    if @category.blank?
      flash[:danger] = "Không tìm thấy danh mục"
      return redirect_to root_path
    end
    @last_products = @category.products.last(Product::LASTEST)
    @products = @category.products.page(params[:page]).per(Product::PERPAGE)
    render template: "products/index"
  end
end
