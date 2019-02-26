FROM phusion/passenger-ruby21:0.9.34
LABEL maintainer="University of Alberta Libraries"

ENV HOME /root
CMD ["/sbin/my_init"]

RUN bash -lc 'rvm install ruby-2.1.5'
RUN bash -lc 'rvm --default use ruby-2.1.5'
RUN bash -lc 'gem install bundler -v 1.17.3'

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

# setup nginx/passenger
RUN rm -f /etc/nginx/sites-enabled/default
COPY config/nginx.conf /etc/nginx/sites-enabled/discovery.conf
COPY config/rails-env.conf /etc/nginx/main.d/rails-env.conf
RUN rm -f /etc/service/nginx/down

# Preinstall gems in an earlier layer so we don't reinstall every time any file changes.
COPY Gemfile  $APP_ROOT
COPY Gemfile.lock $APP_ROOT
RUN bundle install --without development test --jobs=3 --retry=3

# *NOW* we copy the codebase in
COPY . $APP_ROOT
# Precompile Rails assets.
RUN RAILS_ENV=uat SECRET_KEY_BASE=pickasecuretoken bundle exec rake assets:precompile
# change the owner so that the app passenger_user can read and write to the app dir
RUN chown -R app:app .

EXPOSE 80
