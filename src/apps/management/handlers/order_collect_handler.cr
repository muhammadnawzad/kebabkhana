module Management
  class OrderCollectHandler < Marten::Handlers::RecordList
    property active_nav_item : String = "orders"

    include Auth::RequireSignedInUser
    include Auth::RequireAdminUser
    include NavItemActivateable

    before_render :categorize_records
    before_render :set_total_per_focal_point

    template_name "order/collect.html"
    model Order
    ordering "-created_at"

    private def queryset
      super.filter(batch_id: Batch.last!.id)
    end

    private def categorize_records
      records = queryset

      categorized_records = records.group_by do |record|
        record.user!.assigned_focal_point
      end

      context[:categorized_records] = categorized_records
    end

    private def set_total_per_focal_point
      records = queryset

      totals = records.group_by do |record|
        record.user!.assigned_focal_point
      end.map do |focal_point, records|
        [focal_point, records.sum { |record| record.total.not_nil! }]
      end.to_h

      context[:totals] = totals
    end
  end
end
