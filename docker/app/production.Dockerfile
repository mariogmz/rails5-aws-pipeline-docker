FROM ruby:2.6
ENV RAILS_ROOT /var/www/current
ENV PORT 3000

# Install dependencies
RUN apt-get update -qq \
  && apt-get install -y  \
    build-essential nodejs postgresql-client libpq-dev \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /var/lib/apt var/lib/dpkg var/lib/cache var/lib/log

# Set working directory
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

# Add gems
COPY Gemfile* $RAILS_ROOT/
RUN bundle install --jobs 20 --retry 5 --without development test

# Copy project files
COPY . $RAILS_ROOT/

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE $PORT
CMD ["bash", "-c", "bundle exec rails server -e production -p $PORT"]
