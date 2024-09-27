require "./concerns/*"

module Auth
  class ProfileHandler < Marten::Handlers::Template
    include RequireSignedInUser

    before_render :set_active_nav_item
    
    template_name "auth/profile.html"
  
    private def set_active_nav_item
      context[:active_nav_item] = "home"
    end
  end
end
