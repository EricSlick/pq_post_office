class CreateThirdParty < ActiveRecord::Migration[7.0]
  def change
    create_table :third_parties do |t|
      t.string :api
      t.string :name
      t.string :health
      t.boolean :active

      t.timestamps
    end
  end
end
