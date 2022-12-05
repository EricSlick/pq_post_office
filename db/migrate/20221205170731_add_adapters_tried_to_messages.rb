class AddAdaptersTriedToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :adapters_tried, :json
  end
end
