class Messages < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'
    create_table :messages do |t|
      t.uuid :uuid, default: 'gen_random_uuid()', null: false, index: {unique: true}
      t.string :status, limit: 15, index: {}
      t.string :phone, limit: 30, index: {}
      t.string :body
      t.timestamps
    end
  end
end
