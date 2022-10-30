class AddUidToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :uid, :integer,  null:false
  end
end
