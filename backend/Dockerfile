ARG RUBY_VERSION=3.5.0
FROM ruby:$RUBY_VERSION-preview1-slim

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
