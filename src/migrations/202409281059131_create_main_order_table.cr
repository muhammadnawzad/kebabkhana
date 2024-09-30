# Generated by Marten 0.5.2 on 2024-09-28 10:59:13 +03:00

class Migration::Main::V202409281059131 < Marten::Migration
  depends_on :auth, "0001_create_auth_user_table"
  depends_on :management, "202409241627091_create_management_batch_table"

  def plan
    create_table :main_order do
      column :id, :big_int, primary_key: true, auto: true
      column :total, :int, null: false, default: 0
      column :status, :string, max_size: 255, null: false, index: true, default: "unpaid"
      column :user_id, :reference, to_table: :auth_user, to_column: :id
      column :batch_id, :reference, to_table: :management_batch, to_column: :id
      column :created_at, :date_time
      column :updated_at, :date_time
    end
  end
end
