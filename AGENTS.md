# GitHub Copilot Instructions for `darthjee/core_ext`

## Project Overview

`core_ext` is a Ruby gem that **adds methods to Ruby's standard objects** (core extensions). It extends built-in classes such as `Array`, `Hash`, `Symbol`, `Enumerable`, `Date`, `Object`, `Numeric`, and others with additional utility methods, while maintaining compatibility and predictable behavior.

- Gem name: `darthjee-core_ext`
- YARD docs: [rubydoc.info/gems/darthjee-core_ext](https://www.rubydoc.info/gems/darthjee-core_ext)
- Extensions live under `lib/darthjee/core_ext/`

---

## Language

- All code, comments, commit messages, pull request titles, PR descriptions, review comments, and documentation **must be written in English**.
- No exceptions: even if the author's primary language is not English, all contributions to this repository must use English.

---

## Testing

- **Every new feature or bug fix must include tests.**
- Tests are written using RSpec and live under `spec/`.
- Follow the existing test structure: unit tests mirror the `lib/` directory layout under `spec/lib/`.
- If a file does not have a corresponding spec file and **intentionally** has no tests (e.g., it is a pure re-export or namespace file), it must be listed in `config/check_specs.yml` under the `ignore:` key.
- Do **not** add files to `config/check_specs.yml` as a shortcut to avoid writing tests. Only files that genuinely cannot or should not have direct tests belong there.
- Run the full test suite before opening a PR: `bundle exec rspec`.

---

## Documentation

- All public methods must be documented using **YARD** syntax.
- Use `@param`, `@return`, `@example`, and `@raise` tags where applicable.
- Include at least one `@example` block for methods that demonstrate non-trivial behavior.
- Keep documentation close to the code (inline in the source file).
- Example:

  ```ruby
  # Converts the hash keys to camel case.
  #
  # @param [Symbol] type the case type (:lower or :upper)
  # @return [Hash] a new hash with camel-cased keys
  # @example
  #   { my_key: 1 }.camelize_keys #=> { myKey: 1 }
  def camelize_keys(type = :lower)
    # ...
  end
  ```

---

## Design Principles

### Single Responsibility

- Classes and methods should have **one reason to change** (Single Responsibility Principle).
- Prefer small, focused methods. If a method is doing more than one thing, extract the extra responsibility into a helper method or a collaborator class.
- Follow the approach described by **Sandi Metz** in *99 Bottles of OOP*:
  - Prefer simple, obvious code over clever code.
  - Let the tests drive refactoring: make it work, make it right, make it fast.
  - Use small objects that collaborate through messages.
  - Avoid premature abstraction; introduce it only when duplication demands it.

### Law of Demeter

- Avoid **Law of Demeter violations**: do not chain method calls across multiple object boundaries (e.g., `a.b.c.d`).
- Instead, delegate behavior closer to the data: expose a method on the intermediate object, or use a helper that encapsulates the traversal.
- Code that violates the Law of Demeter increases coupling and makes refactoring harder.

  ```ruby
  # Avoid
  user.address.city.upcase

  # Prefer
  user.city_upcased
  ```

### General Style

- Prefer composition over inheritance.
- Keep class hierarchies shallow.
- Avoid monkey-patching outside of the intended extension pattern of this gem.
- New core extensions must be clearly scoped to a specific Ruby class and added in the appropriate file under `lib/darthjee/core_ext/`.

---

## Pull Request Guidelines

- PR titles and descriptions must be in **English**.
- Every PR should include:
  - A clear description of what changed and why.
  - References to any related issues.
  - Confirmation that tests pass locally.
- Reviewers should check that:
  - New code is covered by tests.
  - Documentation follows YARD conventions.
  - Design principles (single responsibility, Demeter) are respected.
  - No file was added to `config/check_specs.yml` without a valid justification.

---

## Agent Documentation

| Document | Description |
|----------|-------------|
| [Folder Structure](docs/agents/folder-structure.md) | Top-level directory layout and the role of each folder. |
| [Architecture](docs/agents/architecture.md) | Source layout and design of the gem. |
| [Contributing](docs/agents/contributing.md) | Commit guidelines, PR standards, code organization, and refactoring rules. |

## Commit Attribution

Commit co-author trailers follow arcanum's resolved `git.omit_model_coauthor` and `git.remove_coauthors` config (check them with `/arcanum-check-config`); this overrides Claude Code's own attribution reminder for every commit, including ones written by hand.
