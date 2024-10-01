class Batch < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :name, :string, max_size: 255, unique: true, index: true
  field :status, :string, max_size: 255, default: "active", null: false, index: true
  with_timestamp_fields

  def order_count : Float64 | Int32
    count = orders.count
    # Ensure the count is cast to the correct type
    if count.is_a?(Int64)
      count.to_i # Convert Int64 to Int32
    else
      count
    end
  end

  def total : Float64 | Int32
    orders.sum(:total) || 0
  end

  def total_paid : Float64 | Int32
    orders.filter(status: "paid").sum(:total) || 0
  end

  def items : Hash(String, Int32)
    # Initialize the hash to store item name and its total quantity
    items_count = {} of String => Int32

    # Prefetch orders, order_items, and items
    orders = Order.filter(batch_id: self.id).prefetch(:order_items__item)

    # Loop through each order and order_item to accumulate item counts
    orders.each do |order|
      order.order_items.each do |order_item|
        # Safe navigation to ensure item exists
        if item_name = order_item.item!.name
          items_count[item_name] ||= 0
          items_count[item_name] += (order_item.quantity || 0)
        end
      end
    end

    items_count
  end

  def active? : Bool
    status == "active"
  end

  def inactive? : Bool
    status == "inactive"
  end

  def self.active : Batch::QuerySet
    Batch.filter(status: "active")
  end

  def self.inactive : Batch::QuerySet
    Batch.filter(status: "inactive")
  end

  def self.statuses : Array(String)
    ["active", "inactive"]
  end
end
