FROM ruby:2.5
LABEL maintainer="University of Alberta Library"

# Autoprefixer doesn’t support Node v4.8.2. Update it.
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

## To install the Yarn package manager (rails assets:precompile complains if not installed), run:
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq \
    && apt-get install -y build-essential \
                          mariadb-client \
                          default-jre \
                          imagemagick \
                          nodejs \
                          yarn \
                          tzdata \
    && rm -rf /var/lib/apt/lists/*


ENV APP_ROOT /app
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

# Preinstall gems in an earlier layer so we don't reinstall every time any file changes.
COPY Gemfile  $APP_ROOT
COPY Gemfile.lock $APP_ROOT
RUN bundle config --local build.sassc --disable-march-tune-native
RUN bundle install --without development test --jobs=3 --retry=3

# *NOW* we copy the codebase in
COPY . $APP_ROOT

# Precompile Rails assets.  We set a dummy database url/token key
RUN RAILS_ENV=uat SECRET_KEY_BASE=pickasecuretoken bundle exec rake assets:precompile

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
