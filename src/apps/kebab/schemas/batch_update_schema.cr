class Kebab::BatchUpdateSchema < Marten::Schema
  field :id, :int
  field :name, :string, max_size: 255, strip: true, required: true
  field :status, :string, max_size: 255, required: true

  validate :validate_name
  validate :validate_status

  private def validate_name
    return unless name?

    if Kebab::Batch.filter(name__iexact: name).exclude(id: id).exists?
      errors.add(:name, "This name is already taken")
    end
  end

  private def validate_status
    return unless status?

    unless Kebab::Batch.statuses.includes?(status)
      errors.add(:status, "Invalid status")
    end
  end
end
