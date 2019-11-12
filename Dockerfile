FROM ruby:2.6.5-alpine

ENV LANG C.UTF-8
ENV TZ=Asia/Tokyo

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME/
COPY Gemfile.lock $APP_HOME/

COPY package.json $APP_HOME/
COPY yarn.lock $APP_HOME/

RUN apk update \
  && apk add --update --no-cache --virtual=.build-dependencies \
    linux-headers \
    libxml2-dev \
    libxslt-dev \
    zlib-dev \
    ffmpeg \
  && apk add --update --no-cache \
    git \
    openssh \
    tzdata \
    nodejs \
    yarn \
    imagemagick \
    libc6-compat \
    xz-libs \
    postgresql-dev \
    build-base \
  && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && apk del .build-dependencies

WORKDIR $APP_HOME
ADD . $APP_HOME
