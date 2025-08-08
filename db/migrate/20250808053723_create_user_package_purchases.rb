class CreateUserPackagePurchases < ActiveRecord::Migration[8.0]
  def change
    create_table :user_package_purchases do |t|
      t.references :user, null: false, foreign_key: true
      t.references :package, null: false, foreign_key: true
      t.datetime :purchased_at
      t.datetime :expires_at
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
