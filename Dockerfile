FROM ruby:3.1.1-slim

RUN apt-get update -qq && apt-get install -y \
  git \
  apt-transport-https \
  build-essential \
  libpq-dev \
  curl \
  imagemagick

# for a JS runtime
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# for yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5 --without development test sqlite

# Set Rails to run in production
ENV RAILS_ENV production
ENV RACK_ENV production
ENV RAILS_SERVE_STATIC_FILES true

# Copy the main application.
COPY . ./

# Precompile Rails assets
# ARG CACHEBUST=1
RUN SECRET_KEY_BASE=fake \
  DATABASE_URL=postgres://fake@fake:5432/fake \
  bundle exec rake assets:precompile

# Set expose port
# EXPOSE 3000

# Setup entrypoint
# ENTRYPOINT ["./docker/production/entrypoint.sh"]

# Start puma
CMD bundle exec rails s -b 0.0.0.0 -p $PORT
