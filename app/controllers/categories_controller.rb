class CategoriesController < ApplicationController
  def index; end

  def show
    @category = Category.find(params[:id])
    @products = @category.products
    render template: "products/index"
  end
end
