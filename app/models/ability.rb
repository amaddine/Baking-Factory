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
      can :index, Item
      can :show, Item
      can :index, Order
      can :baking_list, Item


    elsif user.role? :customer 
      # they can read their own data
      can :show, Customer do |this_customer|  
        user.customer == this_customer
      end

      can :show, Order do |this_order|  
        my_orders = user.customer.orders.map(&:id)
        my_orders.include? this_order.id 
      end

      # they can see lists of pets and visits (controller filters automatically)
      can :index, Item
      can :show, Item

      can :update, Customer do |this_customer|
        this_customer == user.customer
      end

      can :show, User do |this_user|
        this_user.id == user.id
      end

      can :update, User do |this_user| 
        this_user.id == user.id
      end


      can :manage, Customer do |this_customer|
        myself = user.customer
        myself == this_customer
      end

      can :index, Order
      can :checkout, Order
      can :create, Order
      can :add_to_cart, Order
      can :remove_from_cart, Order
      
      can :create, Address
      
      can :show, Address do |this_address|  
        my_addresses = user.customer.addresses.map(&:id)
        my_addresses.include? this_address.id 
      end

      can :update, Address do |this_address|  
        my_addresses = user.customer.addresses.map(&:id)
        my_addresses.include? this_address.id 
      end

      can :destroy, Address do |this_address|  
        my_addresses = user.customer.addresses.map(&:id)
        my_addresses.include? this_address.id 
      end

      can :index, Address




    elsif user.role? :shipper

      can :show, Item
      can :index, Item
      can :index, Order

      can :show, Order
      can :show, Address

      can :shipper_list, User
      can :set_shipped, OrderItem
      can :unset_shipped, OrderItem

      
    else
      can :show, Item
      can :index, Item
      can :create, Customer
      
    end
  end
end