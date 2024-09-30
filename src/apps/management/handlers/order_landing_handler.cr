module Management
  class OrderLandingHandler < Marten::Handler
    property active_nav_item : String = "home"

    include Auth::RequireSignedInUser
    include NavItemActivateable

    def get
      active_batch = Batch.active
      has_already_ordered = Order.filter(user_id: request.user!.id, batch_id: active_batch.first.not_nil!.id).count > 0
      pending_payments = Order.filter(user_id: request.user!.id, status: "unpaid").sum(:total) || 0

      render("home/index.html", context: {has_already_ordered: has_already_ordered, pending_payments: pending_payments})
    end
  end
end
