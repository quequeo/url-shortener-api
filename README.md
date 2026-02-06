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

## Usage

Create account:
```bash
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{"user":{"name":"Test","email":"test@example.com","password":"password123"}}'
```

Shorten URL:
```bash
curl -X POST http://localhost:3000/api/v1/links \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"url":"https://github.com"}'
```

Visit short link:
```bash
curl http://localhost:3000/abc123
```

## Architecture

**Short code generation:**
- Sequential Base62 encoding from Redis counter
- Format: 6 chars (e.g., `q0U`, `4c92`)
- Capacity: 62^6 = 56B URLs
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

Coverage: 92%
