module Auth
  class PasswordResetConfirmSchema < Marten::Schema
    field :password, :string, max_size: 128, strip: false
    field :password_confirmation, :string, max_size: 128, strip: false

    validate :validate_password

    private def validate_password
      return unless password? && password_confirmation?

      if password != password_confirmation
        errors.add("The two password fields do not match")
      end
    end
  end
end
