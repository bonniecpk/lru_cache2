require_relative '../spec_helper'

module LruCache2
  describe Cache do
    let(:pairs) { Hash[5.times.collect{ |i| ["key#{i}", "value#{i}"] }] }
    let(:key)   { 'key1' }
    let(:value) { 'value1' }

    before(:each) do
      @cache = Cache.new(max_size: 2)
    end

    context '#max_size' do
      it { expect(Cache.new(max_size: 2).max_size).to eq(2) }

      it 'default max size' do
        expect(Cache.new.max_size).to eq(10)
      end
    end

    context '#get' do
      it 'empty cache' do
        expect(@cache.get(key)).to be_nil
      end

      it 'get a hit from 1-element cache' do
        @cache.set(key, value)
        expect(@cache.get(key)).to be(value)
      end

      it 'get a hit of 2nd inserted key from 2-element cache' do
        2.times.each { |i| @cache.set("key#{i}", pairs["key#{i}"]) }

        expect(@cache.get('key1')).to   be(pairs['key1'])
        expect(@cache.head.key).to      eq('key1')
      end

      it 'get a hit of 2nd inserted key from multiple element cache' do
        cache = Cache.new
        5.times.each { |i| cache.set("key#{i}", pairs["key#{i}"]) }

        expect(cache.get('key2')).to   be(pairs['key2'])
        expect(cache.head.key).to      eq('key2')
        expect(cache.head.next.key).to eq('key0')
        expect(cache.tail.key).to      eq('key4')
      end

      it 'get a hit of last inserted key from multiple element cache' do
        cache = Cache.new
        5.times.each { |i| cache.set("key#{i}", pairs["key#{i}"]) }

        expect(cache.get('key4')).to   be(pairs['key4'])
        expect(cache.head.key).to      eq('key4')
        expect(cache.head.next.key).to eq('key0')
        expect(cache.tail.key).to      eq('key3')
      end

      #it 'get a hit after kicking one key out' do
      #  3.times.each { |i| @cache.set(pairs["key#{i}"], pairs["key#{i}"]) }

      #  expect(@cache.get(pairs['key2'])).to be(pairs['key2'])
      #  expect(@cache.get(pairs['key1'])).to be_nil
      #end
    end

    context '#set' do
      #it 'one pair in 1-element cache' do

      #end
    end

    context '#_insert_head' do
      class DummyCache < Cache
        attr_accessor :head, :tail

        def append_list(node)
          _append_list(node)
        end
      end

      before(:each) do
        @cache = DummyCache.new
      end

      it 'empty list' do
        @cache.append_list(Node.new(key: key, value: value))

        expect(@cache.head).to          be(@cache.tail)
        expect(@cache.head.next).to     be_nil
        expect(@cache.head.previous).to be_nil
      end

      it 'multiple node list' do
        nodes = []
        pairs.each do |key, value|
          nodes << Node.new(key: key, value: value)
          @cache.append_list(nodes.last)
        end

        expect(@cache.head.previous).to be_nil
        expect(@cache.head).to          be(nodes[0])
        expect(@cache.head.next).to     be(nodes[1])
        expect(@cache.tail.previous).to be(nodes[3])
        expect(@cache.tail).to          be(nodes[4])
        expect(@cache.tail.next).to     be_nil
      end
    end
  end
end
