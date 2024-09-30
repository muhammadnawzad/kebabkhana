module Auth
  module RequireAnonymousUser
    macro included
      before_dispatch :require_anonymous_user
    end

    private def require_anonymous_user
      redirect reverse("landing") if request.user?
    end
  end
end
