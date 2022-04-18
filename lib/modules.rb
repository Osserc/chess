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

end

module Check

    # def generate_threats_white
    #     white_threatened_squares = Array.new
    #     @white.each do | piece |
    #         piece.moves.flatten.each do | single_move |
    #             white_threatened_squares << single_move
    #         end
    #     end
    #     white_threatened_squares
    # end

    # def generate_threats_black
    #     black_threatened_squares = Array.new
    #     @black.each do | piece |
    #         piece.moves.flatten.each do | single_move |
    #             black_threatened_squares << single_move
    #         end
    #     end
    #     black_threatened_squares
    # end

    def generate_threatened_squares(set)
        threatened_squares = Array.new
        set.each do | piece |
            piece.moves.flatten.each do | single_move |
                threatened_squares << single_move
            end
        end
        threatened_squares
    end

    def generate_threatened_squares(set)
        threatened_squares = Array.new
        set.each do | piece |
            piece.moves.flatten.each do | single_move |
                threatened_squares << single_move
            end
        end
        threatened_squares
    end

    def find_king(set, color)
        set.each do | piece |
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

    def check_game_state
        if @turn.odd?
            active_pieces = collect_set("white")
            active_pieces.each do | piece |
                illegal_moves = Array.new
                piece.moves.flatten.each do | single_move |
                    piece.moved_piece(single_move)
                    opponent_pieces = collect_set("black")
                    regenerate_moveset(opponent_pieces)
                    illegal_moves << single_move if in_check?(set, "white")
                end
            end
            piece.moves -= 
        end
    end

    # def find_white_king
    #     @white.each do | piece |
    #         return piece if piece.class.name == "King" && piece.color == "white"
    #     end
    # end

    # def find_black_king
    #     @black.each do | piece |
    #         return piece if piece.class.name == "King" && piece.color == "black"
    #     end
    # end

    # def white_in_check?
    #     black_threatened_squares = generate_threats_black
    #     white_king = find_white_king
    #     black_threatened_squares.include?(white_king.position)
    # end

    # def black_in_check?
    #     white_threatened_squares = generate_threats_white
    #     black_king = find_black_king
    #     white_threatened_squares.include?(black_king.position)
    # end

    # def collect_active_pieces
    #     if @turn.odd?
    #         active_pieces = Array.new
    #         @board.each do | square |
    #             if square.class.ancestors.include?(Piece)
    #                 active_pieces << square if square.color == "white"
    #             end
    #         end
    #     else
    #         @board.each do | square |
    #             if square.class.ancestors.include?(Piece)
    #                 active_pieces << square if square.color == "black"
    #             end
    #         end
    #     end
    #     active_pieces
    # end

    # def collect_opponent_pieces
    #     if @turn.odd?
    #         opponent_pieces = Array.new
    #         @board.each do | square |
    #             if square.class.ancestors.include?(Piece)
    #                 opponent_pieces << square if square.color == "white"
    #             end
    #         end
    #     else
    #         @board.each do | square |
    #             if square.class.ancestors.include?(Piece)
    #                 opponent_pieces << square if square.color == "black"
    #             end
    #         end
    #     end
    #     opponent_pieces
    # end

end