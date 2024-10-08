class Migration::Auth::V0001 < Marten::Migration
  def plan
    create_table :auth_user do
      column :id, :big_int, primary_key: true, auto: true
      column :email, :string, max_size: 254, unique: true
      column :role, :string, max_size: 128, default: "client"
      column :status, :string, max_size: 128, default: "active"
      column :assigned_focal_point, :string, max_size: 128, default: "nursery"
      column :team, :string, max_size: 128, default: "dev"
      column :balance, :int, null: false
      column :first_name, :string, max_size: 128
      column :last_name, :string, max_size: 128
      column :password, :string, max_size: 128
      column :created_at, :date_time
      column :updated_at, :date_time
    end
  end
end
