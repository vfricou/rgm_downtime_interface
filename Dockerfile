FROM ruby:2.7.2-alpine as builder
WORKDIR /app

ENV \
  RAILS_ENV=production \
  RACK_ENV=production \
  NODE_ENV=production \
  SECRET_KEY_BASE=azerty1234

RUN \
  apk add --no-cache build-base linux-headers zlib-dev tzdata \
                     nodejs npm yarn sqlite-dev sqlite-libs

COPY app /app/app
COPY bin /app/bin
COPY config /app/config
COPY lib /app/lib
COPY public/assets /app/public/assets
COPY public/404.html /app/public/404.html
COPY public/422.html /app/public/422.html
COPY public/500.html /app/public/500.html
COPY public/apple-touch-icon.png /app/public/apple-touch-icon.png
COPY public/apple-touch-icon-precomposed.png /app/public/apple-touch-icon-precomposed.png
COPY public/robots.txt /app/public/robots.txt
COPY babel.config.js /app/babel.config.js
COPY config.ru /app/config.ru
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY package.json /app/package.json
COPY postcss.config.js /app/postcss.config.js
COPY Rakefile /app/Rakefile
COPY yarn.lock /app/yarn.lock

RUN \
  mkdir /app/log && \
  bundle config set without 'development test' && \
  bundle install --jobs $(nproc) --retry 5 &&\
  bin/rake assets:precompile

FROM ruby:2.7.2-alpine
LABEL maintainer="Vincent FRICOU <vincent@fricouv.eu>"

WORKDIR /app

ENV \
  RAILS_ENV=production \
  RACK_ENV=production \
  NODE_ENV=production \
  RAILS_SERVE_STATIC_FILES=true \
  RAILS_LOG_TO_STDOUT=true

RUN \
  apk add --no-cache ca-certificates tzdata xz-libs nodejs sqlite-dev&&\
  rm -rf /var/cache/apk/* && \
  mkdir -p /app

COPY --from=builder /usr/local/bin/gem /usr/local/bin/gem
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app/ /app/
#COPY docker/entrypoint.sh /entrypoint.sh

EXPOSE 3000

#ENTRYPOINT ["/entrypoint.sh"]
CMD ["rails","server", "-b", "0.0.0.0"]
