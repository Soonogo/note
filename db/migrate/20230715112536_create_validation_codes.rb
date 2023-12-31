class CreateValidationCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :validation_codes do |t|
      t.string :email
      t.integer :kind,default: 0, null: false
      t.string :code
      t.datetime :used_at

      t.timestamps
    end
  end
end
