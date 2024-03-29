class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
    @active_addresses = Address.active.by_customer.by_recipient.paginate(:page => params[:page]).per_page(10)
    @inactive_addresses = Address.inactive.by_customer.by_recipient.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @previous_orders = @address.orders
  end

  def new
    @address = Address.new
    # @customer = Customer.find(params[:customer_id])
  end

  def edit
  end

  def create
    @address = Address.new(address_params)

    if current_user.role?(:customer)
      @address.customer = current_user.customer
    end
    
    if @address.save
      redirect_to customer_path(@address.customer), notice: "The address was added to #{@address.customer.proper_name}."
    else
      render action: 'new'
    end
  end

  def update
    if @address.update_attributes(address_params)
      redirect_to address_path(@address), notice: "The address was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    if @address.destroy
      redirect_to customer_path(@address.customer.id), notice: "Address was removed from the system."
    else 
      redirect_to customer_path(@address.customer.id), notice: "The address cannot be deleted at this time"
    end
  end


  private
  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:customer_id, :recipient, :street_1, :street_2, :city, :state, :zip, :active, :is_billing)
  end

end