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

    # TODO: Can refactor with nicer syntax
    def to_a
      pairs = []
      node  = self
      while node != nil
        pairs << { node.key => node.value }
        node = node.next
      end
      pairs
    end

    def to_pretty_s
      array    = instance_variables.collect { |key| "#{key}: #{_attr_value(key)}" }
      self_str = '{' + array.join(', ') + '}'
      self.next ? (self_str + ', ' + self.next.to_pretty_s) : self_str
    end

    def to_s
      key
    end

    protected
    def _attr_value(key)
      value   = instance_variable_get(key)
      value ||= 'nil'
      value
    end
  end
end
