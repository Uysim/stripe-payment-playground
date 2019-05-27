class AddManagedAccountStatusToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :stripe_account_status, :text, default: '{}'
  end
end
