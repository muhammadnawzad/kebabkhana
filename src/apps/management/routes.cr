module Management
  ROUTES = Marten::Routing::Map.draw do
    path "/orders", ListOrdersHandler, name: "orders"
    path "/create-batch", BatchCreateHandler, name: "create_batch"
    path "/list-batches", BatchListHandler, name: "list_batches"
    path "/update-batch/<pk:int>", BatchUpdateHandler, name: "update_batch"
    path "/create-item", ItemCreateHandler, name: "create_item"
    path "/list-items", ItemListHandler, name: "list_items"
    path "/update-item/<pk:int>", ItemUpdateHandler, name: "update_item"
  end
end
