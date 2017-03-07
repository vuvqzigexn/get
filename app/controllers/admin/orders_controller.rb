class Admin::OrdersController < Admin::ApplicationController
  def index
    @orders = Order.page(params[:page])
  end

  def change_status
    @order = Order.find_by(id: params[:id])
    @order.status_id = params[:status_id]
    if @order.save
      results =  { err: false, result: 'success'}
    else
      results =  { err: true, result: 'false'}
    end
    render json: results.to_json
  end
end
