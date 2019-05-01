class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :destroy]
  before_action :check_login
  authorize_resource

  include AppHelpers::Cart
  
  def index
    if current_user.role?(:customer)
      @all_orders = current_user.customer.orders.chronological.paginate(page: params[:page]).per_page(10)
    elsif current_user.role?(:admin)
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(10)
    elsif current_user.role?(:shipper)
      @all_orders = Order.not_shipped
    end
  end

  def show
    @previous_orders = @order.customer.orders.chronological.to_a
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.date = Date.current
    @order.grand_total = calculate_cart_items_cost()
    if @order.save
      @order.pay
      save_each_item_in_cart(@order)
      clear_cart()
      redirect_to @order, notice: "Thank you for ordering from the Baking Factory."
    else
      render action: 'new'
    end
  end
  
  def add_to_cart
    id = params[:id]
    add_item_to_cart(id)
    redirect_to items_path, notice: "You have added #{Item.find(id).name} to your cart"
  end

  def remove_from_cart
    id = params[:id]
    remove_item_from_cart(id)
    redirect_to view_cart_path
  end

  def checkout_cart
    @total_cost = calculate_cart_items_cost()
    @items_list = get_list_of_items_in_cart()
    save_each_item_in_cart(@order)
    clear_cart()
    redirect_to home_path, notice: "You have successfully placed an order"
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:address_id, :customer_id, :grand_total, :date, :payment_receipt, :credit_card_number, :expiration_year, :expiration_month)
  end

end