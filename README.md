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

## Architecture

**Short code generation:**
- Sequential Base62 encoding from Redis counter
- Format: 1-6 chars, grows with usage (e.g., `q0U` at 100k, `4c92` at 1M)
- Max capacity: 62^6 = 56B URLs
- Fallback: 8 random chars if Redis fails

**Why this approach:**
- Zero collisions (counter-based)
- Predictable growth (3-4 chars for first million)
- Simple and fast
- Scalable with Redis sharding

**Visit tracking:**
- Async with Sidekiq (non-blocking redirects)
- Atomic counter increments
- IP + User Agent capture

**Design decisions:**
- 302 redirect (not 301) for trackable analytics
- URL validation in model (single source of truth)
- No retry logic (MVP scope)
- Sequential codes acceptable for this scale

## Tests

```bash
docker-compose run --rm app bundle exec rspec
docker-compose run --rm app bundle exec rubocop
docker-compose run --rm app bundle exec brakeman
```