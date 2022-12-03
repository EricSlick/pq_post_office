class AddSentAtFieldsToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :sent_at, :datetime
    add_column :messages, :delivered_at, :datetime
  end
end
