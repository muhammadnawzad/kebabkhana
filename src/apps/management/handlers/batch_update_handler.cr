module Management
  class BatchUpdateHandler < Marten::Handlers::RecordUpdate
    property active_nav_item : String = "batches"

    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include NavItemActivateable
    include Flashable

    model Batch
    schema BatchUpdateSchema
    template_name "batch/update.html"
    success_route_name "management:list_batches"
  end
end
