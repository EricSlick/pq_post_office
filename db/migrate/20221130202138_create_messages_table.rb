class CreateMessagesTable < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'
    create_table :messages do |t|
      t.uuid :uuid, default: 'gen_random_uuid()', null: false, index: {unique: true}
      t.string :status, limit: 15, index: {}
      t.string :phone, limit: 30, index: {}
      t.string :body
      t.string :adapter
      t.string :remote_id
      t.datetime :sent_at
      t.datetime :delivered_at
      t.string :status_info
      t.timestamps
    end
  end
end
