class CreateThesisDb < ActiveRecord::Migration
  def self.up
    create_table :projects, :force => true do |t|
      t.timestamps
      t.string :name
      t.text :description
    end

    create_table :papers, :force => true do |t|
      t.string :filename
      t.string :original_filename
      t.string :content_type
      t.text :bibtex
      t.integer :relevancy
      t.boolean :read
      t.timestamps
    end

    create_table :papers_projects, :force => true, :id => false do |t|
      t.references :paper
      t.references :project
    end

    create_table :notes, :force => true do |t|
      t.references :notable, :polymorphic => true
      t.text :text
      t.timestamps
    end

    create_table :terms, :force => true do |t|
      t.string :name
      t.timestamps
    end

    create_table :definitions, :force => true do |t|
      t.references :term
      t.string :part
      t.text :text
      t.timestamps
    end

    create_table :papers_terms, :id => false, :force => true do |t|
      t.references :paper
      t.references :term
    end

    change_table :papers_projects do |t|
      t.index([:paper_id, :project_id], :unique => true)
    end

    change_table :papers_terms do |t|
      t.index [:paper_id, :term_id], :unique => true
    end

    change_table :terms do |t|
      t.index :name, :unique => true
    end
  end

  def self.down
    drop_table :projects
    drop_table :papers
    drop_table :papers_projects
    drop_table :notes
    drop_table :terms
    drop_table :definitions
    drop_table :papers_terms
  end
end

