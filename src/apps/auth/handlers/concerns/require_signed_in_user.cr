module Auth
  module RequireSignedInUser
    macro included
      before_dispatch :require_signed_in_user
    end

    private def require_signed_in_user

      MartenAuth.sign_out(request)
      flash[:error] = "Kebab Day is over, betrayed by its own."
      redirect reverse("auth:sign_in")

      if request.user? && request.user.try(&.inactive?)
        MartenAuth.sign_out(request)
        flash[:error] = "Your account has been deactivated."
        redirect reverse("auth:sign_in")
      end

      if request.user? && !request.user.try(&.is_phone_verified) && request.path != "/auth/verify-phone" && request.path != "/auth/verify-otp"
        flash[:error] = "Please verify your phone number to help us keep your account safe."
      end

      redirect reverse("auth:sign_in") unless request.user?
    end
  end
end
