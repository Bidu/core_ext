# frozen_string_literal: true

require 'darthjee/core_ext/hash/key_changeable'
require 'darthjee/core_ext/hash/transposeable'
require 'darthjee/core_ext/hash/transformable'

class Hash
  autoload :ChainFetcher,        'darthjee/core_ext/hash/chain_fetcher'
  autoload :DeepHashConstructor, 'darthjee/core_ext/hash/deep_hash_constructor'
  autoload :KeyChanger,          'darthjee/core_ext/hash/key_changer'
  autoload :KeysSorter,          'darthjee/core_ext/hash/keys_sorter'
  autoload :Squasher,            'darthjee/core_ext/hash/squasher'
  autoload :ValueChanger,        'darthjee/core_ext/hash/value_changer'
  autoload :ToHashMapper,        'darthjee/core_ext/hash/to_hash_mapper'

  include Hash::KeyChangeable
  include Hash::Transposeable
  include Hash::Transformable

  ########################################
  # Fetching methods
  #########################################

  def chain_fetch(*keys, &block)
    ChainFetcher.new(self, *keys, &block).fetch
  end
end
