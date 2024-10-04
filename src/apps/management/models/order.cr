class Order < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :total, :int, null: false
  field :status, :string, max_size: 255, null: false
  field :user, :many_to_one, to: Auth::User
  field :batch, :many_to_one, to: Batch, related: :orders
  with_timestamp_fields

  # Callbacks
  before_save :calculate_total

  def calculate_total
    subtotal = 0

    if order_items.count.zero?
      self.total = subtotal
      return
    end

    order_items.not_nil!.each do |order_item|
      subtotal += (order_item.total || 0)
    end

    self.total = subtotal
  end

  # Associations
  def items : Array(Item)
    items_available = [] of Item

    items_available = Item.all.raw("SELECT items.* FROM items JOIN order_items ON order_items.item_id = items.id WHERE order_items.order_id = ?", id).each do |item|
      item
    end

    items_available || [] of Item
  end

  # Status methods
  def paid? : Bool
    status == "paid"
  end

  def unpaid? : Bool
    status == "unpaid"
  end

  def self.paid : Order::QuerySet
    Order.filter(status: "paid")
  end

  def self.unpaid : Order::QuerySet
    Order.filter(status: "unpaid")
  end

  def self.statuses : Array(String)
    ["paid", "unpaid"]
  end
end
