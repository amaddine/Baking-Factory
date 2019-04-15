class Ability
  include CanCan::Ability

  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    
    # set authorizations for different user roles
    if user.role? :admin
      # they get to do it all
      can :manage, :all
      
    elsif user.role? :baker
      # can manage owners, pets, and visits
      
      # can read (costs for) medicines and procedures
      can :read, Order#Cost

      # they can read their own profile
      can :show, User do |u|  
        u.id == user.id
      end

      # they can update their own profile
      can :update, User do |u|  
        u.id == user.id
      end


    elsif user.role? :customer 
      # they can read their own data
      can :show, Customer do |this_customer|  
        user.customer == this_customer
      end

      # they can see lists of pets and visits (controller filters automatically)
      can :index, OrderItem

      # they can read their own pets' data
      can :show, Order do |this_order|  
        my_orders = user.customer.orders.map(&:id)
        my_orders.include? this_order.id 
      end

      can :manage, Customer do |this_customer|
        myself = user.customer
        myself == this_customer
      end

      # they can read their own visits' data

    elsif user.role? :shipper

      can :show, User do |u|  
        u.id == user.id
      end

      # they can update their own profile
      can :update, User do |u|  
        u.id == user.id
      end
      
    else
      # guests can only read animals covered (plus home pages)
      # can :read, Animal
      can :index, OrderItem
      
    end
  end
end