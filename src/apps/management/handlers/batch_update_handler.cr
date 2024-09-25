module Management
  class BatchUpdateHandler < Marten::Handlers::RecordUpdate
    include Auth::RequireSignedInUser
    include Flashable

    model Batch
    schema BatchUpdateSchema
    template_name "batch_update.html"
    success_route_name "management:list_batches"
  end
end
