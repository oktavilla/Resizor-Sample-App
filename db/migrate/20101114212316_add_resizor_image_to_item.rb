class AddResizorImageToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :image_resizor_id, :string
    add_column :items, :image_name, :string

    # Uncomment below for meta data columns
    # add_column :items, :image_mime_type, :string
    # add_column :items, :image_size, :integer
    # add_column :items, :image_width, :integer
    # add_column :items, :image_height, :integer
  end

  def self.down
    remove_column :items, :image_resizor_id
    remove_column :items, :image_name
    
    # remove_column :items, :image_mime_type
    # remove_column :items, :image_size
    # remove_column :items, :image_width
    # remove_column :items, :image_height
  end
end
