class Admin::ProductsController < Admin::ApplicationController
  def index
    @products = Product.page(params[:page])
  end

  def new; end

  def create; end

  def update
    @product = set_product
    @product.user = current_user
    if @product.update_attributes(product_params)
      flash[:success] = "Cập nhật thành công"
    else
      flash[:danger] = "Cập nhật không thành công"
    end
    redirect_to edit_admin_product_path(@product)
  end

  def edit
    @product = set_product
    redirect_to new_product_path if @product.blank?
  end

  def destroy
    @product = set_product
    if @product.destroy
      flash[:success] = "Xóa sản phẩm thành công"
    else
      flash[:danger] = "Vui lòng thử lại"
    end
    redirect_to admin_products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :description, :image_url, :id, :stock)
  end

  def set_product
    @product = Product.find_by(id: params[:id])
  end
end
