module NavItemActivateable
  macro included
    before_render :set_active_nav_item
  end

  private def set_active_nav_item
    context[:active_nav_item] = active_nav_item
  end
end
