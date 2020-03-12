require 'generator_spec/test_case'
require 'generators/symphony_nightly/symphony_nightly_generator'

describe SymphonyNightlyGenerator, type: :generator do
  destination Rails.root.join('tmp', 'db', 'migrate')

  before(:all) do
    travel_to Time.new(2020, 2, 2) # so that we can predict the file name
    prepare_destination
    run_generator
  end

  after(:all) do
    travel_back
  end

  it 'creates a database migration' do
    assert_migration 'db/migrate/update_symphony_nightly_20200202.rb' do |migration|
      assert_class_method :up, migration do |up|
        assert_match(/rename_table/, up)
        assert_match(/foreign_keys/, up)

        assert_match(/create_table_statues/, up)
        assert_match(/create_table_item_types/, up)
        assert_match(/create_table_circulation_rules/, up)
        assert_match(/create_table_libraries/, up)
        assert_match(/create_table_locations/, up)

        assert_match(/CirculationRule/, up)
        assert_match(/ItemType/, up)
        assert_match(/Location/, up)
        assert_match(/Status/, up)
        assert_match(/Library/, up)
        assert_match(/entry.proxy/, up)
      end

      assert_class_method :down, migration do |down|
        assert_match(/rename_table/, down)
        assert_match(/foreign_keys/, down)
        assert_match(/create_table/, down)
      end

      assert_method :create_table_statues, migration do |create_table|
        assert_match(/create_table/, create_table)
      end
      assert_method :create_table_item_types, migration do |create_table|
        assert_match(/create_table/, create_table)
      end
      assert_method :create_table_circulation_rules, migration do |create_table|
        assert_match(/create_table/, create_table)
      end
      assert_method :create_table_libraries, migration do |create_table|
        assert_match(/create_table/, create_table)
      end
      assert_method :create_table_locations, migration do |create_table|
        assert_match(/create_table/, create_table)
        assert_match(/add_index/, create_table)
      end
    end
  end

  it 'creates one migration per day' do
    expect(run_generator).to match(/conflict/)
    travel_to 1.day.from_now
    expect(run_generator).to match(/create/)
    travel_back
  end
end
