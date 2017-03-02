class ProductsController < ApplicationController
  def index
    @products = Product.all().limit(40)
  end
  
  def show
    if Product.find_by(id: params[:id]).blank?
      flash[:danger] = "Không có sản phẩm này"
      return redirect_to root_path
    end
    return redirect_to root_path if Product.find_by(id: params[:id]).blank?
    @product = Product.find(params[:id])
  end
end
