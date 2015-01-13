class AddBannedColumnToUser < ActiveRecord::Migration
  def change
  	add_column :users, :banned, :boolean, null: false, default: false
  	add_column :users, :banned_date, :datetime, null: true
  	add_reference :users, :banned_by, index: true, null: true, default: :null
  end
end
