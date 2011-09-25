class CreateDocument < ActiveRecord::Migration
  def self.up
    create_table :documents, :force => true do |t|
      t.timestamps
      t.references :project
      t.string :name
      t.text :content
    end

    change_table :documents do |t|
      t.index :name, :unique => true
    end
  end

  def self.down
    drop_table :documents
  end
end

