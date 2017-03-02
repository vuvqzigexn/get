class SessionsController < ApplicationController

  def add_to_cart
    result = if validate_item 
              session[:order][params[:id]] = item_params
              {err: false,data: session[:order]}
            else
              {err: true,data: "Item not found"}
            end
    render :json => result.to_json
  end

  def item_params
    product = Product.find(params[:id])
    permitted = params.permit(:id, :quantity)
    if session[:order][params[:id]].present?
      quantity = permitted[:quantity].to_i + session[:order][params[:id]]['quantity'].to_i
      permitted[:quantity] = quantity.to_s
    end
    permitted.merge!({name: product.name,img: product.image_url,price: product.price})
    permitted
  end

  def validate_item
    (params[:quantity].to_i > 0 && Product.find(params[:id]).present?)
  end

end
