# Folder Structure

## Project Root

| Directory / File | Description |
|------------------|-------------|
| `lib/`           | Gem source code (`lib/darthjee/core_ext/`). |
| `spec/`          | RSpec tests: `lib/` mirrors the source layout, `integration/` holds README and YARD checks, `support/` holds helpers. |
| `config/`        | Tooling config: `check_specs.yml` (files exempt from needing specs), RubyCritic and Yardstick settings. |
| `scripts/`       | Helper shell scripts (`check_readme.sh`, `rubycritic.sh`). |
| `.circleci/`     | CircleCI pipeline. |
| `.github/`       | Copilot pointer, PR template and commit message templates. |
| `docs/agents/`   | Documentation, issues and plans for AI agents. |
| `*_README.md`    | Per-class usage docs (Array, Class, Date, Enumerable, Hash, Math, Object, Symbol), linked from `README.md`. |
| `core_ext.gemspec`, `Gemfile`, `Rakefile` | Gem packaging and dependencies. |
| `Dockerfile`, `docker-compose.yml`, `Makefile` | Dev and CI container environment (`make dev`, `make ci`). |
| `.rubocop*.yml`, `.reek.yml` | Lint and code-smell configuration. |
