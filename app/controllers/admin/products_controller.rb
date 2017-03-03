class Admin::ProductsController < ApplicationController
  before_action :valid_admin
  def index
    @products = Product.page(params[:page])
  end
  
  def new; end
  
  def create; end
  
  def update
    product = Product.find_by(id: params[:id])
    product.update_attributes(permit_params.dup)
    if product.save
      flash[:success] = "Cập nhật thành công"
    else
      flash[:danger] = "Không có sản phẩm này"
    end
    redirect_to edit_admin_product_path(product)
  end

  def edit
    @product = Product.find_by(id: params[:id])
  end

  def destroy
    @product = Product.find_by(id: params[:id])
    if @product.destroy
      flash[:success] = "Xoa san pham thành công"
    else
      flash[:danger] = "Vui long thu lai"
    end
    redirect_to root_path
  end

  private

  def permit_params
    params.require(:product).permit(:name, :price, :description,:image_url, :id,:stock)
  end

end
