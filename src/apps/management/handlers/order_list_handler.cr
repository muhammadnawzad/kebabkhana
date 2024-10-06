module Management
  class OrderListHandler < Marten::Handlers::RecordList
    property active_nav_item : String = "orders"

    include Auth::RequireSignedInUser
    include NavItemActivateable

    before_render :add_total_pages_to_context

    template_name "order/list.html"
    model Order
    page_size 6
    ordering "-created_at"

    def queryset
      if request.user.not_nil!.admin?
        super
      else
        super.filter(user_id: request.user.not_nil!.id)
      end
    end

    private def add_total_pages_to_context
      total_pages = ([1, queryset.count].max / @@page_size.not_nil!).ceil.to_i32
      context[:total_pages] = total_pages
    end
  end
end
