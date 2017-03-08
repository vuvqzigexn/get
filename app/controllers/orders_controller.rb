class OrdersController < ApplicationController
  def show; end

  def new
    @cart = session[:order]
    @order = Order.new
  end

  def index
    @orders = current_user.orders
  end

  def create
    @order = Order.new((order_params).merge({total: total_price}))
    @order.user = current_user
    @order.status = Status.find_by(name: 'New')
    if @order.save && save_cart_item(@order.id)
      UserMailer.checkout_email(@order).deliver_now
      session[:order] = nil
      flash[:success] = "Thanh toán thành công hàng đang tới nhà"
      redirect_to orders_path
    else
      flash[:danger] = "Không thành công, vui lòng thử lại"
      redirect_to :back
    end
  end

  private

  def save_cart_item(order_id)
    unsave = false
    session[:order].each do |id, item|
      cart = CartItem.new({
        product_id: id,
        order_id: order_id,
        price: item['price'],
        quantity: item['quantity']
      })
      unsave = !cart.save
    end
    !unsave
  end

  def total_price
    session[:order].map { |_,item| item['quantity'].to_i * item['price'].to_i }.sum
  end

  def order_params
    params.require(:order).permit(:shipping_address,:email)
  end
end
