module Management
  class BatchCreateHandler < Marten::Handlers::RecordCreate
    include Auth::RequireSignedInUser
    include Flashable
    
    model Batch
    schema BatchCreateSchema
    template_name "batch_create.html"
    success_route_name "management:list_batches"
  end
end
