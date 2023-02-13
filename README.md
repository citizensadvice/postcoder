# postcoder

Find addresses using the [Allies postcoder service](https://postcoder.com/docs/address-lookup/address)

This service caches the results to save on credits

This service can also operate in a mock mode where no external calls are made.

## API

GET `http://example.com/addresses/{searchterm}`

This will pass the search term to GET `https://ws.postcoder.com/pcw/{apikey}/address/uk/{searchterm}`

The query options `format`, `line`, `page`, `include`, `exclude`, `callback`, `alias` and `addtags` will also be passed.

If the query option `refresh=true` is provided the cache will be skipped and updated, _for that request_.

## Build

```
docker build -t citizensadvice/postcoder .
```

## Start

Optionally create a .env file with the real `API_KEY`.

```
docker-compose up
```

```
docker run
  -p 4001:4000
  --env APP_ENV=production
  --env API_KEY=PCW45-12345-12345-1234X
  --env CACHE_URL=redis://cache:6379/1
  --env CACHE_TTL=86_400
citizensadvice/postcoder
```

http://localhost:4001/addresses/E1

### Testing

```
bundle exec rubocop
bundle exec rspec

# Or using docker
docker-compose run --rm -e APP_ENV=test app bundle exec rspec
```

## API key

We have one API key used on production and the devops environment.

The Allied test API key of PCW45-12345-12345-1234X always returns the same response.

### Mock mode

Start in mock mode by supplying the ENV MOCK_MODE=true.  This reads responses from the file system and
will not enabled Redis.

Note that mock mode does not support the query options and always returns JSON.

```
MOCK_MODE=true docker-compose up
```

If running mock mode you probably want to set `NEW_RELIC_AGENT_ENABLED=false` and `WEB_CONCURRENCY=0`. 

### Configuration

| Key name                | Description                                                                              |
| ---                     | ---                                                                                      |
| APP_ENV                 | The app environment. This should be set to production on all AWS environments            |
| API_KEY                 | The API key for the Postcoder web service                                                |
| CACHE_URL               | The url for the Redis cache                                                              |
| CACHE_TTL               | How long to cache a new entry (in seconds).  This is `2_592_000` (30 days) in production |
| NEW_RELIC_LICENSE_KEY   | If provided, New Relic will be enabled                                                   |
| MOCK_MODE               | If `true`, operate in mock mode where responses are read from the file system            |
| WEB_CONCURRENCY         | Set to `0` if running locally for a tiny performance boost                               |
