module Management
  class OrderUpdateHandler < Marten::Handlers::RecordUpdate
    property active_nav_item : String = "orders"

    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include NavItemActivateable
    include Flashable

    model Order
    schema OrderUpdateSchema
    template_name "order/collect.html"
    success_route_name "management:collect_order"
  end
end
