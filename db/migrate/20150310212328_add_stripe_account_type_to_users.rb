class AddStripeAccountTypeToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :stripe_account_type, :string
  end
end
