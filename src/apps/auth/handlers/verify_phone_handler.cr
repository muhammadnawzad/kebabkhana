module Auth
  class VerifyPhoneHandler < Marten::Handlers::Schema
    include RequireSignedInUser

    schema VerifyPhoneSchema
    template_name "auth/verify_phone.html"
    success_route_name "auth:verify_otp"

    after_failed_schema_validation :generate_failure_flash_message
    after_successful_schema_validation :verify_phone

    private def verify_phone
      Log.info { "Verifying phone number: #{schema.phone_number}" }
      request.user!.generate_phone_verification_challenge(schema.phone_number || "")

      if request.user!.phone_number == schema.phone_number
        Log.info { "Phone verification challenge generated: #{request.user!.phone_verification_challenge}" }
        
        request.user!.save!
        flash[:notice] = "OTP sent to your phone number."
        
        return
      end

      flash[:error] = "Failed to send OTP, please contact administrator."
      redirect reverse("auth:verify_phone")
    end

    private def generate_failure_flash_message : Nil
      flash[:error] = "Invalid phone number! Please try again."
    end
  end
end
