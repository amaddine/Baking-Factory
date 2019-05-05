class SessionsController < ApplicationController
  include AppHelpers::Cart


  def new
  end
  
  def create
    user = User.authenticate(params[:username], params[:password])
    create_cart()
    
    if user
      session[:user_id] = user.id
      if user.role?(:shipper)
        redirect_to shipper_list_path
      elsif user.role?(:baker)
        redirect_to baking_list_path
      elsif user.role?(:admin)
        redirect_to admin_dashboard_path
      else 
        redirect_to home_path, notice: "Logged in!"
      end
    else
      flash.now.alert = "Username and/or password is invalid"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    destroy_cart()
    redirect_to home_path, notice: "Logged out!"
  end

  def view_cart
  end

end