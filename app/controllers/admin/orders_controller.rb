class Admin::OrdersController < Admin::ApplicationController
  def index
    @orders = Order.page(params[:page])
  end

  def change_status
    @order = Order.find_by(id: params[:id])
    @order.status_id = params[:status_id]
    results = if @order.save
                { err: false, result: 'success'}
              else
                { err: true, result: 'false'}
              end
    render json: results.to_json
  end
end
