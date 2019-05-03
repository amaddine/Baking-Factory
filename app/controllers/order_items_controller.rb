class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:show, :destroy, :set_shipped]
  before_action :check_login
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
    @order_item.shipped_on = nil
    if @order_item.save
      flash[:notice] = "Successfully added #{@order_item.name}."
      # redirect_to @order_item
    else
      render action: 'new'
    end
  end

  def update
    if @order_item.update(order_item_params)
      redirect_to @item, notice: "#{@item.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
  end

  def set_shipped
    @order_item.shipped_on = Date.current
    @order_item.save!
    redirect_to shipper_list_path
  end

  def unset_shipped
    @order_item.shipped_on = nil
    @order_item.save!
    redirect_to shipper_list_path
  end

  private
  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def order_item_params
    params.require(:order_item).permit(:order_id, :item_id, :quantity, :shipped_on)
  end 
end
