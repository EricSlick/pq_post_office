class AddAdapterToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :adapter, :string
  end
end
