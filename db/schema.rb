# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151029171613) do

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",       limit: 4,   null: false
    t.string   "user_type",     limit: 255
    t.string   "document_id",   limit: 255
    t.string   "title",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_type", limit: 255
  end

  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id", using: :btree

  create_table "comfy_cms_blocks", force: :cascade do |t|
    t.string   "identifier",     limit: 255,      null: false
    t.text     "content",        limit: 16777215
    t.integer  "blockable_id",   limit: 4
    t.string   "blockable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_blocks", ["blockable_id", "blockable_type"], name: "index_comfy_cms_blocks_on_blockable_id_and_blockable_type", using: :btree
  add_index "comfy_cms_blocks", ["identifier"], name: "index_comfy_cms_blocks_on_identifier", using: :btree

  create_table "comfy_cms_categories", force: :cascade do |t|
    t.integer "site_id",          limit: 4,   null: false
    t.string  "label",            limit: 255, null: false
    t.string  "categorized_type", limit: 255, null: false
  end

  add_index "comfy_cms_categories", ["site_id", "categorized_type", "label"], name: "index_cms_categories_on_site_id_and_cat_type_and_label", unique: true, using: :btree

  create_table "comfy_cms_categorizations", force: :cascade do |t|
    t.integer "category_id",      limit: 4,   null: false
    t.string  "categorized_type", limit: 255, null: false
    t.integer "categorized_id",   limit: 4,   null: false
  end

  add_index "comfy_cms_categorizations", ["category_id", "categorized_type", "categorized_id"], name: "index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id", unique: true, using: :btree

  create_table "comfy_cms_files", force: :cascade do |t|
    t.integer  "site_id",           limit: 4,                null: false
    t.integer  "block_id",          limit: 4
    t.string   "label",             limit: 255,              null: false
    t.string   "file_file_name",    limit: 255,              null: false
    t.string   "file_content_type", limit: 255,              null: false
    t.integer  "file_file_size",    limit: 4,                null: false
    t.string   "description",       limit: 2048
    t.integer  "position",          limit: 4,    default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_files", ["site_id", "block_id"], name: "index_comfy_cms_files_on_site_id_and_block_id", using: :btree
  add_index "comfy_cms_files", ["site_id", "file_file_name"], name: "index_comfy_cms_files_on_site_id_and_file_file_name", using: :btree
  add_index "comfy_cms_files", ["site_id", "label"], name: "index_comfy_cms_files_on_site_id_and_label", using: :btree
  add_index "comfy_cms_files", ["site_id", "position"], name: "index_comfy_cms_files_on_site_id_and_position", using: :btree

  create_table "comfy_cms_layouts", force: :cascade do |t|
    t.integer  "site_id",    limit: 4,                        null: false
    t.integer  "parent_id",  limit: 4
    t.string   "app_layout", limit: 255
    t.string   "label",      limit: 255,                      null: false
    t.string   "identifier", limit: 255,                      null: false
    t.text     "content",    limit: 16777215
    t.text     "css",        limit: 16777215
    t.text     "js",         limit: 16777215
    t.integer  "position",   limit: 4,        default: 0,     null: false
    t.boolean  "is_shared",                   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_layouts", ["parent_id", "position"], name: "index_comfy_cms_layouts_on_parent_id_and_position", using: :btree
  add_index "comfy_cms_layouts", ["site_id", "identifier"], name: "index_comfy_cms_layouts_on_site_id_and_identifier", unique: true, using: :btree

  create_table "comfy_cms_pages", force: :cascade do |t|
    t.integer  "site_id",        limit: 4,                        null: false
    t.integer  "layout_id",      limit: 4
    t.integer  "parent_id",      limit: 4
    t.integer  "target_page_id", limit: 4
    t.string   "label",          limit: 255,                      null: false
    t.string   "slug",           limit: 255
    t.string   "full_path",      limit: 255,                      null: false
    t.text     "content_cache",  limit: 16777215
    t.integer  "position",       limit: 4,        default: 0,     null: false
    t.integer  "children_count", limit: 4,        default: 0,     null: false
    t.boolean  "is_published",                    default: true,  null: false
    t.boolean  "is_shared",                       default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_pages", ["parent_id", "position"], name: "index_comfy_cms_pages_on_parent_id_and_position", using: :btree
  add_index "comfy_cms_pages", ["site_id", "full_path"], name: "index_comfy_cms_pages_on_site_id_and_full_path", using: :btree

  create_table "comfy_cms_revisions", force: :cascade do |t|
    t.string   "record_type", limit: 255,      null: false
    t.integer  "record_id",   limit: 4,        null: false
    t.text     "data",        limit: 16777215
    t.datetime "created_at"
  end

  add_index "comfy_cms_revisions", ["record_type", "record_id", "created_at"], name: "index_cms_revisions_on_rtype_and_rid_and_created_at", using: :btree

  create_table "comfy_cms_sites", force: :cascade do |t|
    t.string  "label",       limit: 255,                 null: false
    t.string  "identifier",  limit: 255,                 null: false
    t.string  "hostname",    limit: 255,                 null: false
    t.string  "path",        limit: 255
    t.string  "locale",      limit: 255, default: "en",  null: false
    t.boolean "is_mirrored",             default: false, null: false
  end

  add_index "comfy_cms_sites", ["hostname"], name: "index_comfy_cms_sites_on_hostname", using: :btree
  add_index "comfy_cms_sites", ["is_mirrored"], name: "index_comfy_cms_sites_on_is_mirrored", using: :btree

  create_table "comfy_cms_snippets", force: :cascade do |t|
    t.integer  "site_id",    limit: 4,                        null: false
    t.string   "label",      limit: 255,                      null: false
    t.string   "identifier", limit: 255,                      null: false
    t.text     "content",    limit: 16777215
    t.integer  "position",   limit: 4,        default: 0,     null: false
    t.boolean  "is_shared",                   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_snippets", ["site_id", "identifier"], name: "index_comfy_cms_snippets_on_site_id_and_identifier", unique: true, using: :btree
  add_index "comfy_cms_snippets", ["site_id", "position"], name: "index_comfy_cms_snippets_on_site_id_and_position", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "first_name",         limit: 255
    t.string   "last_name",          limit: 255
    t.string   "job_title",          limit: 255
    t.string   "unit",               limit: 255
    t.string   "email",              limit: 255
    t.string   "phone",              limit: 255
    t.string   "campus_address",     limit: 255
    t.string   "expertise",          limit: 255
    t.text     "introduction",       limit: 65535
    t.text     "publications",       limit: 65535
    t.integer  "staff_since",        limit: 4
    t.string   "links",              limit: 255
    t.string   "orcid",              limit: 255
    t.string   "committees",         limit: 255
    t.text     "personal_interests", limit: 65535
    t.boolean  "opt_in"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "slug",               limit: 255
    t.string   "liason",             limit: 255
  end

  add_index "profiles", ["slug"], name: "index_profiles_on_slug", using: :btree

  create_table "searches", force: :cascade do |t|
    t.text     "query_params", limit: 65535
    t.integer  "user_id",      limit: 4
    t.string   "user_type",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,        null: false
    t.text     "data",       limit: 4294967295
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
