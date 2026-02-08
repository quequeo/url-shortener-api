# URL Shortener API

Rails 8 API for shortening URLs with visit tracking.

## Stack

- Ruby 3.3 + Rails 8
- PostgreSQL 16
- Redis + Sidekiq
- Docker Compose

## Setup

```bash
docker-compose build
docker-compose run --rm app rails db:create db:migrate db:seed
docker-compose up
```

API runs on `http://localhost:3000`

## Live Demo

- **Frontend:** https://url-shortener-front-m5wf.onrender.com
- **API:** https://url-shortener-api-g96z.onrender.com

## Architecture

**Short code generation:**
- Redis counter + multiplicative scramble (modular arithmetic)
- Fixed 6-char Base62 codes (`scrambled = counter × prime % 62^6`)
- Capacity: 56B unique URLs
- Fallback: 6 random chars if Redis fails

**Why this approach:**
- Zero collisions (bijective function over the code space)
- Non-sequential output (codes look random, not enumerable)
- Fixed length (always 6 chars)
- Scalable with Redis sharding

**Visit tracking:**
- Async with Sidekiq (non-blocking redirects)
- Atomic counter increments
- IP + User Agent capture

**Design decisions:**
- 302 redirect (not 301) for trackable analytics
- URL validation in model (single source of truth)
- No retry logic (MVP scope)

## Tests

```bash
docker-compose run --rm app bundle exec rspec
docker-compose run --rm app bundle exec rubocop
docker-compose run --rm app bundle exec brakeman
```