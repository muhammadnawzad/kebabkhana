module Management
  class UserListHandler < Marten::Handlers::RecordList
    property active_nav_item : String = "users"

    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include NavItemActivateable

    template_name "user/list.html"
    model Auth::User

    def queryset
      super.order("-created_at")
    end
  end
end
