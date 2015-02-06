require_relative '../spec_helper'

module LruCache2
  describe Node do
    let(:pairs) { Hash[5.times.collect{ |i| ["key#{i}", "value#{i}"] }] }
    let(:key)   { 'random_key' }
    let(:value) { 'random_value' }

    context '#initialize' do
      it 'without params' do
        expect{ Node.new }.to raise_error(ArgumentError)
      end
    end

    it 'get key' do
      expect(Node.new(key: 'key', value: 'value').key).to eq('key')
    end

    it 'get value' do
      expect(Node.new(key: 'key', value: 'value').value).to eq('value')
    end

    it 'get next and previous' do
      node1 = Node.new(key: 'key1', value: 'value1')
      node2 = Node.new(key: 'key', value: 'value', previous: node1, next: node1)

      expect(node2.previous).to be(node1)
      expect(node2.next).to     be(node1)
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
        node = Node.new(key: key, value: value)

        expect(node.to_a).to eq([{key => value}].to_a)
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
    end
  end
end
