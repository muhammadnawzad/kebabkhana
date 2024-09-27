module Management
  class UserUpdateHandler < Marten::Handlers::RecordUpdate
    property active_nav_item : String = "users"

    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include NavItemActivateable
    include Flashable

    model Auth::User
    schema UserUpdateSchema
    template_name "user/update.html"
    success_route_name "management:list_users"
  end
end
