FROM ruby:3.4.7-alpine3.22 AS base

ENV APP_HOME=/app
ENV LANG=C.UTF-8

#################################################

FROM base AS builder

RUN apk add --update --no-cache build-base git yaml-dev

WORKDIR $APP_HOME
COPY Gemfile* /app/

RUN bundle install && \
    rm -rf /usr/local/bundle/*/*/cache && \
    find /usr/local/bundle -name "*.c" -delete && \
    find /usr/local/bundle -name "*.o" -delete

#################################################

FROM base

ENV RACK_ENV=production
ENV RUBY_YJIT_ENABLE=1

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

RUN addgroup ruby -g 3000 && adduser -D -h /home/ruby -u 3000 -G ruby ruby

COPY . $APP_HOME
WORKDIR $APP_HOME

RUN chown -R ruby /app && chmod -R u-w /app

USER ruby

CMD ["bundle", "exec", "rackup", "-p", "4000"]
