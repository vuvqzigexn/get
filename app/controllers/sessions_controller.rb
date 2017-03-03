class SessionsController < ApplicationController
  def add_to_cart
    if item_valid?
      order = session[:order]
      product = Product.find_by(id: params[:id])
      permitted = permit_params.dup
      item = order[params[:id]]
      if item.present?
        permitted[:quantity] = permitted[:quantity].to_i + item['quantity'].to_i
      else
        permitted[:quantity] = permitted[:quantity].to_i
      end
      order[params[:id]] = permitted.merge!({
                                              name: product.name,
                                              img: product.image_url,
                                              price: product.price
                                            })
      results =  { err: false,data: order }
    else
      results =  { err: true,data: "Item not found" }
    end
    render json: results.to_json
  end

  def item_valid?
    (params[:quantity].to_i > 0 && Product.find_by(id: params[:id]).present?)
  end

  private

  def permit_params
    params.permit(:id, :quantity)
  end
end
