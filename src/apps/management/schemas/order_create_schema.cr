module Management
  class OrderCreateSchema < Marten::Schema
    field :items, :string, required: true

    validate :validate_items

    private def validate_items
      return unless items?

      parsed_items = JSON.parse(items.not_nil!)

      parsed_items.as_a.each do |parsed_item|
        item_mapping = parsed_item.as_h
        item_id = item_mapping.keys.first
        quantity = item_mapping.values.first.as_i

        if quantity <= 0 || quantity > 10
          errors.add(:items, "Quantity must be between 1 and 10")
          return
        end

        item = Item.get(id: item_id)

        if item.nil?
          errors.add(:items, "Item #{item_id} not found")
          return
        end

        if item.unavailable?
          errors.add(:items, "Item #{item_id} is not available")
          return
        end
      end
    end
  end
end
