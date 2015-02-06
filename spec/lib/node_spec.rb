require_relative '../spec_helper'

module LruCache2
  describe Node do
    let(:pairs) { Hash[5.times.collect{ |i| ["key#{i}", "value#{i}"] }] }
    let(:key)   { 'random_key' }
    let(:value) { 'random_value' }
    let(:node)  { Node.new(key: key, value: value) }

    context '#initialize' do
      it 'without params' do
        expect{ Node.new }.to raise_error(ArgumentError)
      end
    end

    it 'get key' do
      expect(node.key).to eq(key)
    end

    it 'get value' do
      expect(node.value).to eq(value)
    end

    it 'get next and previous' do
      node1 = node
      node2 = Node.new(key: 'key', value: 'value', previous: node1, next: node1)

      expect(node2.previous).to be(node1)
      expect(node2.next).to     be(node1)
    end

    context '#<<' do
      it 'nil' do
        node << nil
        expect(node.previous).to be_nil
      end
    end

    context 'one node' do
      it '#<<' do
        nodes = 2.times.collect { |i| Node.new(key: "key#{i}", value: pairs["key#{i}"]) }

        nodes[0] << nodes[1]

        expect(nodes[0].previous).to be_nil
        expect(nodes[0].next).to     be(nodes[1])
        expect(nodes[1].previous).to be(nodes[0])
        expect(nodes[1].next).to     be_nil
      end

      it '#to_a' do
        expect(node.to_a).to eq([{key => value}].to_a)
      end

      it '#to_pretty_s' do
        expect(node.to_pretty_s).to eq("{@key: #{node.key}, @value: #{node.value}, @previous: nil, @next: nil}")
      end
    end

    context 'multiple nodes' do
      before(:each) do
        @nodes = 5.times.collect { |i| Node.new(key: "key#{i}", value: pairs["key#{i}"]) }

        prev = @nodes[0]
        4.times.each do |i| 
          prev << @nodes[i+1]
          prev = @nodes[i+1]
        end
      end

      it '#<<' do
        @nodes.each.with_index do |n, i|
          expect(n.previous).to be(i == 0 ? nil : @nodes[i-1])
          expect(n.next).to     be(i == @nodes.size - 1 ? nil : @nodes[i+1])
        end
      end

      it '#to_a' do
        output = @nodes.collect { |n| { n.key => n.value } }.to_a
        expect(@nodes[0].to_a).to eq(output)
      end

      it '#to_pretty_s' do
        output = "{@key: key0, @value: value0, @previous: nil, @next: key1}, {@key: key1, @value: value1, @previous: key0, @next: key2}, {@key: key2, @value: value2, @previous: key1, @next: key3}, {@key: key3, @value: value3, @previous: key2, @next: key4}, {@key: key4, @value: value4, @previous: key3, @next: nil}"
        expect(@nodes[0].to_pretty_s).to eq(output)
      end
    end
  end
end
