module LruCache2
  class Node
    attr_accessor :key, :value, :previous, :next

    def initialize(**opts)
      raise ArgumentError.new('key and value are mandatory parameters') unless opts[:key] && opts[:value]

      @key      = opts[:key]
      @value    = opts[:value]
      @previous = opts[:previous]
      @next     = opts[:next]
    end

    def <<(node)
      self.next     = node
      node.previous = self
    end

    def to_s
      [{@key => @value}].to_s
    end
  end
end
