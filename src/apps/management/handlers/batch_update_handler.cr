module Management
  class BatchUpdateHandler < Marten::Handlers::RecordUpdate
    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include Flashable

    before_render :set_active_nav_item

    model Batch
    schema BatchUpdateSchema
    template_name "batch/update.html"
    success_route_name "management:list_batches"

    private def set_active_nav_item
      context[:active_nav_item] = "batches"
    end
  end
end
