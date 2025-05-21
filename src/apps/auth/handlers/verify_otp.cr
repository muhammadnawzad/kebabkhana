module Auth
  class VerifyOtpHandler < Marten::Handlers::Schema
    include RequireSignedInUser

    schema VerifyOtpSchema
    template_name "auth/verify_otp.html"
    success_route_name "auth:profile"

    before_dispatch :check_if_user_has_phone_number
    after_successful_schema_validation :verify_otp
    after_failed_schema_validation :generate_failure_flash_message
    
    private def verify_otp
      Log.info { "Verifying OTP: #{schema.otp}" }
      request.user!.verify_otp(schema.otp || "")

      if request.user!.is_phone_verified
        Log.info { "OTP verified: #{request.user!.is_phone_verified}" }
        
        request.user!.save!
        flash[:notice] = "Phone number verified successfully."

        return
      end

      flash[:error] = "Failed to verify OTP, please contact administrator."
      redirect reverse("auth:verify_otp")
    end

    private def generate_failure_flash_message : Nil
      flash[:error] = "Invalid OTP! Please try again."
    end

    private def check_if_user_has_phone_number
      return if !request.user!.phone_number.try &.empty? && !request.user!.phone_verification_challenge.try &.empty? && !request.user!.is_phone_verified

      flash[:error] = "Your account is either verified or does not have a phone number. Please try adding a phone number to your account."
      redirect reverse("auth:verify_phone")
    end
  end
end
