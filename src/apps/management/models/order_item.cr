class OrderItem < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :quantity, :int
  field :total, :int
  field :item, :many_to_one, to: Item, related: :order_items
  field :order, :many_to_one, to: Order, related: :order_items, on_delete: :cascade
  with_timestamp_fields

  # Callbacks
  before_save :calculate_total

  def calculate_total
    self.total = (item.not_nil!.price || 0) * (quantity || 0)
  end
end
