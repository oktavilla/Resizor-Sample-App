class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :name
      t.string :resizor_id
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
