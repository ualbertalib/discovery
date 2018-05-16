
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

ActiveRecord::Schema.define(version: 20_151_029_171_613) do
  create_table 'bookmarks', force: :cascade do |t|
    t.integer  'user_id', null: false
    t.string   'user_type'
    t.string   'document_id'
    t.string   'title'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string   'document_type'
  end

  add_index 'bookmarks', ['user_id'], name: 'index_bookmarks_on_user_id'

  create_table 'comfy_cms_blocks', force: :cascade do |t|
    t.string   'identifier', null: false
    t.text     'content', limit: 16_777_215
    t.integer  'blockable_id'
    t.string   'blockable_type'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'comfy_cms_blocks', %w[blockable_id blockable_type], name: 'index_comfy_cms_blocks_on_blockable_id_and_blockable_type'
  add_index 'comfy_cms_blocks', ['identifier'], name: 'index_comfy_cms_blocks_on_identifier'

  create_table 'comfy_cms_categories', force: :cascade do |t|
    t.integer 'site_id',          null: false
    t.string  'label',            null: false
    t.string  'categorized_type', null: false
  end

  add_index 'comfy_cms_categories', %w[site_id categorized_type label], name: 'index_cms_categories_on_site_id_and_cat_type_and_label', unique: true

  create_table 'comfy_cms_categorizations', force: :cascade do |t|
    t.integer 'category_id',      null: false
    t.string  'categorized_type', null: false
    t.integer 'categorized_id',   null: false
  end

  add_index 'comfy_cms_categorizations', %w[category_id categorized_type categorized_id], name: 'index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id', unique: true

  create_table 'comfy_cms_files', force: :cascade do |t|
    t.integer  'site_id', null: false
    t.integer  'block_id'
    t.string   'label',                                      null: false
    t.string   'file_file_name',                             null: false
    t.string   'file_content_type',                          null: false
    t.integer  'file_file_size',                             null: false
    t.string   'description', limit: 2048
    t.integer  'position', default: 0, null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'comfy_cms_files', %w[site_id block_id], name: 'index_comfy_cms_files_on_site_id_and_block_id'
  add_index 'comfy_cms_files', %w[site_id file_file_name], name: 'index_comfy_cms_files_on_site_id_and_file_file_name'
  add_index 'comfy_cms_files', %w[site_id label], name: 'index_comfy_cms_files_on_site_id_and_label'
  add_index 'comfy_cms_files', %w[site_id position], name: 'index_comfy_cms_files_on_site_id_and_position'

  create_table 'comfy_cms_layouts', force: :cascade do |t|
    t.integer  'site_id', null: false
    t.integer  'parent_id'
    t.string   'app_layout'
    t.string   'label',                                       null: false
    t.string   'identifier',                                  null: false
    t.text     'content',    limit: 16_777_215
    t.text     'css',        limit: 16_777_215
    t.text     'js',         limit: 16_777_215
    t.integer  'position',                    default: 0,     null: false
    t.boolean  'is_shared',                   default: false, null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'comfy_cms_layouts', %w[parent_id position], name: 'index_comfy_cms_layouts_on_parent_id_and_position'
  add_index 'comfy_cms_layouts', %w[site_id identifier], name: 'index_comfy_cms_layouts_on_site_id_and_identifier', unique: true

  create_table 'comfy_cms_pages', force: :cascade do |t|
    t.integer  'site_id', null: false
    t.integer  'layout_id'
    t.integer  'parent_id'
    t.integer  'target_page_id'
    t.string   'label', null: false
    t.string   'slug'
    t.string   'full_path', null: false
    t.text     'content_cache', limit: 16_777_215
    t.integer  'position',                        default: 0,     null: false
    t.integer  'children_count',                  default: 0,     null: false
    t.boolean  'is_published',                    default: true,  null: false
    t.boolean  'is_shared',                       default: false, null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'comfy_cms_pages', %w[parent_id position], name: 'index_comfy_cms_pages_on_parent_id_and_position'
  add_index 'comfy_cms_pages', %w[site_id full_path], name: 'index_comfy_cms_pages_on_site_id_and_full_path'

  create_table 'comfy_cms_revisions', force: :cascade do |t|
    t.string   'record_type',                  null: false
    t.integer  'record_id',                    null: false
    t.text     'data', limit: 16_777_215
    t.datetime 'created_at'
  end

  add_index 'comfy_cms_revisions', %w[record_type record_id created_at], name: 'index_cms_revisions_on_rtype_and_rid_and_created_at'

  create_table 'comfy_cms_sites', force: :cascade do |t|
    t.string  'label',                       null: false
    t.string  'identifier',                  null: false
    t.string  'hostname',                    null: false
    t.string  'path'
    t.string  'locale',      default: 'en',  null: false
    t.boolean 'is_mirrored', default: false, null: false
  end

  add_index 'comfy_cms_sites', ['hostname'], name: 'index_comfy_cms_sites_on_hostname'
  add_index 'comfy_cms_sites', ['is_mirrored'], name: 'index_comfy_cms_sites_on_is_mirrored'

  create_table 'comfy_cms_snippets', force: :cascade do |t|
    t.integer  'site_id',                                     null: false
    t.string   'label',                                       null: false
    t.string   'identifier',                                  null: false
    t.text     'content', limit: 16_777_215
    t.integer  'position',                    default: 0,     null: false
    t.boolean  'is_shared',                   default: false, null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'comfy_cms_snippets', %w[site_id identifier], name: 'index_comfy_cms_snippets_on_site_id_and_identifier', unique: true
  add_index 'comfy_cms_snippets', %w[site_id position], name: 'index_comfy_cms_snippets_on_site_id_and_position'

  create_table 'profiles', force: :cascade do |t|
    t.string   'first_name'
    t.string   'last_name'
    t.string   'job_title'
    t.string   'unit'
    t.string   'email'
    t.string   'phone'
    t.string   'campus_address'
    t.string   'expertise'
    t.text     'introduction'
    t.text     'publications'
    t.integer  'staff_since'
    t.string   'links'
    t.string   'orcid'
    t.string   'committees'
    t.text     'personal_interests'
    t.boolean  'opt_in'
    t.datetime 'created_at',         null: false
    t.datetime 'updated_at',         null: false
    t.string   'slug'
    t.string   'liason'
  end

  add_index 'profiles', ['slug'], name: 'index_profiles_on_slug'

  create_table 'searches', force: :cascade do |t|
    t.text     'query_params'
    t.integer  'user_id'
    t.string   'user_type'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'searches', ['user_id'], name: 'index_searches_on_user_id'

  create_table 'sessions', force: :cascade do |t|
    t.string   'session_id', null: false
    t.text     'data', limit: 4_294_967_295
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'sessions', ['session_id'], name: 'index_sessions_on_session_id', unique: true
  add_index 'sessions', ['updated_at'], name: 'index_sessions_on_updated_at'

  create_table 'users', force: :cascade do |t|
    t.string   'email',                  default: '', null: false
    t.string   'encrypted_password',     default: '', null: false
    t.string   'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer  'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string   'current_sign_in_ip'
    t.string   'last_sign_in_ip'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'users', ['email'], name: 'index_users_on_email', unique: true
  add_index 'users', ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
end
