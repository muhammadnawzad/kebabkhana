module Kebab
  ROUTES = Marten::Routing::Map.draw do
    path "/orders", ListOrdersHandler, name: "orders"
  end
end
