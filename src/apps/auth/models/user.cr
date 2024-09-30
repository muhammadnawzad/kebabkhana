module Auth
  class User < MartenAuth::User
    field :first_name, :string, max_size: 128
    field :last_name, :string, max_size: 128
    field :balance, :int, null: false
    field :role, :string, max_size: 128, default: "client"
    field :status, :string, max_size: 128, default: "active"

    def full_name
      "#{first_name} #{last_name}"
    end

    # Role methods
    def admin? : Bool
      role == "admin"
    end
  
    def client? : Bool
      role == "client"
    end
  
    def self.admin : Auth::User::QuerySet
      User.filter(role: "admin")
    end
  
    def self.client : Auth::User::QuerySet
      User.filter(role: "client")
    end
  
    def self.roles : Array(String)
      ["admin", "client"]
    end

    # Status methods
    def active? : Bool
      status == "active"
    end

    def inactive? : Bool
      status == "inactive"
    end

    def self.active : Auth::User::QuerySet
      User.filter(status: "active")
    end

    def self.inactive : Auth::User::QuerySet
      User.filter(status: "inactive")
    end

    def self.statuses : Array(String)
      ["active", "inactive"]
    end
  end
end
