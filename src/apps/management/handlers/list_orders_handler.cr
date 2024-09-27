module Management
  class ListOrdersHandler < Marten::Handlers::Template
    property active_nav_item : String = "orders"

    include Auth::RequireSignedInUser
    include NavItemActivateable

    template_name "order/list_orders.html"
  end
end
