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
      _swap_head(node)
      node ? node.value : nil
    end

    def set(key, val)
      node = Node.new(key: key, value: val)

      @max_size == @hash.size ? _evict_extra(node) : _append_list(node)

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

    # Move 'node' to the head of the linked list
    def _swap_head(node)
      if @head != nil && node != nil && node != @head
        @head << node.next
        node  << @head
        @head = node
        @tail = node.previous if @tail == node
      end

      @head
    end

    # Evict the LRU node from the list and the hashtable
    def _evict_extra(node)
      @hash.delete(@head.key)
      @head = @head.next
      @head.previous = nil
    end
  end
end

