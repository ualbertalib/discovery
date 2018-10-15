# Set up the app-wide +LIBRARY_LOCATIONS+ hash from <tt>config/locations.yml</tt>
library_locations = YAML.load_file("#{Rails.root}/config/locations.yml")
LIBRARY_LOCATIONS = library_locations.deep_symbolize_keys.freeze