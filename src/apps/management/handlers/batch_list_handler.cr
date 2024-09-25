module Management
  class BatchListHandler < Marten::Handlers::RecordList
    include Auth::RequireSignedInUser

    before_render :set_active_nav_item

    template_name "batch/list.html"
    model Batch

    private def set_active_nav_item
      context[:active_nav_item] = "batches"
    end
  end
end
