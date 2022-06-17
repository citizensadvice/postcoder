# postcoder

Find addresses using the [Allies postcoder service](https://postcoder.com/docs/address-lookup/address)

This service caches the results to save on credits

## API

GET `http://example.com/addressses/{searchterm}`

This will pass the search term to GET `https://ws.postcoder.com/pcw/{apikey}/address/uk/{searchterm}`

The query options `format`, `line`, `page`, `include`, `exclude`, `callback`, `alias` and `addtags` will also be passed.

If the query option `refresh=true` is provided the cache will be skipped and updated, _for that request_.

### Deprecated endpoint

The older verbose endpoint should no longer be used and will be removed in the future.

GET `http://example.com/pcw/{apikey}/address/uk/{searchterm}`

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

http://localhost:4001/pcw/PCW45-12345-12345-1234X/address/uk/E1

### Testing

```
docker-compose run --rm app bundle exec rspec
```

### Configuration

| Key name              | Description                                                                              |
| ---                   | ---                                                                                      |
| APP_ENV               | The app environment. This should be set to production on all AWS environments            |
| API_KEY               | The API key for the Postcoder web service                                                |
| CACHE_URL             | The url for the Redis cache                                                              |
| CACHE_TTL             | How long to cache a new entry (in seconds).  This is `2_592_000` (30 days) in production |
| NEW_RELIC_LICENSE_KEY | NewRelic license key, only needed in cloud environments                                  |
