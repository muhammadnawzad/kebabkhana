module Management
  class BatchListHandler < Marten::Handlers::RecordList
    property active_nav_item : String = "batches"

    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include NavItemActivateable

    before_render :add_total_pages_to_context

    template_name "batch/list.html"
    model Batch
    page_size 6
    ordering "-created_at"

    private def add_total_pages_to_context
      total_pages = ([1, queryset.count].max / @@page_size.not_nil!).ceil.to_i32
      context[:total_pages] = total_pages
    end
  end
end
