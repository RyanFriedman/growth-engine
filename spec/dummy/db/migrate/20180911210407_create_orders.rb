class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :address_line
      t.string :address_city
      t.string :address_state
      t.string :address_zip
      t.references :customer

      t.timestamps
    end
  end
end
