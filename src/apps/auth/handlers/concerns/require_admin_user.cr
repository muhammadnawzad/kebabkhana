module Auth
  module RequireAdminUser
    macro included
      before_dispatch :require_admin
    end

    private def require_admin
      unless request.user.try(&.admin?)
        raise Marten::HTTP::Errors::PermissionDenied.new
      end
    end
  end
end
