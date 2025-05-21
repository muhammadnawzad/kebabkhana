module Auth
  class VerifyOtpHandler < Marten::Handlers::Schema
    include RequireSignedInUser

    schema VerifyOtpSchema
    template_name "auth/verify_otp.html"
    success_route_name "auth:profile"

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
  end
end
