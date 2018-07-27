class Hash
  class ChainFetcher
    def initialize(hash, *keys)
      @hash = hash
      @keys = keys
    end

    def fetch
      value = hash

      if block_given?
        value = value.fetch(keys.shift) do |*args|
          missed_keys = keys
          @keys = []
          yield(*(args + [missed_keys]))
        end until keys.empty?
      else
        value = value.fetch(keys.shift) until keys.empty?
      end

      value
    end

    private

    attr_reader :hash, :keys
  end
end
