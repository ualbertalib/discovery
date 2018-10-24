# Set up the app-wide +LIBRARY_LOCATIONS+ hash from <tt>config/locations.yml</tt>
library_locations = YAML.load_file("#{Rails.root}/config/locations.yml")
SYMPHONY_LIBRARY_LOCATIONS = library_locations.deep_symbolize_keys.freeze

statuses = YAML.load_file("#{Rails.root}/config/statuses.yml")
SYMPHONY_STATUSES = statuses.deep_symbolize_keys.freeze

item_types = YAML.load_file("#{Rails.root}/config/item_types.yml")
SYMPHONY_ITEM_TYPES = item_types.deep_symbolize_keys.freeze

circ_rules = YAML.load_file("#{Rails.root}/config/circ_rules.yml")
SYMPHONY_CIRC_RULES = circ_rules.deep_symbolize_keys.freeze
