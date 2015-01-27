class AddTrelloSecretToUser < ActiveRecord::Migration
  def change
    add_column :users, :trello_secret, :string
  end
end
