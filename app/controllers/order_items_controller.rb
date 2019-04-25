class OrderItemsController < ApplicationController
authorize_resource

  def index
  end

  def show
  end

  def new
    @order_item = OrderItem.new
  end

  def edit
  end

  def create
    @order_item = OrderItem.new(order_item_params)
    if @order_item.save
      flash[:notice] = "Successfully added #{@order_item.name}."
      redirect_to @order_item
    else
      render action: 'new'
    end
  end

  def update
  end

  def destroy
  end

  private
  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def order_item_params
    params.require(:order_item).permit(:order_id, :item_id, :price, :quantity, :shipped_on)
  end 
end
