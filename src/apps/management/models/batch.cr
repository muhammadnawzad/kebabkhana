class Batch < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :name, :string, max_size: 255, unique: true, index: true
  field :status, :string, max_size: 255, default: "active", null: false, index: true
  with_timestamp_fields

  # Validations
  validate :name_should_be_unique
  validate :status_should_be_valid
  validate :only_one_active_batch_allowed

  # Private instance methods
  private def name_should_be_unique : Nil
    if Batch.filter(name__iexact: name).exclude(id: id).exists?
      errors.add(:name, "This name is already taken")
    end
  end

  private def status_should_be_valid : Nil
    unless Batch.statuses.includes?(status)
      errors.add(:status, "Invalid status")
    end
  end

  private def only_one_active_batch_allowed : Nil
    if active? && Batch.active.count > 1
      errors.add(:status, "Only one active batch is allowed")
    end
  end

  # Public instance methods
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

  # Class methods
  def self.active_batch : Batch?
    if Batch.active.count == 1
      Batch.active.first
    elsif Batch.active.count > 1
      raise "Multiple active batches found, please make sure there is only one active batch!"
    else
      nil
    end
  end

  def self.active : Batch::QuerySet
    Batch.filter(status: "active")
  end

  def self.statuses : Array(String)
    ["active", "locked"]
  end
end
