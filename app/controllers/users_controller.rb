class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @users = User.all.paginate(page: params[:page]).per_page(15)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Successfully added #{@user.id} as a user."
      redirect_to users_url
    else
      render action: 'new'
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "Successfully updated #{@user.proper_name}."
      redirect_to users_url
    else
      render action: 'edit'
    end
  end

  def destroy
  end

  private
  def set_user
    @user = User.find(params[:id])
  end 

  def user_params
    params.require(:user).permit(:username, :role, :active, :password, :password_confirmation)
  end 
end