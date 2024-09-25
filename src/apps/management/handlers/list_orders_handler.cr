module Management
  class ListOrdersHandler < Marten::Handlers::Template
    include Auth::RequireSignedInUser

    before_render :set_active_nav_item

    template_name "order/list_orders.html"

    private def set_active_nav_item
      context[:active_nav_item] = "orders"
    end
  end
end
