# Contributing

## Commit Guidelines

- **Atomic and Unitary:** Each commit must represent a single logical change.  
  *Example:*  
  - Good: `Add Hash#squash method`  
  - Bad: `Add Hash#squash and refactor KeyChanger`
- **No Unrelated Changes:** Do not mix unrelated changes in the same commit.
- **Separate Refactoring:** Whenever possible, separate refactoring commits from new feature or bugfix commits.

## Pull Requests

- **Descriptive Summary:** Every PR must include a clear and descriptive summary of its purpose and changes.
- **PR Description Files:** If a description cannot be provided directly in the PR, generate a file with the PR description (e.g., `docs/agents/issues/<pr_number>_description.md`), but do not commit this file.

## Definition of Done for PRs

A PR is considered complete when:

- The stated objective has been achieved.
- All tests are passing.
- Linting passes without errors.
- Code coverage is as high as reasonably possible.
- Code is not overly complex:
  - Classes and methods should have clear, focused responsibilities.
  - If a class or method is taking on too many responsibilities, refactor to simplify.
  - Methods should be small and do exactly one thing. If a method is growing, extract parts into private helper methods or separate classes.
  - *Example (pseudo-code):*

    ```ruby
    # Good: each method does one thing
    class Worker
      def fetch_job; end
      def process_job(job); end
    end

    # Bad: method does too much
    class Worker
      def run
        fetch_job
        process_job
        send_metrics
        cleanup
      end
    end
    ```

  - This requirement applies primarily to source code. For specs, refactor only if there is excessive duplication.

### CI Checks

Before a PR is considered complete, all CI checks must pass locally. The project has a single Ruby codebase, so every code change runs both CircleCI jobs (`.circleci/config.yml`):

| CircleCI job | Local command |
| --- | --- |
| `test` | `bundle exec rspec` |
| `checks` | `bundle exec rubocop` |
| `checks` | `bundle exec rake verify_measurements` (YARD documentation coverage; run `bundle exec rake yardstick_measure` first if needed) |
| `checks` | `PROJECT=darthjee-core_ext scripts/check_readme.sh` (README must reference the current version's YARD docs) |
| `checks` | `scripts/rubycritic.sh` (RubyCritic on changed `lib/` files) |
| `checks` | `check_specs` (every `lib/` file needs a spec unless listed in `config/check_specs.yml`) |

Commands can also be run inside Docker via `docker-compose run core_ext_circleci`, `make dev` or `make ci`.

This same process must be followed when **planning how to resolve an issue**: include a final step in the plan that lists the CI commands to run before opening a PR.

## Code Organization

### File Responsibility: Class Declarers vs Scripts

Every source file under `lib/` must define one or more classes or modules and must not execute logic or cause side effects at load time. The only extension point is reopening/including into core classes, which is the purpose of this gem.

### File Naming

Files use `snake_case.rb` and mirror the constant they define (`KeyChanger` in `key_changer.rb`). Specs mirror `lib/` under `spec/lib/` with a `_spec.rb` suffix. Core extensions go in `lib/darthjee/core_ext/<class>.rb`; collaborators go in a sibling folder named after the class (e.g. `hash/`).

### Method Order: Public Before Private

Public methods are declared before `private` ones; private methods are implementation helpers placed at the end of the class.

```ruby
# Good
class Worker
  def run
    prepare
    execute
  end

  private

  def prepare; end
  def execute; end
end
```

## Dependency Injection

Classes receive their dependencies (data, collaborators) as constructor arguments and never load files or read environment variables themselves. This keeps every class independently testable.

```ruby
# Good
class Router
  def initialize(data)
    @data = data
  end
end

# Bad
class Router
  def build
    data = YAML.load_file('./data.yml')
  end
end
```

## Refactoring Guidelines

When refactoring, aim to:

- **Reduce Code Duplication:** move repeated spec setup into `let` blocks or shared helpers.
- **Keep Classes Focused:** extract responsibilities into collaborator classes (see `lib/darthjee/core_ext/hash/`).
- **Follow the Law of Demeter:** avoid chains like `a.b.c.d`.
