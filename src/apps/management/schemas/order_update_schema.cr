module Management
  class OrderUpdateSchema < Marten::Schema
    field :id, :int
    field :status, :string, max_size: 255, required: true

    validate :validate_status

    private def validate_status
      return unless status?

      unless Order.statuses.includes?(status)
        errors.add(:status, "Invalid status")
      end
    end
  end
end
