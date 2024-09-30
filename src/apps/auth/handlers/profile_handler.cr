require "./concerns/*"

module Auth
  class ProfileHandler < Marten::Handlers::Template
    property active_nav_item : String = "profile"

    include RequireSignedInUser
    include NavItemActivateable
    
    template_name "auth/profile.html"
  end
end
