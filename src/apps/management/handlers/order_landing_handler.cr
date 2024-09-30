module Management
  class OrderLandingHandler < Marten::Handler
    property active_nav_item : String = "home"

    include Auth::RequireSignedInUser
    include NavItemActivateable

    def get
      render("home/index.html")
    end
  end
end
