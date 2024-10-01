module Management
  class ItemListHandler < Marten::Handlers::RecordList
    property active_nav_item : String = "items"

    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include NavItemActivateable

    template_name "item/list.html"
    model Item

    def queryset
      super.order("-created_at")
    end
  end
end
