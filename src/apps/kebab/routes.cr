module Kebab
  ROUTES = Marten::Routing::Map.draw do
    path "/orders", ListOrdersHandler, name: "orders"
    path "/create-batch", Batches::CreateHandler, name: "create_batch"
    path "/list-batches", Batches::ListHandler, name: "list_batches"
    path "/update-batch/<pk:int>", Batches::UpdateHandler, name: "update_batch"
  end
end
