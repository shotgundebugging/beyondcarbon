class CreateEmploymentData < ActiveRecord::Migration[8.0]
  def change
    create_table :employment_data do |t|
      t.references :region, null: false, foreign_key: true
      t.string :sector, null: false
      t.string :stressor, null: false
      t.float :value, null: false

      t.timestamps
    end

    add_index :employment_data, [:region_id, :stressor]
  end
end

