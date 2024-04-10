# CHANGELOG

## v4.3.1 _29 February 2024_

- Rack security fixes

## v4.3.0 _11 January 2024_

- Update to Ruby 3.3.0

## v4.2.0 _24 April 2023_

- Added additional postcodes to the mock responses
- Updated to Ruby 3.2.2

## v4.1.0 _13 February 2023_

- Added a version endpoint
- New Relic now defaults to off
- Updated to Ruby 3.2.1 and alpine 3.17

## v4.0.3 _31 January 2023_

- Reduced the connect timeout on Redis so returns are more responsive without redis
- Updated to Ruby 3.2.0

## v4.0.2 _12 August 2022_

- Fix arm64 compaible image missing platforms in Gemfile.lock

## v4.0.1 _2 August 2022_

- Create arm64 compatible image

## v4.0.0 _27 July 2022_

- Removed the deprecated `/pcw/:api_key...` endpoint

## v3.0.0 _14 July 2022_

- Added a mock mode enabled by MOCK_MODE=true

## v2.0.0 _17 June 2022_

- fix requests being made to the pcw service regardless of caching
- make the service resilient to Redis being unavailable
- add a new simplified endpoint
- better error recording
- Update Ruby
- Update GEMS
- Add lint step to build process
