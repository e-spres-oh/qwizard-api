class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password, length: { minimum: 6 }
      t.integer :hat

      t.timestamps

      t.index :username, unique: true
    end
  end
end
