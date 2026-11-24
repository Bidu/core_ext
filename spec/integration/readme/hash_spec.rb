# frozen_string_literal: true

require 'spec_helper'

describe Hash do
  describe 'readme' do
    describe '#chain_fetch' do
      subject(:hash) { { a: { b: { c: { d: 10 } } } } }

      it 'fetches value from hashes' do
        expect(hash.chain_fetch(:a, :b, :c, :d)).to eq(10)
      end

      context 'when passing a block' do
        let(:value) do
          hash.chain_fetch(:a, :x, :y, :z) do |key, missed_keys|
            "returned: #{key}\nmissed: [#{missed_keys.join(',')}]"
          end
        end

        it 'return processing of the missed keys' do
          expect(value).to eq("returned: x\nmissed: [y,z]")
        end
      end
    end

    describe '#change_values' do
      subject(:hash) { { a: 1, b: [{ c: 2 }] } }

      it 'changes the values of the hash' do
        expect(hash.change_values { |v| (v + 1).to_s })
          .to eq(a: '2', b: [{ c: '3' }])
      end

      context 'when setting recursive to false' do
        it 'changes the values of the hash' do
          expect(hash.change_values(recursive: false) { |v| (v + 1).to_s })
            .to eq(a: '2', b: [{ c: 2 }])
        end
      end

      context 'when skipping inner hash' do
        subject(:hash) { { a: 1, b: [{ c: 2 }], d: { e: 3 } } }

        let(:result) do
          hash.change_values(skip_inner: false) do |value|
            case value
            when Integer
              (value + 1).to_s
            when described_class
              value.to_s
            else
              value.class
            end
          end
        end

        it 'changes the values skipping inner' do
          expect(result).to eq(a: '2', b: Array, d: '{e: 3}')
        end
      end
    end

    describe '#change_values!' do
      subject(:hash) { { a: 1, b: [{ c: 2 }] } }

      it 'changes the values of the hash' do
        expect { hash.change_values! { |v| (v + 1).to_s } }
          .to change { hash }
          .to(a: '2', b: [{ c: '3' }])
      end

      context 'when setting recursive to false' do
        it 'changes the values of the hash' do
          expect do
            hash.change_values!(recursive: false) { |v| (v + 1).to_s }
          end
            .to change { hash }
            .to(a: '2', b: [{ c: 2 }])
        end
      end

      context 'when skipping inner hash' do
        subject(:hash) { { a: 1, b: [{ c: 2 }], d: { e: 3 } } }

        let(:result) do
          hash.change_values!(skip_inner: false) do |value|
            case value
            when Integer
              (value + 1).to_s
            when described_class
              value.to_s
            else
              value.class
            end
          end
        end

        it 'changes the values skipping inner' do
          expect { result }
            .to change { hash }
            .to(a: '2', b: Array, d: '{e: 3}')
        end
      end
    end

    describe '#camelize_keys' do
      subject(:hash) { { ca_b: 1, k: [{ a_b: 1 }] } }

      it 'camelize all keys' do
        expect(hash.camelize_keys)
          .to eq(CaB: 1, K: [{ AB: 1 }])
      end

      context 'when passing recursive false' do
        it 'camelize all keys without recursion' do
          expect(hash.camelize_keys(recursive: false))
            .to eq(CaB: 1, K: [{ a_b: 1 }])
        end
      end

      context 'when not upcasing first letter' do
        it 'camelize all keys' do
          expect(hash.camelize_keys(uppercase_first_letter: false))
            .to eq(caB: 1, k: [{ aB: 1 }])
        end
      end
    end

    describe '#camelize_keys!' do
      subject(:hash) { { ca_b: 1, k: [{ a_b: 1 }] } }

      it 'camelize all keys' do
        expect { hash.camelize_keys! }
          .to change { hash }
          .to(CaB: 1, K: [{ AB: 1 }])
      end

      context 'when passing recursive false' do
        it 'camelize all keys without recursion' do
          expect { hash.camelize_keys!(recursive: false) }
            .to change { hash }
            .to(CaB: 1, K: [{ a_b: 1 }])
        end
      end

      context 'when not upcasing first letter' do
        it 'camelize all keys' do
          expect { hash.camelize_keys!(uppercase_first_letter: false) }
            .to change { hash }
            .to(caB: 1, k: [{ aB: 1 }])
        end
      end
    end

    describe '#lower_camelize_keys' do
      subject(:hash) { { ca_b: 1, k: [{ a_b: 1 }] } }

      it 'camelize with lower case' do
        expect(hash.lower_camelize_keys)
          .to eq(caB: 1, k: [{ aB: 1 }])
      end
    end

    describe '#lower_camelize_keys!' do
      subject(:hash) { { ca_b: 1, k: [{ a_b: 1 }] } }

      it 'underscores keys' do
        expect { hash.lower_camelize_keys! }
          .to change { hash }
          .to(caB: 1, k: [{ aB: 1 }])
      end
    end

    describe '#undescore_keys' do
      subject(:hash) { { Ca_B: 1, 'kB' => [{ KeysHash: 1 }] } }

      it 'underscores keys' do
        expect(hash.underscore_keys)
          .to eq(ca_b: 1, 'k_b' => [{ keys_hash: 1 }])
      end
    end

    describe '#undescore_keys!' do
      subject(:hash) { { Ca_B: 1, 'kB' => [{ KeysHash: 1 }] } }

      it 'camelize with lower case' do
        expect { hash.underscore_keys! }.to change { hash }
          .to(ca_b: 1, 'k_b' => [{ keys_hash: 1 }])
      end
    end

    describe '#chain_change_keys' do
      subject(:hash) { { ca_b: 1 } }

      it 'changes the keys in order' do
        expect(hash.chain_change_keys(:to_s, :upcase, :to_sym))
          .to eq(CA_B: 1)
      end
    end

    describe '#chain_change_keys!' do
      subject(:hash) { { ca_b: 1 } }

      it 'changes the keys in order' do
        expect do
          hash.chain_change_keys!(:to_s, :upcase, :to_sym)
        end
          .to change { hash }
          .to(CA_B: 1)
      end
    end

    describe '#change_keys' do
      subject(:hash) do
        { ca_b: 1, k: [{ a_b: 1 }] }
      end

      it 'changes keys' do
        expect(hash.change_keys { |k| k.to_s.upcase })
          .to eq('CA_B' => 1, 'K' => [{ 'A_B' => 1 }])
      end

      context 'when passing recursive option false' do
        it 'changes keys not recursively' do
          expect(hash.change_keys(recursive: false) { |k| k.to_s.upcase })
            .to eq('CA_B' => 1, 'K' => [{ a_b: 1 }])
        end
      end
    end

    describe '#change_keys!' do
      subject(:hash) do
        { ca_b: 1, k: [{ a_b: 1 }] }
      end

      it 'changes keys' do
        expect { hash.change_keys! { |k| k.to_s.upcase } }
          .to change { hash }
          .to('CA_B' => 1, 'K' => [{ 'A_B' => 1 }])
      end

      context 'when passing recursive option false' do
        it 'changes keys not recursively' do
          expect do
            hash.change_keys!(recursive: false) { |k| k.to_s.upcase }
          end
            .to change { hash }
            .to('CA_B' => 1, 'K' => [{ a_b: 1 }])
        end
      end
    end

    describe 'prepend_to_keys' do
      subject(:hash) { { key: 1 } }

      it 'prepends string to keys' do
        expect(hash.prepend_to_keys('scope:'))
          .to eq('scope:key': 1)
      end
    end

    describe 'append_to_keys' do
      subject(:hash) { { key: 1 } }

      it 'prepends string to keys' do
        expect(hash.append_to_keys('s'))
          .to eq(keys: 1)
      end
    end

    describe 'map_to_hash' do
      subject(:hash) { { a: 1, b: 2 } }

      it 'mapscreating hash' do
        expect(hash.map_to_hash { |k, v| "#{k}_#{v}" })
          .to eq(a: 'a_1', b: 'b_2')
      end
    end

    describe '#remap_keys' do
      subject(:hash) { { a: 1, b: 2 } }

      it 'remap the keys' do
        expect(hash.remap_keys(a: :c, d: :e))
          .to eq(c: 1, b: 2, e: nil)
      end
    end

    describe '#remap_keys!' do
      subject(:hash) { { a: 1, b: 2 } }

      it 'remap the keys' do
        expect { hash.remap_keys!(a: :c, d: :e) }
          .to change { hash }
          .to(c: 1, b: 2, e: nil)
      end
    end

    describe 'exclusive_merge' do
      subject(:hash) { { a: 1, b: 2 } }

      it 'merges exclusively' do
        expect(hash.exclusive_merge(b: 3, c: 4))
          .to eq(a: 1, b: 3)
      end
    end

    describe 'exclusive_merge!' do
      subject(:hash) { { a: 1, b: 2 } }

      it 'merges exclusively' do
        expect { hash.exclusive_merge!(b: 3, c: 4) }
          .to change { hash }
          .to(a: 1, b: 3)
      end
    end

    describe '#squash' do
      subject(:hash) { { a: { b: [1, 2] } } }

      it 'squash keys' do
        expect(hash.squash)
          .to eq('a.b[0]' => 1, 'a.b[1]' => 2)
      end
    end

    describe '#squash!' do
      subject(:hash) { { a: { b: [1, 2] } } }

      it 'squash keys' do
        expect { hash.squash! }.to change { hash }
          .to('a.b[0]' => 1, 'a.b[1]' => 2)
      end
    end

    describe '#to_deep_hash' do
      subject(:hash) { { 'a.b[0]' => 1, 'a.b[1]' => 2 } }

      it 'builds hash' do
        expect(hash.to_deep_hash)
          .to eq('a' => { 'b' => [1, 2] })
      end
    end

    describe '#to_deep_hash!' do
      subject(:hash) { { 'a.b[0]' => 1, 'a.b[1]' => 2 } }

      it 'builds hash' do
        expect { hash.to_deep_hash! }.to change { hash }
          .to('a' => { 'b' => [1, 2] })
      end
    end

    describe '#sort_keys' do
      subject(:hash) { { b: 1, a: 2 } }

      it 'sort hash keys' do
        expect(hash.sort_keys.keys)
          .to eq(%i[a b])
      end

      it 'does not change the original hash' do
        expect { hash.sort_keys }
          .not_to change(hash, :keys)
      end
    end

    describe '#sort_keys!' do
      subject(:hash) { { b: 1, a: 2 } }

      it 'sort hash keys' do
        expect { hash.sort_keys! }
          .to change(hash, :keys)
          .to(%i[a b])
      end
    end

    describe '#transpose' do
      subject(:hash) { { a: 1, b: :a, c: [2, 3] } }

      it 'transpose keys and values' do
        expect(hash.transpose)
          .to eq(1 => :a, a: :b, [2, 3] => :c)
      end
    end

    describe '#transpose!' do
      subject(:hash) { { a: 1, b: :a, c: [2, 3] } }

      it 'transpose keys and values' do
        expect { hash.transpose! }
          .to change { hash }
          .to(1 => :a, a: :b, [2, 3] => :c)
      end
    end
  end
end
