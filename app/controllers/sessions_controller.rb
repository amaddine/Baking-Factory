class SessionsController < ApplicationController
  include AppHelpers::Cart


  def new
  end
  
  def create
    user = User.authenticate(params[:username], params[:password])
    create_cart()
    
    if user
      session[:user_id] = user.id
      redirect_to home_path, notice: "Logged in!"
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