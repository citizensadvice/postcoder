# postcoder
Proxy server for Postcoder

## Build

```
docker build -t citizensadvice/postcoder .
```

## Start

```
docker-compose up
```

```
docker run
  -p 4000:4000
  --env APP_ENV=production
  --env API_KEY=PCW45-12345-12345-1234X
  --env CACHE_URL=redis://cache:6379/1
  --env CACHE_TTL=86400
citizensadvice/postcoder
```

### Testing

```
docker-compose run --rm app bundle exec rspec
```

### Configuration

| Key name | Description |
|---|---|
| APP_ENV | The app environment. This should be set to production on all AWS environments |
| API_KEY | The API key for the postcoder web service |
| CACHE_URL | The url for the redis cache |
| CACHE_TTL | How long to cache a new entry (in seconds) |
