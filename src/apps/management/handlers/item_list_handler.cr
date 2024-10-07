module Management
  class ItemListHandler < Marten::Handlers::RecordList
    property active_nav_item : String = "items"

    include Auth::RequireSignedInUser
    include NavItemActivateable

    template_name "item/list.html"
    model Item
    ordering "-created_at"
  end
end
