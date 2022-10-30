class ChangeDatatypeUidOfUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :uid, :string
  end
end
