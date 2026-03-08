ARG RUBY_VERSION=4.0.1
FROM ruby:$RUBY_VERSION-slim

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y  \
    build-essential \
    git \
    libvips \
    libpq-dev \
    libyaml-dev \
    pkg-config \
    curl \
    libjemalloc2 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
