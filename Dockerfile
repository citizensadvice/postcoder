FROM ruby:3.2.0-alpine3.16 AS builder

ENV APP_HOME /app
ENV LANG C.UTF-8

RUN apk add --update --no-cache build-base git

WORKDIR $APP_HOME
COPY Gemfile* /app/

RUN bundle install && \
    rm -rf /usr/local/bundle/*/*/cache && \
    find /usr/local/bundle -name "*.c" -delete && \
    find /usr/local/bundle -name "*.o" -delete

#################################################

FROM ruby:3.2.0-alpine3.16

ENV APP_ROOT /app
ENV RACK_ENV=production

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

RUN addgroup ruby -g 3000 && adduser -D -h /home/ruby -u 3000 -G ruby ruby

COPY . $APP_ROOT
WORKDIR $APP_ROOT

RUN chown -R ruby /app && chmod -R u-w /app

USER ruby

CMD ["bundle", "exec", "rackup", "-p", "4000"]
