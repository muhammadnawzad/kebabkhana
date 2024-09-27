module Management
  class ItemUpdateHandler < Marten::Handlers::RecordUpdate
    include Auth::RequireSignedInUser
    include Flashable

    before_dispatch :require_admin
    before_render :set_active_nav_item

    model Item
    schema ItemUpdateSchema
    template_name "item/update.html"
    success_route_name "management:list_items"

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
