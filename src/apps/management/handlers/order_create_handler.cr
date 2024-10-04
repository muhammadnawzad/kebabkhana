module Management
  class OrderCreateHandler < Marten::Handlers::RecordCreate
    property active_nav_item : String = "orders"

    include Auth::RequireSignedInUser
    include NavItemActivateable
    include Flashable

    model Order
    schema OrderCreateSchema
    template_name "order/create.html"
    success_route_name "management:list_orders"

    before_dispatch :require_active_batch
    before_render :update_context
    before_schema_validation :set_defaults

    private def require_active_batch
      if Batch.active_batch.nil?
        flash[:error] = "No active batch found, please make sure there is an active batch!"
        redirect reverse("management:list_orders")
      end
    end

    private def update_context
      active_batch = Batch.active
      has_already_ordered = Order.filter(user_id: request.user!.id, batch_id: active_batch.first.not_nil!.id).count > 0

      context["items"] = Item.available
      context["has_already_ordered"] = has_already_ordered
    end

    private def set_defaults
      schema.validated_data["user_id"] = (request.user.not_nil!.id.not_nil!).to_i64
      schema.validated_data["batch_id"] = Batch.active_batch.not_nil!.id.not_nil!.to_i64
      schema.validated_data["status"] = "unpaid"
    end

    def process_valid_schema
      Order.transaction do
        order = Order.create!(
          user_id: schema.validated_data["user_id"],
          batch_id: schema.validated_data["batch_id"],
          status: schema.validated_data["status"],
          total: 0
        )

        if schema.validated_data["items"].nil?
          flash[:error] = "No items found in the order"
          raise Marten::DB::Errors::Rollback.new("No items found in the order")
        else
          create_order_items(order, schema.validated_data["items"].to_s)
          order.reload
          order.save # Trigger the callback to calculate the total
        end
      end

      redirect reverse("management:list_orders")
    end

    private def create_order_items(order, items : String)
      parsed_items = JSON.parse(items)

      parsed_items.as_a.each do |parsed_item|
        item_mapping = parsed_item.as_h
        item_id = item_mapping.keys.first
        quantity = item_mapping.values.first.as_i

        next if quantity.zero?

        item = Item.get!(id: item_id)

        OrderItem.create!(
          order_id: order.id,
          item_id: item.id.not_nil!,
          quantity: quantity,
          total: quantity * item.price.not_nil!
        )
      end
    end
  end
end
