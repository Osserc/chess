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

    def selection_loop
        piece = select_piece
        until !piece.nil? do
            prepare_turn
            presentation
            piece = select_piece
        end
        piece
    end

    def select_piece
        puts "Select the piece you want to move."
        answer = gets.chomp.upcase
        until validate_input(answer) do
            puts "Invalid input."
            answer = gets.chomp.upcase
        end
        action(answer)
    end

    def validate_input(answer)
        return true if (LETTERS.include?(answer[0]) && NUMBERS.include?(answer[1].to_i) && answer.length == 2) || answer == "SAVE" || answer == "LOAD"
    end

    def action(answer)
        case answer
        when "SAVE"
            save_game
            return nil
        when "LOAD"
            load_game
            return nil
        else
            coord = convert_front_to_back(answer)
            piece = check_piece(coord)
            return piece
        end
    end

    def check_piece(coord)
        if BoardState.board[coord].class.ancestors.include?(Piece)
            if @turn.odd?
                return BoardState.board[coord] if BoardState.board[coord].color == "white" && !BoardState.board[coord].moves.empty?
                puts "Invalid coordinates."
                select_piece
            else
                return BoardState.board[coord] if BoardState.board[coord].color == "black" && !BoardState.board[coord].moves.empty?
                puts "Invalid coordinates."
                select_piece
            end
        else
            puts "Invalid coordinates."
            select_piece
        end
    end

    def select_destination(piece)
        puts "Select the square where you want your piece to move."
        destination = gets.chomp.upcase
        until validate_destination(piece, destination) do
            puts "Invalid input."
            destination = gets.chomp.upcase
        end
        convert_front_to_back(destination)
    end

    def validate_destination(piece, destination)
        return true if LETTERS.include?(destination[0]) && NUMBERS.include?(destination[1].to_i) && destination.length == 2 && piece.moves.include?(convert_front_to_back(destination))
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

    def checked
        puts "Your king in check."
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
        BoardState.board.each do | piece |
            return piece if piece.class.name == "King" && piece.color == color
        end
    end

    def collect_set(color)
        set = Array.new
        BoardState.board.each do | square |
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

    def revert_move
        move = PastMoves.move_history.tail.value
        piece_to_move_back = move[:moved_piece]
        piece_to_move_back.displaced -= 1
        distance_traveled = move[:distance_traveled]
        piece_to_resurrect = move[:eaten_piece]
        piece_to_resurrect.nil? ? BoardState.board[piece_to_move_back.position] = " " : BoardState.board[piece_to_move_back.position] = piece_to_resurrect
        piece_to_move_back.position -= distance_traveled
        BoardState.board[piece_to_move_back.position] = piece_to_move_back
        revert_move_castling(move) if move.key?(:castled)
        revert_move_en_passant(move) if move.key?(:en_passant)
        PastMoves.move_history.pop
    end

    def revert_move_castling(move)
        rook = move[:castled][:rook]
        distance = move[:castled][:distance]
        BoardState.board[rook.position] = " "
        rook.position -= distance
        BoardState.board[rook.position] = rook
    end

    def revert_move_en_passant(move)
        pawn = move[:en_passant][:pawn]
        BoardState.board[pawn.position] = pawn
    end

    def regenerate_moveset(set)
        set.each do | piece |
            piece.define_moveset
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
            checkmate if in_check?(collect_set("black"), "white") && count_moves.empty?
            checked if in_check?(collect_set("black"), "white") && !count_moves.empty?
            stalemate if !in_check?(collect_set("black"), "white") && count_moves.empty?
        else
            checkmate if in_check?(collect_set("white"), "black") && count_moves.empty?
            checked if in_check?(collect_set("white"), "black") && !count_moves.empty?
            stalemate if !in_check?(collect_set("white"), "black") && count_moves.empty?
        end
    end

end

module BoardState

    class << self
        attr_accessor :board

        def make_board
            Array.new(64, " ")
        end

        def display_board
            i = 0
            b = 0
            print "   | " + Navigation::NUMBERS.join(" | ").to_s + " |\n"
            print "---+---+---+---+---+---+---+---+---+\n"
            until i == 8 && b == 64
                print " " + Navigation::LETTERS[i] + " | " + BoardState.board.slice(b, 8).map { | element | element.class.ancestors.include?(Piece) ? element.symbol : element }.join(" | ").to_s + " |\n"
                print "---+---+---+---+---+---+---+---+---+\n"
                i += 1
                b += 8
            end
        end

        def populate_board(white, black)
            white.each do | element |
                BoardState.board[element.position] = element
            end
            black.each do | element |
                BoardState.board[element.position] = element
            end
        end

        def prepare_pieces
            white = Array.new
            black = Array.new
    
            white << King.new("???", 3, "white")
            white << Queen.new("???", 4, "white")
            white << Bishop.new("???", 2, "white")
            white << Bishop.new("???", 5, "white")
            white << Knight.new("???", 1, "white")
            white << Knight.new("???", 6, "white")
            white << Rook.new("???", 0, "white")
            white << Rook.new("???", 7, "white")
            (8..15).to_a.each do | square |
                white << Pawn.new("???", square, "white")
            end
    
            black << King.new("???", 59, "black")
            black << Queen.new("???", 60, "black")
            black << Bishop.new("???", 58, "black")
            black << Bishop.new("???", 61, "black")
            black << Knight.new("???", 57, "black")
            black << Knight.new("???", 62, "black")
            black << Rook.new("???", 56, "black")
            black << Rook.new("???", 63, "black")
            (48..55).to_a.each do | square |
                black << Pawn.new("???", square, "black")
            end
    
            return white, black
        end
    end

    self.board = make_board

end