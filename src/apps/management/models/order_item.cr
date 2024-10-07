class OrderItem < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :quantity, :int
  field :total, :int
  field :item, :many_to_one, to: Item, related: :order_items
  field :order, :many_to_one, to: Order, related: :order_items, on_delete: :cascade
  with_timestamp_fields
  
  # Validations
  validate :quantity_should_be_correct
  validate :total_should_be_correct
  validate :item_must_exist
  validate :order_must_exist
  
  # Callbacks
  before_save :calculate_total

  # Private instance methods
  private def quantity_should_be_correct : Nil
    if quantity.nil? || quantity! < 1 || quantity! > 10
      errors.add(:quantity, "Quantity should be between 1 and 10")
    end
  end

  private def total_should_be_correct : Nil
    if total.nil? || total! < 1
      errors.add(:total, "Total should be greater than 0")
    end
  end

  private def item_must_exist : Nil
    if item.nil?
      errors.add(:item, "Item must exist")
    end
  end

  private def order_must_exist : Nil
    if order.nil?
      errors.add(:order, "Order must exist")
    end
  end

  # Public instance methods
  def calculate_total : Nil
    self.total = (item.not_nil!.price || 0) * (quantity || 0)
  end
end
