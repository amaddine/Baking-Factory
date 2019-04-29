class ItemsController < ApplicationController
  include AppHelpers::Baking
  include AppHelpers::Cart

  before_action :check_login, except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update, :destroy, :add_to_cart]
  authorize_resource
  
  def index
    
    @breads = Item.active.for_category('bread').alphabetical.paginate(:page => params[:page]).per_page(10)
    @muffins = Item.active.for_category('muffins').alphabetical.paginate(:page => params[:page]).per_page(10)
    @pastries = Item.active.for_category('pastries').alphabetical.paginate(:page => params[:page]).per_page(10) 
    # get a list of any inactive items for sidebar
    @inactive_items = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)

  end

  def show
    if logged_in? && current_user.role?(:admin)
      # admin gets a price history in the sidebar
      @previous_prices = @item.item_prices.chronological.to_a
    end
    # everyone sees similar items in the sidebar
    @similar_items = Item.for_category(@item.category).alphabetical.to_a
  end


  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to @item, notice: "#{@item.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: "#{@item.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: "#{@item.name} was removed from the system."
  end

  def add_to_cart
    id = params[:id]
    add_item_to_cart(id)
    redirect_to item_path(@item)
  end

  def remove_from_cart
    id = params[:id]
    remove_item_from_cart(id)
    redirect_to view_cart_path
  end

  def checkout_cart
    @total_cost = calculate_cart_items_cost()
    @items_list = get_list_of_items_in_cart()
    save_each_item_in_cart(current_user.customer.orders.first)
    clear_cart()
    redirect_to home_path, notice: "You have successfully placed and order"
  end


  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :picture, :category, :units_per_item, :weight, :active)
  end

end