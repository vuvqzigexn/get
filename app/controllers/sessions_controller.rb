class SessionsController < ApplicationController

  def add_to_cart
    if validate_item
      order = session[:order]
      product = Product.find_by(id: params[:id])
      permitted = permit_params
      permitted[:quantity] = \
        if order[params[:id]].present?
          permitted[:quantity].to_i + order[params[:id]]['quantity'].to_i
        else
          permitted[:quantity].to_i
        end
      order[params[:id]] = permitted.merge!({
        name: product.name,
        img: product.image_url,
        price: product.price}
      )
      results =  {err: false,data: order}
    else
      results =  {err: true,data: "Item not found"}
    end
    render :json => results.to_json
  end


  def validate_item
    (params[:quantity].to_i > 0 && Product.find_by(id: params[:id]).present?)
  end

  private
    def permit_params
      permitted = params.permit(:id, :quantity)
    end

end
