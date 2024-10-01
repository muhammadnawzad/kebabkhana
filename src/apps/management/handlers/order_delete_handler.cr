module Management
  class OrderDeleteHandler < Marten::Handler
    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser

    @order : Order? = nil

    def post
      order.delete

      redirect request.headers.fetch("Referer").not_nil!
    end

    private def order : Order
      @order ||= Order.get!(id: params[:pk])
    end
  end
end
