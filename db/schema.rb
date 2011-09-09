# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "definitions", :force => true do |t|
    t.integer  "term_id"
    t.string   "part"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.integer  "notable_id"
    t.string   "notable_type"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "papers", :force => true do |t|
    t.string   "filename"
    t.string   "original_filename"
    t.string   "content_type"
    t.text     "bibtex"
    t.integer  "relevancy"
    t.boolean  "read"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "papers_projects", :id => false, :force => true do |t|
    t.integer "paper_id"
    t.integer "project_id"
  end

  add_index "papers_projects", ["paper_id", "project_id"], :name => "index_papers_projects_on_paper_id_and_project_id", :unique => true

  create_table "papers_terms", :id => false, :force => true do |t|
    t.integer "paper_id"
    t.integer "term_id"
  end

  add_index "papers_terms", ["paper_id", "term_id"], :name => "index_papers_terms_on_paper_id_and_term_id", :unique => true

  create_table "projects", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "description"
  end

  create_table "terms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "terms", ["name"], :name => "index_terms_on_name", :unique => true

end
