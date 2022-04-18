class MoveHistory
    attr_reader :head, :tail
    def initialize(head = nil, tail = nil)
        @head = Node.new(head)
        @tail = Node.new(tail)
        @head.next_node = @tail
    end

    def append(value)
        node = Node.new(value)
        if @head.value.nil?
            @head = node
            @head.next_node = @tail
        elsif @tail.value.nil?
            @tail = node
            @head.next_node = @tail
        else
            @tail.next_node = node
            @tail = node
        end
    end

    def pop
        explorer = @head
        counter = 1
        size = self.size - 1
        until counter == size do
            explorer = explorer.next_node
            counter += 1
        end
        explorer.next_node = nil
        @tail = explorer
    end

    def find_last
        explorer = @head
        until explorer.nil?  do
            return explorer if explorer.next_node.nil?
            explorer = explorer.next_node
        end
    end

end

class Node
    attr_accessor :value, :next_node
    def initialize(value = nil, next_node = nil)
        @value = value
        @next_node = next_node
    end
end