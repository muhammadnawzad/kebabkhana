module Auth
  class PasswordUpdateSchema < Marten::Schema
    property :user
    field :old_password, :string, max_size: 128, strip: false
    field :new_password, :string, max_size: 128, strip: false
    field :new_confirm_password, :string, max_size: 128, strip: false

    @user : User?

    validate :validate_password

    private def validate_password
      return unless old_password? && new_password? && new_confirm_password?

      # ameba:disable Lint/NotNil
      errors.add(:old_password, "Invalid user password") unless @user.not_nil!.check_password(old_password!)

      errors.add("Your new confirmed password does not match") if new_password != new_confirm_password
    end
  end
end
