module Management
  class OrderListHandler < Marten::Handlers::RecordList
    property active_nav_item : String = "orders"

    include Auth::RequireSignedInUser
    include NavItemActivateable

    before_render :add_total_pages_to_context

    template_name "order/list.html"
    model Order
    page_size 9
    ordering "-created_at"

    private def add_total_pages_to_context
      total_pages = ([1, queryset.count].max / @@page_size.not_nil!).ceil.to_i32
      context[:total_pages] = total_pages
    end
  end
end
