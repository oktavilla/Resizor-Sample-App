class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items, :force => true do |t|
      t.string :name
    end 
  end

  def self.down
    drop_table :items
  end
end
