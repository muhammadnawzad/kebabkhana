module Management
  class UserUpdateSchema < Marten::Schema
    field :id, :int
    field :first_name, :string, max_size: 128, strip: true
    field :last_name, :string, max_size: 128, strip: true
    field :email, :email, strip: true
    field :status, :string, max_size: 128, strip: true
    field :role, :string, max_size: 128, strip: true
    field :balance, :int

    validate :validate_email
    validate :validate_status
    validate :validate_role

    private def validate_email
      return unless email?

      if Auth::User.filter(email__iexact: email).exclude(id: id).exists?
        errors.add(:email, "This email address is already taken")
      end
    end

    private def validate_status
      return unless status?

      unless Auth::User.statuses.includes?(status)
        errors.add(:status, "Invalid status")
      end
    end

    private def validate_role
      return unless role?

      unless Auth::User.roles.includes?(role)
        errors.add(:role, "Invalid role")
      end
    end
  end
end
