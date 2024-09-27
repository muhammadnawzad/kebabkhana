module Management
  class BatchCreateHandler < Marten::Handlers::RecordCreate
    property active_nav_item : String = "batches"

    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include NavItemActivateable
    include Flashable

    model Batch
    schema BatchCreateSchema
    template_name "batch/create.html"
    success_route_name "management:list_batches"
  end
end
