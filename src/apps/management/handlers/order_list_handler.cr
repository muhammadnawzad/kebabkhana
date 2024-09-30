module Management
  class OrderListHandler < Marten::Handlers::RecordList
    property active_nav_item : String = "orders"

    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include NavItemActivateable

    template_name "order/list.html"
    model Order
  end
end
