class ItemPricesController < ApplicationController
  before_action :set_item_price, only: [:show, :edit, :update]
  before_action :check_login
  authorize_resource

  def index
    @current_prices = ItemPrice.current
  end

  def show
  end

  def new
    @item_price = ItemPrice.new
    @item = Item.find(params[:item_id])
  end

  def edit
  end

  def create
    @item_price = ItemPrice.new(item_price_params)
    if @item_price.save
      flash[:notice] = "Successfully updated price."
      redirect_to item_path(@item_price.item)
    else
      render action: 'new'
    end
  end

  def update
    if @item_price.update_attributes(item_price_params)
      flash[:notice] = "Successfully updated #{@item_price.item.name}."
      redirect_to @item_price.item
    else
      render action: 'edit'
    end
  end

  def destroy
  end

  private
  
  def set_item_price
    @item_price = ItemPrice.find(params[:id])
  end

  def item_price_params
    params.require(:item_price).permit(:item_id, :price, :start_date, :end_date)
  end 
end
