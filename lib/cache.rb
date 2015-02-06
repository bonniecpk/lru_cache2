module LruCache2
  class Cache
    attr_accessor :max_size, :head, :tail

    def initialize(**opts)
      @max_size = opts[:max_size] ? opts[:max_size] : 10
      @hash     = {}
      @head     = nil
      @tail     = nil
    end

    def get(key)
      node = @hash[key]
      
      if node != @head
        @head.next = node.next
        @tail      = node.previous if @tail == node
        node.next  = @head
        @head      = node
      end

      node ? node.value : nil
    end

    def set(key, val)
      node = Node.new(key: key, value: val)
      
      _append_list(node)

      @hash[key] = node
    end

    protected
    def _append_list(node)
      if @head
        @tail << node
        @tail = node
      else
        @head = node
        @tail = node
      end
    end
  end
end

