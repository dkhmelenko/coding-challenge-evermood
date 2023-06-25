class OrdersController < ApplicationController

  attr_reader :orders

  def index
    orders = DataProvider.instance.orders
    @orders = orders.filter {|o| o.state != "COMPLETE"}
  end

  def update
    order_id = params[:id]
    orders = DataProvider.instance.orders
    order_to_complete = orders.find {|order| order.id == order_id}
    order_to_complete.state = "COMPLETE"

    redirect_to action: "index"
  end
end
