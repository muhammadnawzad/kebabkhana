module Auth
  class User < MartenAuth::User
    field :first_name, :string, max_size: 128
    field :last_name, :string, max_size: 128
    field :balance, :int, null: false
    field :role, :string, max_size: 128, default: "client"
    field :status, :string, max_size: 128, default: "active"
    field :assigned_focal_point, :string, max_size: 128, default: "nursery"
    field :team, :string, max_size: 128, default: "dev"
    field :phone_number, :string, max_size: 128, default: ""
    field :is_phone_verified, :bool, default: false
    field :phone_verification_challenge, :string, max_size: 128, default: ""

    # Validations
    validate :must_have_dit_issued_email
    validate :role_must_be_valid
    validate :status_must_be_valid
    validate :team_must_be_valid
    validate :assigned_focal_point_must_be_valid

    # Callbacks
    before_save :remove_leading_zero_from_phone_number

    # Private instance methods
    private def remove_leading_zero_from_phone_number : Nil
      self.phone_number = (phone_number || "").gsub(/^0/, "")
    end

    private def must_have_dit_issued_email : Nil
      errors.add(:name, "must have a DIT issued email") unless email!.split("@").last == "dit.gov.krd"
    end

    private def role_must_be_valid : Nil
      unless User.roles.includes?(role)
        errors.add(:role, "Invalid role")
      end
    end

    private def status_must_be_valid : Nil
      unless User.statuses.includes?(status)
        errors.add(:status, "Invalid status")
      end
    end

    private def team_must_be_valid : Nil
      unless User.teams.includes?(team)
        errors.add(:team, "Invalid team")
      end
    end

    private def assigned_focal_point_must_be_valid : Nil
      unless User.assigned_focal_points.includes?(assigned_focal_point)
        errors.add(:assigned_focal_point, "Invalid assigned focal point")
      end
    end

    # Public instance methods
    def generate_phone_verification_challenge(phone_number : String) : Bool
      return false if !(/^0?7[3-9]\d{8}$/.matches?(phone_number || ""))

      begin
        otp_service = Auth::OTPService.new
        challenge_id = otp_service.send_otp(id.to_s, phone_number)

        self.phone_number = phone_number
        self.phone_verification_challenge = challenge_id
        self.is_phone_verified = false

        true
      rescue e : Exception
        Log.error { "Error generating phone verification challenge: #{e}" }
        false
      end
    end

    def verify_otp(otp : String) : Bool
      return false if otp.size != 6 || !(/^[0-9]{6}$/.matches?(otp))

      otp_service = Auth::OTPService.new
      verified = otp_service.verify_otp(phone_verification_challenge || "", otp)

      self.is_phone_verified = verified
      verified
    end

    def full_name : String
      "#{first_name} #{last_name}"
    end

    def admin? : Bool
      role == "admin"
    end
  
    def client? : Bool
      role == "client"
    end

    def active? : Bool
      status == "active"
    end

    def inactive? : Bool
      status == "inactive"
    end

    # Class methods
    def self.roles : Array(String)
      ["admin", "client"]
    end

    def self.statuses : Array(String)
      ["active", "inactive"]
    end

    def self.teams : Array(String)
      ["dev", "qa", "devops", "bira", "other"]
    end

    def self.assigned_focal_points : Array(String)
      ["nursery", "spaceship", "bira_room"]
    end
  end
end
