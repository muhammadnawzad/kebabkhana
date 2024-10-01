module Management
  class OrderListHandler < Marten::Handlers::RecordList
    property active_nav_item : String = "orders"

    include Auth::RequireSignedInUser
    include NavItemActivateable

    template_name "order/list.html"
    model Order

    def queryset
      if request.user.not_nil!.admin?
        super
      else
        super.filter(user_id: request.user.not_nil!.id)
      end
    end
  end
end
