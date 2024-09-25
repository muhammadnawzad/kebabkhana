module Management
  class BatchCreateHandler < Marten::Handlers::RecordCreate
    include Auth::RequireSignedInUser
    include Flashable

    before_render :set_active_nav_item

    model Batch
    schema BatchCreateSchema
    template_name "batch/create.html"
    success_route_name "management:list_batches"

    private def set_active_nav_item
      context[:active_nav_item] = "batches"
    end
  end
end
