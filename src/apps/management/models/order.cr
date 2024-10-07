class Order < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :total, :int, null: false
  field :status, :string, max_size: 255, null: false
  field :user, :many_to_one, to: Auth::User
  field :batch, :many_to_one, to: Batch, related: :orders
  with_timestamp_fields

  # Validations
  validate :user_must_exist
  validate :batch_must_exist
  validate :status_should_be_valid
  validate :total_should_be_correct

  # Callbacks
  before_save :calculate_total

  # Private instance methods
  private def user_must_exist : Nil
    if user.nil?
      errors.add(:user, "User must exist")
    end
  end

  private def batch_must_exist : Nil
    if batch.nil?
      errors.add(:batch, "Batch must exist")
    end
  end

  private def status_should_be_valid : Nil
    unless Order.statuses.includes?(status)
      errors.add(:status, "Invalid status")
    end
  end

  private def total_should_be_correct : Nil
    if total.nil? || total! < 0
      errors.add(:total, "Total should be greater or equal to 0")
    end
  end

  # Public instance methods
  def calculate_total : Nil
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

  def items : Array(Item)
    items_available = [] of Item

    items_available = Item.all.raw("SELECT items.* FROM items JOIN order_items ON order_items.item_id = items.id WHERE order_items.order_id = ?", id).each do |item|
      item
    end

    items_available || [] of Item
  end

  def paid? : Bool
    status == "paid"
  end

  # Class methods
  def self.statuses : Array(String)
    ["paid", "unpaid"]
  end
end
