# Architecture

## Overview

`darthjee-core_ext` is a Ruby gem that adds utility methods to Ruby's built-in classes. Each extension is scoped to one core class and lives in its own file, so a consumer can require only what they need.

## Source Code Layout

All source lives under `lib/darthjee/core_ext/`. `lib/darthjee.rb` is the entry point.

- `array.rb`, `class.rb`, `date.rb`, `enumerable.rb`, `hash.rb`, `math.rb`, `numeric.rb`, `object.rb`, `symbol.rb` and `time.rb` each extend the matching core class.
- `version.rb` holds the gem version.

### `array/`

`HashBuilder`, a helper behind the `Array` extension that builds hashes.

### `hash/`

Collaborators for the `Hash` extension, one responsibility per class:

- Key and value changing: `key_changer`, `value_changer`, `key_changeable`, `changeable`
- Camel-casing: `cameliazable`
- Sorting keys: `keys_sorter`
- Chained fetching: `chain_fetcher`
- Squashing nested hashes: `squasher`
- Transforming and transposing: `transformable`, `transposeable`
- Deep construction: `deep_hash_constructor`

## Conventions

- Public methods are documented with YARD. The Yardstick config is in `config/`.
- Specs mirror `lib/` under `spec/lib/`. Files without specs must be listed in `config/check_specs.yml`.
