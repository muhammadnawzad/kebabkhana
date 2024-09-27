module Auth
  module RequireSignedInUser
    macro included
      before_dispatch :require_signed_in_user
    end

    private def require_signed_in_user
      if request.user? && request.user.try(&.inactive?)
        MartenAuth.sign_out(request)
        flash[:error] = "Your account has been deactivated."
        redirect reverse("auth:sign_in")
      end

      redirect reverse("auth:sign_in") unless request.user?
    end
  end
end
