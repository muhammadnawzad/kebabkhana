module Management
  class OrderDeleteHandler < Marten::Handler
    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser

    @order : Order? = nil

    def post
      order.delete

      redirect reverse("management:list_orders")
    end

    private def order : Order
      @order ||= Order.get!(id: params[:pk])
    end
  end
end
