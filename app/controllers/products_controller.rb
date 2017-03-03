class ProductsController < ApplicationController
  def index
    @last_products = Product.last(8)
    @products = Product.page(params[:page])
  end

  def show
    @product = Product.find(params[:id])
    if @product.blank?
      flash[:danger] = "Không có sản phẩm này"
      return redirect_to root_path
    end
    @product
  end
end
