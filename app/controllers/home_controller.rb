class HomeController < ApplicationController

  def home
  end

  def about
  end

  def privacy
  end

  def contact
  end

  def search
    redirect_back(fallback_location: home_path) if params[:query].blank?
    @query = params[:query]
    if current_user.role?(:admin)
      @customers = Customer.search(@query)
      @items = Item.search(@query)
      @total_hits = @customers.size + @items.size
    else
      @items = Item.search(@query)
      @total_hits = @items.size
    end
  end

end