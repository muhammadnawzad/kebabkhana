module Auth
  class SignUpSchema < Marten::Schema
    field :first_name, :string, max_size: 128, strip: true
    field :last_name, :string, max_size: 128, strip: true
    field :email, :email
    field :password, :string, max_size: 128, strip: false
    field :password_confirmation, :string, max_size: 128, strip: false

    validate :validate_email
    validate :validate_password

    private def validate_email
      return unless email?

      if User.filter(email__iexact: email).exists?
        errors.add(:email, "This email address is already taken")
      end
    end

    private def validate_password
      return unless password? && password_confirmation?

      if password != password_confirmation
        errors.add("The two password fields do not match")
      end
    end
  end
end
