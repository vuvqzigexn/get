class ProductsController < ApplicationController
  def index
    @last_products = Product.last(Product::LASTEST)
    @products = Product.page(params[:page]).per(Product::PERPAGE)
  end

  def show
    @product = Product.find_by(params[:id])
    if @product.blank?
      flash[:danger] = "Không có sản phẩm này"
      return redirect_to root_path
    end
    @product
  end
end
