module Navigation

    LETTERS = ('A'..'H').to_a
    NUMBERS = (1..8).to_a
    BOARD_UI = LETTERS.map { | l | NUMBERS.map { | n | "#{l}#{n}" } }.flatten

    def convert_back_to_front(index)
        converted = BOARD_UI[index]
        converted
    end

    def convert_front_to_back(coords)
        converted = BOARD_UI.index(coords)
        converted
    end

    def select_piece
        answer = gets.chomp.upcase
        until validate_input do
            puts "Inavlid input."
            answer = gets.chomp.upcase
        end
        action(answer)
    end

    def validate_input(answer)
        return true if (LETTERS.include?(answer[0]) && NUMBERS.include?(answer[1])) || answer == "SAVE" || answer == "LOAD"
    end

    def action(answer)
        case answer
        when "SAVE"
            puts "How do you want to call your save?"
            save_functionality(gets.chomp)
        when "LOAD"
            puts "Which savegame do you want to load?"
            load_functionality(gets.chomp)
        else
            check_piece(convert_front_to_back(answer))
            return convert_front_to_back(answer)
        end
    end

    def check_piece(coord)
        if @board[coord].class.ancestors.include?(Piece)
            if @turn.odd?
                return @board[coord] if @board[coord].color == "white" && !@board[coord].empty?
                puts "Invalid coordinates."
                select_piece
            else
                return @board[coord] if @board[coord].color == "white" && !@board[coord].empty?
                puts "Invalid coordinates."
                select_piece
            end
        else
            puts "Invalid coordinates."
            select_piece
        end
    end

    def select_destination

    end

end

module Check

    def generate_threatened_squares(set)
        threatened_squares = Array.new
        set.each do | piece |
            piece.moves.flatten.each do | single_move |
                threatened_squares << single_move
            end
        end
        threatened_squares
    end

    def find_king(color)
        @board.each do | piece |
            return piece if piece.class.name == "King" && piece.color == color
        end
    end

    def collect_set(color)
        set = Array.new
        @board.each do | square |
            if square.class.ancestors.include?(Piece)
                set << square if square.color == color
            end
        end
        set
    end

    def in_check?(set, color)
        threatened_squares = generate_threatened_squares(set)
        king = find_king(color)
        threatened_squares.include?(king.position)
    end

    def purge_illegal_moves
        if @turn.odd?
            active_pieces = collect_set("white")
            regenerate_moveset(active_pieces)
            active_pieces.each do | piece |
                illegal_moves = Array.new
                piece.moves.each do | single_move |
                    piece.move_piece(single_move)
                    opponent_pieces = collect_set("black")
                    regenerate_moveset(opponent_pieces)
                    illegal_moves << single_move if in_check?(opponent_pieces, "white")
                    revert_move
                end
                piece.moves -= illegal_moves
            end
        else
            active_pieces = collect_set("black")
            regenerate_moveset(active_pieces)
            active_pieces.each do | piece |
                illegal_moves = Array.new
                piece.moves.each do | single_move |
                    piece.move_piece(single_move)
                    opponent_pieces = collect_set("white")
                    regenerate_moveset(opponent_pieces)
                    illegal_moves << single_move if in_check?(opponent_pieces, "black")
                    revert_move
                end
                piece.moves -= illegal_moves
            end         
        end
    end

    def count_moves
        if @turn.odd?
            active_pieces = collect_set("white")
            possible_moves = Array.new
            active_pieces.each do | piece |
                piece.moves.each do | single_move |
                    possible_moves << single_move
                end
            end
        else
            active_pieces = collect_set("black")
            possible_moves = Array.new
            active_pieces.each do | piece |
                piece.moves.each do | single_move |
                    possible_moves << single_move
                end
            end
        end
        possible_moves
    end

end