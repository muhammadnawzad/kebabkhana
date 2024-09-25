module Management
  class ItemUpdateHandler < Marten::Handlers::RecordUpdate
    include Auth::RequireSignedInUser
    include Flashable

    model Item
    schema ItemUpdateSchema
    template_name "item_update.html"
    success_route_name "management:list_items"
  end
end
