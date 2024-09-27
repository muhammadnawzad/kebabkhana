module Management
  class ItemUpdateHandler < Marten::Handlers::RecordUpdate
    property active_nav_item : String = "items"

    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include NavItemActivateable
    include Flashable

    model Item
    schema ItemUpdateSchema
    template_name "item/update.html"
    success_route_name "management:list_items"
  end
end
