module Management
  class BatchListHandler < Marten::Handlers::RecordList
    include Auth::RequireSignedInUser

    template_name "batch/list.html"
    model Batch
  end
end
