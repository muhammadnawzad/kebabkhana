module Kebab
  class ListOrdersHandler < Marten::Handlers::Template
    include Auth::RequireSignedInUser

    template_name "order/list_orders.html"
  end
end
