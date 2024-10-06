module Auth
  class User < MartenAuth::User
    field :first_name, :string, max_size: 128
    field :last_name, :string, max_size: 128
    field :balance, :int, null: false
    field :role, :string, max_size: 128, default: "client"
    field :status, :string, max_size: 128, default: "active"
    field :assigned_focal_point, :string, max_size: 128, default: "nursery"
    field :team, :string, max_size: 128, default: "dev"

    validate :must_have_dit_issued_email


    private def must_have_dit_issued_email
      errors.add(:name, "must have a DIT issued email") unless email!.split("@").last == "dit.gov.krd"
    end

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

    # Team methods
    def dev? : Bool
      team == "dev"
    end

    def qa? : Bool
      team == "qa"
    end

    def devops? : Bool
      team == "devops"
    end

    def bira? : Bool
      team == "bira"
    end

    def other? : Bool
      team == "other"
    end

    def self.dev : Auth::User::QuerySet
      User.filter(team: "dev")
    end

    def self.qa : Auth::User::QuerySet
      User.filter(team: "qa")
    end

    def self.devops : Auth::User::QuerySet
      User.filter(team: "devops")
    end

    def self.bira : Auth::User::QuerySet
      User.filter(team: "bira")
    end

    def self.other : Auth::User::QuerySet
      User.filter(team: "other")
    end

    def self.teams : Array(String)
      ["dev", "qa", "devops", "bira", "other"]
    end

    # Focal Point methods
    def nursery? : Bool
      assigned_focal_point == "nursery"
    end

    def spaceship? : Bool
      assigned_focal_point == "spaceship"
    end

    def bira_room? : Bool
      assigned_focal_point == "bira_room"
    end

    def self.nursery : Auth::User::QuerySet
      User.filter(assigned_focal_point: "nursery")
    end

    def self.spaceship : Auth::User::QuerySet
      User.filter(assigned_focal_point: "spaceship")
    end

    def self.bira_room : Auth::User::QuerySet
      User.filter(assigned_focal_point: "bira_room")
    end

    def self.assigned_focal_points : Array(String)
      ["nursery", "spaceship", "bira_room"]
    end
  end
end
