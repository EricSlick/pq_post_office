class CreateStrategiesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :strategies_tables do |t|
      t.string :name, null: false
      t.json :data
      t.timestamps
    end
  end
end
