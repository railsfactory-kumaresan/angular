class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.string :name
      t.string :address
      t.integer :client_id

      t.timestamps
    end
  end
end
