######################
# Stage: Builder
FROM ruby:2.6.1-alpine3.9 as Builder
ENV RAILS_ROOT /var/www/current

# Install tools
RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    git \
    tzdata

# Set working directory
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

# Install gems
COPY Gemfile* $RAILS_ROOT/
RUN bundle config --global frozen 1 \
  && bundle install --without development test -j4 --retry 3 \
  # Remove unneeded files (cached *.gem, *.o, *.c)
   && rm -rf /usr/local/bundle/cache/*.gem \
   && find /usr/local/bundle/gems/ -name "*.c" -delete \
   && find /usr/local/bundle/gems/ -name "*.o" -delete

# Copy project files
COPY . $RAILS_ROOT/

# Remove folders not needed in resulting image
RUN rm -rf tmp/cache spec

###############################
# Stage Final
FROM ruby:2.6.1-alpine3.9
LABEL maintainer="mariogomezmtz@gmail.com"

ENV RAILS_ROOT /var/www/current
ENV PORT 3000

RUN apk add --update --no-cache \
    postgresql-client \
    tzdata \
    file

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

# Copy app with gems from former build stage
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder $RAILS_ROOT $RAILS_ROOT

# Add a script to be executed every time the container starts.
COPY --from=Builder $RAILS_ROOT/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Set Rails env
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES false
ENV EXECJS_RUNTIME Disabled

EXPOSE $PORT
CMD ["/bin/sh", "-c", "bundle exec rails server -e production -p $PORT"]
