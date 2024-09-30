class OrderCreateHandler < Marten::Handler
  property active_nav_item : String = "orders"

  include Auth::RequireSignedInUser
  include NavItemActivateable

  def get
    render("order/create.html", context: {batches: Batch.active, items: Item.available})
  end

  def post
    data = request.data

    if validate_request_body(data)
      process_valid_schema(data)
    end

    head
  end

  def validate_request_body(data)
    if data.fetch("items").nil?
      flash[:error] = "No items found in the request"
      return false
    end

    if data["total"].nil?
      flash[:error] = "Total is missing in the request"
      return false
    end

    active_batch = Batch.active

    if active_batch.count != 1
      flash[:error] = "Multiple active batches or no active batch found, please make sure there is only one active batch!"
      return false
    end

    true
  end

  private def process_valid_schema(data)
    active_batch = Batch.active.first.not_nil!
    user_id = request.user!.id
    order = nil
    total = data["total"].not_nil!.to_s.to_i

    Order.transaction do
      order = Order.new(
        user_id: user_id,
        batch_id: active_batch.id,
        total: total,
        status: "unpaid",
      )

      order.save!

      items_array = data["items"].as(JSON::Any)
      items_array.as_a.each do |item_data|
        item_id = item_data["id"].not_nil!.to_s.to_i
        quantity = item_data["quantity"].not_nil!.to_s.to_i
        total = item_data["total"].not_nil!.to_s.to_i

        next if quantity.zero?

        if Item.get(id: item_id).nil?
          flash[:error] = "Item with id #{item_id} not found"
          raise Marten::DB::Errors::Rollback.new("Stop!")
        else
          OrderItem.create!(
            order_id: order.id,
            item_id: item_id,
            quantity: quantity,
            total: total,
          )
        end
      end
    end

    if order && order.order_items.count > 0
      flash[:notice] = "Order created successfully!"
    end
  end
end
