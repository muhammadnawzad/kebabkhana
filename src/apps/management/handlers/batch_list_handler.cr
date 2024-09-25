module Management
  class BatchListHandler < Marten::Handlers::RecordList
    include Auth::RequireSignedInUser

    template_name "batch_list.html"
    model Batch
  end
end
