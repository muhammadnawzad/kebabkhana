module Auth
  class VerifyOtpSchema < Marten::Schema
    field :otp, :string, max_size: 128

    validate :validate_otp

    private def validate_otp
      return unless otp?

      if otp!.size != 6 || !(/^[0-9]{6}$/.matches?(otp || ""))
        errors.add("Please enter a correct OTP. Format: 123456")
      end
    end
  end
end
