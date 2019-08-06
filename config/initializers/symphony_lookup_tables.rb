# Set up the app-wide +LIBRARY_LOCATIONS+ hash from <tt>config/locations.yml</tt>
library_locations = YAML.load_file("#{Rails.root}/db/seeds/location.yml")
SYMPHONY_LIBRARY_LOCATIONS = library_locations.deep_symbolize_keys.freeze

item_types = YAML.load_file("#{Rails.root}/db/seeds/item_type.yml")
SYMPHONY_ITEM_TYPES = item_types.deep_symbolize_keys.freeze

circ_rules = YAML.load_file("#{Rails.root}/db/seeds/circulation_rule.yml")
SYMPHONY_CIRC_RULES = circ_rules.deep_symbolize_keys.freeze
