require "./concerns/*"

module Auth
  class ProfileHandler < Marten::Handlers::Template
    property active_nav_item : String = "profile"

    include RequireSignedInUser
    include NavItemActivateable

    before_render :calculate_pending_payments
    
    template_name "auth/profile.html"

    private def calculate_pending_payments
      context[:pending_payments] = Order.filter(user_id: request.user!.id, status: "unpaid").sum(:total) || 0
    end
  end
end
