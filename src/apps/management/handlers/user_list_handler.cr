module Management
  class UserListHandler < Marten::Handlers::RecordList
    property active_nav_item : String = "users"
    
    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include NavItemActivateable

    before_render :add_total_pages_to_context

    template_name "user/list.html"
    model Auth::User
    page_size 10
    ordering "first_name", "last_name"

    def add_total_pages_to_context
     total_pages = ([1, queryset.count].max / @@page_size.not_nil!).ceil.to_i32
     context[:total_pages] = total_pages
    end
  end
end
