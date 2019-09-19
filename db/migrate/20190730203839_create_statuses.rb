class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :short_code
      t.string :name

      t.timestamps null: false
    end

    # Status
    seed_file = Rails.root.join('db', 'migrate/201907', "#{Status.name.underscore}.yml")
    config = YAML.load_file(seed_file)
    config.each { |k, v| Status.where(short_code: k, name: v).first_or_create }
  end
end
