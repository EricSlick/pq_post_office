class Messages < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'
    create_table :messages do |t|
      t.uuid :uuid, default: 'gen_random_uuid()'
      t.string :status, limit: 15
      t.string :phone, limit: 30
      t.string :body
      t.timestamps
    end
  end
end
