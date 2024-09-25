module Management
  class ItemListHandler < Marten::Handlers::RecordList
    include Auth::RequireSignedInUser

    template_name "item_list.html"
    model Item
  end
end
