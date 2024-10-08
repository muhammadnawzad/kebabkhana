module Management
  class OrderLandingHandler < Marten::Handler
    property active_nav_item : String = "home"

    include Auth::RequireSignedInUser
    include NavItemActivateable

    def get
      active_batch = Batch.active
      has_already_ordered = Order.filter(user_id: request.user!.id, batch_id: active_batch.first.not_nil!.id).count > 0 if active_batch.count > 0
      no_active_batch = active_batch.count == 0
      pending_payments = Order.filter(user_id: request.user!.id, status: "unpaid").sum(:total) || 0
      order = Order.filter(user_id: request.user!.id, batch_id: active_batch.first.not_nil!.id).first.not_nil! if has_already_ordered

      render("home/index.html", context: {has_already_ordered: has_already_ordered, pending_payments: pending_payments, no_active_batch: no_active_batch, order: order})
    end
  end
end
