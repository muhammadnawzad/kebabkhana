module Management
  class ItemUpdateSchema < Marten::Schema
    field :id, :int
    field :name, :string, max_size: 255, strip: true, required: true
    field :price, :int, required: true
    field :status, :string, max_size: 255, required: true

    validate :validate_name
    validate :validate_status
    validate :validate_price

    private def validate_name
      return unless name?

      if Item.filter(name__iexact: name).exclude(id: id).exists?
        errors.add(:name, "This name is already taken")
      end
    end

    private def validate_status
      return unless status?

      unless Item.statuses.includes?(status)
        errors.add(:status, "Invalid status")
      end
    end

    private def validate_price
      return unless price?

      if price.not_nil! < 0
        errors.add(:price, "Price must be greater than or equal to 0")
      end
    end
  end
end
