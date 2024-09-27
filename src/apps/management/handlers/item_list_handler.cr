module Management
  class ItemListHandler < Marten::Handlers::RecordList
    include Auth::RequireSignedInUser

    before_dispatch :require_admin
    before_render :set_active_nav_item

    template_name "item/list.html"
    model Item

    private def set_active_nav_item
      context[:active_nav_item] = "items"
    end

    private def require_admin
      unless request.user.try(&.admin?)
        raise Marten::HTTP::Errors::PermissionDenied.new
      end
    end
  end
end
