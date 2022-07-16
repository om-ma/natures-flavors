######################
# Stage: Builder
FROM --platform=linux/amd64 ruby:3.0.1 as Builder
RUN apt-get update -qq && apt-get install -y build-essential nodejs libxml2

RUN mkdir -p /app
RUN mkdir -p /app/tmp
WORKDIR /app

# Setting env up
ENV RAILS_ENV='production'
ENV RAKE_ENV='production'

# Install gems
ADD Gemfile* /app/
RUN gem install bundler --version=2.3.1
RUN bundle config --global frozen 1 \
  && bundle install --without development test --retry 3 \
  # Remove unneeded files (cached *.gem, *.o, *.c)
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

ADD . /app

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_KEY
ARG S3_ASSET_REGION
ARG S3_ASSET_BUCKET
ARG SECRET_KEY_BASE

RUN \
  AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  AWS_SECRET_KEY=$AWS_SECRET_KEY \
  S3_ASSET_REGION=$S3_ASSET_REGION \
  S3_ASSET_BUCKET=$S3_ASSET_BUCKET \
  SECRET_KEY_BASE=$SECRET_KEY_BASE \
  bundle exec rake assets:precompile

# Remove files/folders not needed in resulting image
RUN rm -rf .env* .set-build* tmp/cache test public/robots.txt-staging public/robots.txt-staging-temp

###############################
# Stage Final
FROM --platform=linux/amd64 ruby:3.0.1
LABEL maintainer="Duc T. Lam <dlam@naturesflavors.com>"

# Copy app with gems from former build stage
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder --chown=app:app /app /app

WORKDIR /app

# Expose Puma port
EXPOSE 3000

# Save timestamp of image building
RUN date -u > BUILD_TIME

# Start up
CMD ["bundle", "exec", "rails", "server","-p","3000", "-b", "0.0.0.0"]