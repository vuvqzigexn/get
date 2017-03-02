class ProductsController < ApplicationController
  def index
  	@products = Product.all().limit(40)
  end
  
  def show
  	@product = Product.find(params[:id])
  end
end
