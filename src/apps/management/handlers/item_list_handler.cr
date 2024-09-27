module Management
  class ItemListHandler < Marten::Handlers::RecordList
    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser

    before_render :set_active_nav_item

    template_name "item/list.html"
    model Item

    private def set_active_nav_item
      context[:active_nav_item] = "items"
    end
  end
end
