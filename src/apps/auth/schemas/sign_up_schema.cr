module Auth
  class SignUpSchema < Marten::Schema
    field :first_name, :string, max_size: 128, strip: true
    field :last_name, :string, max_size: 128, strip: true
    field :email, :email
    field :password, :string, max_size: 128, strip: false
    field :password_confirmation, :string, max_size: 128, strip: false
    field :team, :string, max_size: 128

    validate :validate_email
    validate :validate_password
    validate :validate_team

    private def validate_email
      return unless email?

      if User.filter(email__iexact: email).exists?
        errors.add(:email, "This email address is already taken")
      end

      unless email!.split("@").last == "dit.gov.krd"
        errors.add(:email, "Email must be issued by DIT")
      end
    end

    private def validate_password
      return unless password? && password_confirmation?

      if password != password_confirmation
        errors.add("The two password fields do not match")
      end
    end

    private def validate_team
      return unless team?

      unless User.teams.includes?(team)
        errors.add(:team, "Invalid team")
      end
    end
  end
end
