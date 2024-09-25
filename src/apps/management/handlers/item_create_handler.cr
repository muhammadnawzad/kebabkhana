module Management
  class ItemCreateHandler < Marten::Handlers::RecordCreate
    include Auth::RequireSignedInUser
    include Flashable

    model Item
    schema ItemCreateSchema
    template_name "item_create.html"
    success_route_name "management:list_items"
  end
end
