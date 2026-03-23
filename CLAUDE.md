# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
bin/dev                        # Start development server (Puma + assets)
bin/rails server               # Start server only (no asset watcher)
bin/rails db:migrate           # Run pending migrations
bin/rails db:test:prepare      # Prepare test database
bin/rails test                 # Run all unit/integration tests
bin/rails test test/models/foo_test.rb        # Run a single test file
bin/rails test test/models/foo_test.rb:42     # Run a single test by line
bin/rails test:system          # Run system tests (Capybara + Selenium)
bin/rubocop                    # Lint Ruby code
bin/rubocop -a                 # Auto-fix offenses
bin/brakeman --no-pager        # Security static analysis
bin/bundler-audit              # Audit gems for known vulnerabilities
bin/importmap audit            # Audit JS dependencies
```

## Architecture

Rails 8.1.1 full-stack app with SQLite and Hotwire.

**Database** — SQLite via multiple databases in production:
- `storage/development.sqlite3` — main development DB
- Production splits into 4 SQLite files: primary, cache, queue, cable (see `config/database.yml`)

**Background jobs** — Solid Queue (DB-backed, no Redis needed). Enqueue with `MyJob.perform_later(...)`. Configure queues in `config/queue.yml`, recurring jobs in `config/recurring.yml`.

**Cache** — Solid Cache (DB-backed). Configured in `config/cache.yml`.

**WebSockets / Action Cable** — Solid Cable (DB-backed). Configured in `config/cable.yml`.

**Frontend** — Importmap (no Node/bundler). Add JS packages via `bin/importmap pin <package>`. Stimulus controllers live in `app/javascript/controllers/`. Turbo handles navigation and partial page updates.

**Assets** — Propshaft (lightweight asset pipeline; no Sprockets).

**Deployment** — Kamal (`config/deploy.yml`) with Dockerfile and Thruster (HTTP caching/compression proxy in front of Puma).

## Testing

Uses Rails default Minitest. System tests use Capybara + Selenium. Fixtures are in `test/fixtures/`. The CI pipeline runs unit tests and system tests separately.
