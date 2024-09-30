class Item < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :name, :string, max_size: 255, unique: true, index: true
  field :price, :int, null: false
  field :status, :string, max_size: 255, default: "available", null: false, index: true
  with_timestamp_fields

  def available? : Bool
    status == "available"
  end

  def unavailable? : Bool
    status == "unavailable"
  end

  def self.available : Item::QuerySet
    Item.filter(status: "available")
  end

  def self.unavailable : Item::QuerySet
    Item.filter(status: "unavailable")
  end

  def self.statuses : Array(String)
    ["available", "unavailable"]
  end
end
