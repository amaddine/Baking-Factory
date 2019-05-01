module AppHelpers
  module Baking
    def create_baking_list_for(category)
      # returns a hash of item name and quantity to be baked for a 
      # particular category of items like bread, muffins, etc.
      all_items = Item.for_category(category).map(&:name).sort
      baking_list = Hash[all_items.map{|name| [name, 0]}]
      # puts baking_list
      non_shipped = OrderItem.unshipped
      # puts non_shipped
      # unshipped_items = OrderItem.unshipped.map{|oi| [oi.item.name, oi.quantity] if all_items.include?(oi.item.name)}.compact!
      # puts "penis"
      # puts unshipped_items
      filtered = non_shipped.select{|ns| ns.item.category == category}
      if filtered.nil? == false
        filtered.each{|oi| baking_list[oi.item.name] += oi.quantity} unless non_shipped.nil?
      end
      baking_list.delete_if{|key, value| value == 0}
      return baking_list
    end
  end  
end