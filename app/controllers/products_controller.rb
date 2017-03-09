class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :edit]
  def index
    @last_products = Product.last(Product::LASTEST)
    @products = Product.page(params[:page]).per(Product::PERPAGE)
  end

  def show
    if @product.blank?
      flash[:danger] = "Không có sản phẩm này"
      return redirect_to root_path
    end
    @product
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.create(product_params)
    @product.user = current_user
    if @product.save
      flash[:success] = "Sản phẩm đã được thêm vào cửa hàng"
      redirect_to product_path(@product)
    else
      flash[:danger] = "Không có sản phẩm này"
      redirect_back fallback_location: @product
    end
  end

  def update
    @product.user = current_user
    if @product.update_attributes(product_params)
      flash[:success] = "Cập nhật thành công"
    else
      flash[:danger] = "Cập nhật không thành công"
    end
    redirect_to edit_product_path(@product)
  end

  def edit
    redirect_to root_path unless @product && @product.user == current_user
  end

  def search
    @solr_response = Product.new.search(params[:query])
    ids = @solr_response['response']['docs'].map { |pd| pd['id'] }
    @products = Product.where(id: ids).page(params[:page]).per(Product::PERPAGE)
  end

  private

  def product_params
    params.require(:product).permit(:name,:category_id, :price, :description,:image_url,:stock)
  end

  def set_product
    @product = Product.find_by(id: params[:id])
  end
end
