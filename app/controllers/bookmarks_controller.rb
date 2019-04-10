class BookmarksController < CatalogController
  include Blacklight::Bookmarks

  def action_success_redirect_path
    bookmarks_path
  end

  # monkey patch this method which is throwing `key must be 32 bytes` error after upgrading to Ruby 2.5
  def export_secret_token(salt)
    secret_key_generator.generate_key(salt)[0..(ActiveSupport::MessageEncryptor.key_len - 1)]
  end

  # cribbed from https://github.com/projectblacklight/blacklight/blob/8b9041544553ce0dd0d979f9f39f78d94b30b46d/app/controllers/concerns/blacklight/token_based_user.rb#L46-L76
  def secret_key_generator
    @secret_key_generator ||= begin
      # TODO: this is appropriate for Rails <= 5.1
      # update to Rails.application.credentials.secret_key_base for Rails 5.2+
      ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base)
    end
  end
end
