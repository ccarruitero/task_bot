class AddProviderAndPojectNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :project_name, :string
  end
end
