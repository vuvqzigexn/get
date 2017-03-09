class SessionsController < ApplicationController
  def add_to_cart
    if notify.blank?
      order = session[:order]
      product = Product.find_by(id: params[:id])
      permitted = cart_params.dup
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
      results =  { err: false, result: order }
    else
      results =  { err: true, result: notify }
    end
    render json: results.to_json
  end

  def remove_item
    session[:order].delete(params[:id])
    render json: { error: nil, result: 'success' }.to_json
  end

  def update_item_quantity
    session[:order][params[:id]]['quantity'] = params[:quantity]
    render json: { error: nil, result: 'success' }.to_json
  end

  def notify
    msg = ''
    msg = 'Sản phẩm đã được bán hết' if (params[:quantity].to_i < 0 || Product.find_by(id: params[:id]).blank?)
    stock = Product.find_by(id: params[:id]).stock 
    msg = "Số lượng chỉ còn #{stock} sản phẩm" if params[:quantity].to_i > stock
  end

  private

  def cart_params
    params.permit(:id, :quantity)
  end
end
