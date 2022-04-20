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
        a = @board
        puts "Select the piece you want to move."
        answer = gets.chomp.upcase
        until validate_input(answer) do
            puts "Invalid input."
            answer = gets.chomp.upcase
        end
        action(answer)
    end

    def validate_input(answer)
        return true if (LETTERS.include?(answer[0]) && NUMBERS.include?(answer[1].to_i)) || answer == "SAVE" || answer == "LOAD"
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
            coord = convert_front_to_back(answer)
            piece = check_piece(coord)
            return piece
        end
    end

    def check_piece(coord)
        if @board[coord].class.ancestors.include?(Piece)
            if @turn.odd?
                return @board[coord] if @board[coord].color == "white" && !@board[coord].moves.empty?
                puts "Invalid coordinates."
                select_piece
            else
                return @board[coord] if @board[coord].color == "black" && !@board[coord].moves.empty?
                puts "Invalid coordinates."
                select_piece
            end
        else
            puts "Invalid coordinates."
            select_piece
        end
    end

    def select_destination(piece)
        a = @board
        puts "Select the square where you want your piece to move."
        destination = gets.chomp.upcase
        until validate_destination(piece, destination) do
            puts "Invalid input."
            destination = gets.chomp.upcase
        end
        convert_front_to_back(destination)
    end

    def validate_destination(piece, destination)
        return true if LETTERS.include?(destination[0]) && NUMBERS.include?(destination[1].to_i) && piece.moves.include?(convert_front_to_back(destination))
    end

    def validate_new_game(answer)
        return true if  answer == "YES" || answer == "NO"
    end

    def checkmate
        if @turn.odd?
            puts "Checkmate. Black wins."
            new_game(ask_player_game)
        else
            puts "Checkmate. White wins."
            new_game(ask_player_game)
        end
    end

    def stalemate
        puts "Stalemate."
        new_game(ask_player_game)
    end

    def ask_player_game
        puts "Do you want to play again?"
        answer = gets.chomp.upcase
        until validate_new_game(answer) do
            puts "Invalid input. Type either yes or no."
            answer = gets.chomp.upcase
        end
        answer
    end

    def new_game(answer)
        if answer == "YES"
            Game.new.gameplay
        else
            puts "Thanks for playing."
            exit
        end
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

    def generate_legal_moves
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

    def check_endgame
        if @turn.odd?
            checkmate if in_check?(@black, "white") && count_moves.empty?
            stalemate if !in_check?(@black, "white") && count_moves.empty?
        else
            checkmate if in_check?(@white, "black") && count_moves.empty?
            stalemate if !in_check?(@white, "black") && count_moves.empty?
        end
    end

end