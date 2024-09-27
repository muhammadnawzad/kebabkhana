module Management
  class BatchListHandler < Marten::Handlers::RecordList
    property active_nav_item : String = "batches"

    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include NavItemActivateable

    template_name "batch/list.html"
    model Batch
  end
end
