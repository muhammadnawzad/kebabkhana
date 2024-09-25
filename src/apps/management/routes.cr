module Management
  ROUTES = Marten::Routing::Map.draw do
    path "/orders", ListOrdersHandler, name: "orders"
    path "/create-batch", BatchCreateHandler, name: "create_batch"
    path "/list-batches", BatchListHandler, name: "list_batches"
    path "/update-batch/<pk:int>", BatchUpdateHandler, name: "update_batch"
  end
end
