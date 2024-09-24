module Management
  class Batch < Marten::Model
    field :id, :big_int, primary_key: true, auto: true
    field :name, :string, max_size: 255, unique: true, index: true
    field :status, :string, max_size: 255, default: "active", null: false, index: true
    with_timestamp_fields

    def active? : Bool 
      status == "active"
    end

    def inactive? : Bool
      status == "inactive"
    end

    def active : Management::Batch::QuerySet
      Batch.filter(status: "active")
    end

    def inactive : Management::Batch::QuerySet
      Batch.filter(status: "inactive")
    end

    def self.statuses : Array(String)
      ["active", "inactive"]
    end
  end
end
