class AddResetTokenAndResetTimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :reset_token, :string
    add_column :users, :reset_time, :datetime
  end
end
