class AddRecoveryTokenToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :recovery_token, :string
  end
end
