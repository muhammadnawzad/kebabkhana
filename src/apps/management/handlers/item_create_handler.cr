module Management
  class ItemCreateHandler < Marten::Handlers::RecordCreate
    include Auth::RequireSignedInUser
    include Flashable

    before_dispatch :require_admin
    before_render :set_active_nav_item

    model Item
    schema ItemCreateSchema
    template_name "item/create.html"
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
