module Management
  ROUTES = Marten::Routing::Map.draw do
    path "/orders", OrderListHandler, name: "list_orders"
    path "/orders/new", OrderCreateHandler, name: "create_order"
    path "/orders/edit/<pk:int>", OrderUpdateHandler, name: "update_order"
    path "/orders/delete/<pk:int>", OrderDeleteHandler, name: "delete_order"
    path "/orders/collect-order", OrderCollectHandler, name: "collect_order"
    
    path "/batches/new", BatchCreateHandler, name: "create_batch"
    path "/batches", BatchListHandler, name: "list_batches"
    path "/batches/edit/<pk:int>", BatchUpdateHandler, name: "update_batch"
    
    path "/items/new", ItemCreateHandler, name: "create_item"
    path "/items", ItemListHandler, name: "list_items"
    path "/items/edit/<pk:int>", ItemUpdateHandler, name: "update_item"
    
    path "/users", UserListHandler, name: "list_users"
    path "/users/edit/<pk:int>", UserUpdateHandler, name: "update_user"
  end
end
