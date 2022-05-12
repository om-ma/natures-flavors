FROM ruby:3.0.1


RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libxml2
# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /app
RUN mkdir -p $RAILS_ROOT
RUN mkdir -p $RAILS_ROOT/tmp
# Set working directory
WORKDIR $RAILS_ROOT
# Setting env up
ENV RAILS_ENV='production'
ENV RAKE_ENV='production' 
# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
# Adding project files
COPY . .
RUN rm ./log/*.log
RUN rm -r ./tmp/*
RUN gem install bundler --version=2.3.1
RUN bundle install --binstubs --jobs 20 --retry 5 --without development test 
RUN bundle exec rake assets:precompile
EXPOSE 3000

#COPY docker-entrypoint.sh /
#ENTRYPOINT ["sh","/docker-entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server","-p","3000", "-b", "0.0.0.0"]
