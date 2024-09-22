class HomeHandler < Marten::Handler
    include Auth::RequireAnonymousUser

    def get
      render("portal/home.html")
    end
end
