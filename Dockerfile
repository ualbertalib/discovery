FROM ruby:2.5.0
LABEL maintainer="University of Alberta Libraries"

# Autoprefixer doesn’t support Node v4.8.2. Update it.
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update -qq \
    && apt-get install -y build-essential \
                          mysql-client \
                          default-jre \
                          imagemagick \
                          nodejs \
                          tzdata \
    && rm -rf /var/lib/apt/lists/*


ENV APP_ROOT /app
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

# Preinstall gems in an earlier layer so we don't reinstall every time any file changes.
COPY Gemfile  $APP_ROOT
COPY Gemfile.lock $APP_ROOT
RUN bundle install --without development test --jobs=3 --retry=3

# *NOW* we copy the codebase in
COPY . $APP_ROOT

# Precompile Rails assets.  We set a dummy database url/token key
RUN RAILS_ENV=uat SECRET_KEY_BASE=pickasecuretoken bundle exec rake assets:precompile

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
