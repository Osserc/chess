module SaveLoad

    def save_game
        puts "Which name would you like to assign to your savegame?"
        file = gets.chomp
        dirname = "savegames"
        Dir.mkdir(dirname) unless File.exists?(dirname)
        data = [BoardState.board, @turn, PastMoves.move_history]
        File.open("#{dirname}/#{file}.txt", 'w') do | file |
            file.puts(Marshal.dump(data))
        end
        puts "Your game has been saved."
    end

    def load_game
        puts "Which game would you like to load?"
        unless File.exists?("savegames")
            puts "There are no saved game states."
            return
        end
        display_savegames
        file = load_loop
        data = File.open("savegames/#{file}.txt", "r") { | file | Marshal.load(file) }
        board, turn, past = data
        BoardState.board = board
        @turn = turn
        PastMoves.move_history = past
    end

    def display_savegames
        puts Dir.glob("savegames/*").map {| element | element.delete_prefix("savegames/").delete_suffix(".txt")}.join("\n")
    end

    def load_loop
        file = gets.chomp
        until Dir.glob("savegames/*").map {| element | element.delete_prefix("savegames/").delete_suffix(".txt")}.include?(file) do
            puts "\nThat\'s not a valid savegame. You have to match one from memory."
            file = gets.chomp
        end
        file
    end

end

class MoveHistory
    attr_reader :head, :tail
    def initialize(head = nil, tail = nil)
        @head = Node.new(head)
        @tail = Node.new(tail)
        @head.next_node = @tail
    end

    def append(value)
        node = Node.new(value)
        if @tail.nil?
            @tail = node
        else
            @tail.next_node = node
            @tail = node
        end
    end

    def size
        explorer = @head
        counter = 1
        until explorer.nil? do
            explorer = explorer.next_node
            counter += 1
        end
        counter -= 1
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
        loop do
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

module PastMoves

    class << self
        attr_accessor :move_history
    end

    self.move_history = MoveHistory.new

end