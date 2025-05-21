module Auth
  class VerifyPhoneSchema < Marten::Schema
    field :phone_number, :string, max_size: 128

    validate :validate_phone_number

    private def validate_phone_number
      return unless phone_number?

      if !(/^0?7[3-9]\d{8}$/.matches?(phone_number || ""))
        errors.add("Please enter a correct phone number. Format: 7**1234567")
      end
    end
  end
end
