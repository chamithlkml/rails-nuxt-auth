ARG RUBY_VERSION=3.2.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim

RUN mkdir -p /app
WORKDIR /app

# Install base packages
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential git libpq-dev node-gyp pkg-config python-is-python3 && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install JavaScript dependencies
ARG NODE_VERSION=22.14.0
ARG YARN_VERSION=1.22.22
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
  /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
  npm install -g yarn@$YARN_VERSION && \
  rm -rf /tmp/node-build-master

RUN mkdir -p /app/backend

# # Install application gems
COPY ./backend/Gemfile ./backend/Gemfile.lock /app/backend/
RUN cd /app/backend && bundle install && \
  rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
  bundle exec bootsnap precompile --gemfile

RUN mkdir -p /app/frontend

# Install node modules
COPY ./frontend/package.json ./frontend/package-lock.json /app/frontend/
RUN cd /app/frontend && npm install

# Copy application code
COPY . .

# Run and own only the runtime files as a non-root user for security
# RUN groupadd --system --gid 1000 rails && \
#   useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
#   chown -R rails:rails db log storage tmp
# USER 1000:1000


# Entrypoint prepares the database.
ENTRYPOINT ["/app/backend/bin/docker-entrypoint"]

EXPOSE 80 3010 3000
# CMD ["./bin/dev"]
CMD ["tail", "-f", "/dev/null"]
