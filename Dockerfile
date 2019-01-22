FROM ruby:2.5
ENV RAILS_ROOT /src

# Install dependencies
RUN apt-get update -qq \
  && apt-get install -y  \
    build-essential nodejs postgresql-client libpq-dev \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /var/lib/apt var/lib/dpkg var/lib/cache var/lib/log

# Set working directory
RUN mkdir $RAILS_ROOT
WORKDIR $RAILS_ROOT

# Add gems
COPY Gemfile* $RAILS_ROOT/
RUN bundle install

# Copy project files
COPY . $RAILS_ROOT/

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
