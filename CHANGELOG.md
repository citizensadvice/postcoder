# CHANGELOG

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
