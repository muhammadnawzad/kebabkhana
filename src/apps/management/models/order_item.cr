class OrderItem < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :quantity, :int
  field :total, :int
  field :item, :many_to_one, to: Item, related: :order_items
  field :order, :many_to_one, to: Order, related: :order_items
  with_timestamp_fields
end
