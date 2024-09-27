module Management
  class ItemCreateHandler < Marten::Handlers::RecordCreate
    property active_nav_item : String = "items"

    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include NavItemActivateable
    include Flashable

    model Item
    schema ItemCreateSchema
    template_name "item/create.html"
    success_route_name "management:list_items"
  end
end
