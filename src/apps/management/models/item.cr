class Item < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :name, :string, max_size: 255, unique: true, index: true
  field :price, :int, null: false
  field :status, :string, max_size: 255, default: "available", null: false, index: true
  with_timestamp_fields

  # Validations
  validate :name_should_be_unique
  validate :status_should_be_valid

  # Private instance methods
  private def name_should_be_unique : Nil
    if Item.filter(name__iexact: name).exclude(id: id).exists?
      errors.add(:name, "This name is already taken")
    end
  end

  private def status_should_be_valid : Nil
    unless Item.statuses.includes?(status)
      errors.add(:status, "Invalid status")
    end
  end

  # Public instance methods
  def available? : Bool
    status == "available"
  end

  def unavailable? : Bool
    status == "unavailable"
  end

  # Class methods
  def self.available : Item::QuerySet
    Item.filter(status: "available")
  end

  def self.statuses : Array(String)
    ["available", "unavailable"]
  end
end
