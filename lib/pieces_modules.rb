module King_Limitations

    UPPER_LIMITATIONS = [-9, -8, -7]
    LEFT_LIMITATIONS = [-9, -1, 7]
    RIGHT_LIMITATIONS = [-7, 1, 9]
    LOWER_LIMITATIONS = [9, 8, 7]

    def refine_moveset_king
        king_borders
        check_friendly
        castling
        convert_to_squares
    end

    def king_borders
        self.moves -= UPPER_LIMITATIONS if Table::TOP_BORDER.include?(self.position) 
        self.moves -= LEFT_LIMITATIONS if Table::LEFT_BORDER.include?(self.position)
        self.moves -= RIGHT_LIMITATIONS if Table::RIGHT_BORDER.include?(self.position)
        self.moves -= LOWER_LIMITATIONS if Table::BOTTOM_BORDER.include?(self.position)
    end

    def castling
        if self.color == "white" && self.displaced == 0
            if BoardState.board[0].class.ancestors.include?(Piece)
                self.moves += [-2] if BoardState.board[0].displaced == 0 && BoardState.board[1] == " " && BoardState.board[2] == " " && [1, 2, self.position].none? { | square | generate_threatened_squares(collect_set("black")).include?(square) }
            end
            if BoardState.board[7].class.ancestors.include?(Piece)
                self.moves += [2] if BoardState.board[7].displaced == 0 && BoardState.board[4] == " " && BoardState.board[5] == " " && BoardState.board[6] == " " && [self.position, 4, 5].none? { | square | generate_threatened_squares(collect_set("black")).include?(square) }
            end
        elsif self.color == "black" && self.displaced == 0
            if BoardState.board[56].class.ancestors.include?(Piece)
                self.moves += [-2] if BoardState.board[56].displaced == 0 && BoardState.board[57] == " " && BoardState.board[58] == " " && [57, 58, self.position].none? { | square | generate_threatened_squares(collect_set("white")).include?(square) }
            end
            if BoardState.board[63].class.ancestors.include?(Piece)
                self.moves += [2] if BoardState.board[63].displaced == 0 && BoardState.board[60] == " " && BoardState.board[61] == " " && BoardState.board[62] == " " && [self.position, 60, 61].none? { | square | generate_threatened_squares(collect_set("white")).include?(square) }
            end
        end
    end

end

module Queen_Limitations

    UPPER_LIMITATIONS = [[-9], [-8], [-7]]
    LEFT_LIMITATIONS = [[-9], [-1], [7]]
    RIGHT_LIMITATIONS = [[-7], [1], [9]]
    LOWER_LIMITATIONS = [[7], [8], [9]]

    def refine_moveset_queen
        self.moves.each { | direction | check_friendly(direction) }
        queen_borders
        build_directions
        convert_to_squares
    end

    def queen_borders
        self.moves -= UPPER_LIMITATIONS if Table::TOP_BORDER.include?(self.position) 
        self.moves -= LEFT_LIMITATIONS if Table::LEFT_BORDER.include?(self.position)
        self.moves -= RIGHT_LIMITATIONS if Table::RIGHT_BORDER.include?(self.position)
        self.moves -= LOWER_LIMITATIONS if Table::BOTTOM_BORDER.include?(self.position)
    end

end

module Bishop_Limitations

    UPPER_LIMITATIONS = [[-9], [-7]]
    LEFT_LIMITATIONS = [[-9], [7]]
    RIGHT_LIMITATIONS = [[-7], [9]]
    LOWER_LIMITATIONS = [[7], [9]]

    def refine_moveset_bishop
        self.moves.each { | direction | check_friendly(direction) }
        bishop_borders
        build_directions
        convert_to_squares
    end

    def bishop_borders
        self.moves -= UPPER_LIMITATIONS if Table::TOP_BORDER.include?(self.position) 
        self.moves -= LEFT_LIMITATIONS if Table::LEFT_BORDER.include?(self.position)
        self.moves -= RIGHT_LIMITATIONS if Table::RIGHT_BORDER.include?(self.position)
        self.moves -= LOWER_LIMITATIONS if Table::BOTTOM_BORDER.include?(self.position)
    end

end

module Knight_Limitations

    UPPER_BOUND = (9..14).to_a
    UPPER_LIMITATIONS = [-17, -15, -10, -6]
    UPPER__BOUND_LIMITATIONS = [-17, -15]
    LEFT_BOUND = [9, 17, 25, 33, 41, 49]
    LEFT_LIMITATIONS = [-17, -10, 6, 15]
    LEFT__BOUND_LIMITATIONS = [-10, 6]
    RIGHT_BOUND = [14, 22, 30, 38, 46, 54]
    RIGHT_LIMITATIONS = [-15, -6, 10, 17]
    RIGHT_BOUND_LIMITATIONS = [-6, 10]
    LOWER_BOUND = (49..54).to_a
    LOWER_LIMITATIONS = [17, 15, 10, 6]
    LOWER__BOUND_LIMITATIONS = [17, 15]

    def refine_moveset_knight
        check_friendly
        knight_borders
        convert_to_squares
    end

    def knight_borders
        self.moves -= UPPER_LIMITATIONS if Table::TOP_BORDER.include?(self.position) 
        self.moves -= UPPER__BOUND_LIMITATIONS if UPPER_BOUND.include?(self.position)
        self.moves -= LEFT_LIMITATIONS if Table::LEFT_BORDER.include?(self.position)
        self.moves -= LEFT__BOUND_LIMITATIONS if LEFT_BOUND.include?(self.position)
        self.moves -= RIGHT_LIMITATIONS if Table::RIGHT_BORDER.include?(self.position)
        self.moves -= RIGHT_BOUND_LIMITATIONS if RIGHT_BOUND.include?(self.position)
        self.moves -= LOWER_LIMITATIONS if Table::BOTTOM_BORDER.include?(self.position)
        self.moves -= LOWER__BOUND_LIMITATIONS if LOWER_BOUND.include?(self.position)
    end

end

module Rook_Limitations

    UPPER_LIMITATIONS = [[-8]]
    LEFT_LIMITATIONS = [[-1]]
    RIGHT_LIMITATIONS = [[1]]
    LOWER_LIMITATIONS = [[8]]

    def refine_moveset_rook
        self.moves.each { | direction | check_friendly(direction) }
        rook_borders
        build_directions
        convert_to_squares
    end

    def rook_borders
        self.moves -= UPPER_LIMITATIONS if Table::TOP_BORDER.include?(self.position) 
        self.moves -= LEFT_LIMITATIONS if Table::LEFT_BORDER.include?(self.position)
        self.moves -= RIGHT_LIMITATIONS if Table::RIGHT_BORDER.include?(self.position)
        self.moves -= LOWER_LIMITATIONS if Table::BOTTOM_BORDER.include?(self.position)
    end

end

module Pawn_Limitations

    WHITE_MOVES = [-16, -9, -8, -7]
    BLACK_MOVES = [7, 8, 9, 16]
    
    def refine_moveset_pawn
        pawn_color_check
        pawn_double_step
        pawn_obstruction
        pawn_borders
        check_friendly
        pawn_eating
        en_passant
        convert_to_squares
    end

    def pawn_color_check
        self.moves -= BLACK_MOVES if self.color == "black"
        self.moves -= WHITE_MOVES if self.color == "white"
    end

    def pawn_double_step
        self.moves -= [16] if self.color == "white" && self.displaced != 0
        self.moves -= [-16] if self.color == "black" && self.displaced != 0
    end

    def pawn_obstruction
        self.moves -= [16] if BoardState.board[self.position + 16] != " "
        self.moves -= [8, 16] if BoardState.board[self.position + 8] != " "
        self.moves -= [-16] if BoardState.board[self.position - 16] != " "
        self.moves -= [-8, -16] if BoardState.board[self.position - 8] != " "
    end

    def pawn_borders
        self.moves -= [7] if Table::LEFT_BORDER.include?(self.position) && self.color == "white"
        self.moves -= [9] if Table::RIGHT_BORDER.include?(self.position) && self.color == "white"
        self.moves -= [-9] if Table::LEFT_BORDER.include?(self.position) && self.color == "black"
        self.moves -= [-7] if Table::RIGHT_BORDER.include?(self.position) && self.color == "black"
    end

    def pawn_eating
        self.moves -= [7] if BoardState.board[self.position + 7] == " "
        self.moves -= [9] if BoardState.board[self.position + 9] == " "
        self.moves -= [-7] if BoardState.board[self.position - 7] == " "
        self.moves -= [-9] if BoardState.board[self.position - 9] == " "
    end

    def en_passant
        if !PastMoves.move_history.tail.value.nil? && self.color == "white"
            pawn = PastMoves.move_history.tail.value[:moved_piece]
            if pawn.class.name == "Pawn" && pawn.displaced == 1
                self.moves += [7] if BoardState.board[self.position - 1] == pawn
                self.moves += [9] if BoardState.board[self.position + 1] == pawn
            end
        elsif !PastMoves.move_history.tail.value.nil? && self.color == "black"
            pawn = PastMoves.move_history.tail.value[:moved_piece]
            if pawn.class.name == "Pawn" && pawn.displaced == 1
                self.moves += [-9] if BoardState.board[self.position - 1] == pawn
                self.moves += [-7] if BoardState.board[self.position + 1] == pawn
            end
        end
    end

end

module Moves

    include Navigation, Check

    def define_moveset
        case self.class.name
        when "King"
            self.moves = self.class::STANDARD_MOVESET.dup
            refine_moveset_king
        when "Queen"
            self.moves = self.class::STANDARD_MOVESET.map { | direction | direction.dup}
            refine_moveset_queen
        when "Bishop"
            self.moves = self.class::STANDARD_MOVESET.map { | direction | direction.dup}
            refine_moveset_bishop
        when "Knight"
            self.moves = self.class::STANDARD_MOVESET.dup
            refine_moveset_knight
        when "Rook"
            self.moves = self.class::STANDARD_MOVESET.map { | direction | direction.dup}
            refine_moveset_rook
        when "Pawn"
            self.moves = self.class::STANDARD_MOVESET.dup
            refine_moveset_pawn
        end
    end

    def check_friendly(moves = self.moves)
        moves.map! do | single_move |
            if BoardState.board[self.position + single_move].class.ancestors.include?(Piece)
                single_move = nil if BoardState.board[self.position + single_move].color == self.color
            end
            single_move
        end
        moves.compact!
    end

    def build_directions
        self.moves.each do | direction |
            unless direction.empty?
                until direction_borders(direction) do
                    if BoardState.board[self.position + direction.last].class.ancestors.include?(Piece)
                        if BoardState.board[self.position + direction.last].color != self.color
                            break
                        elsif BoardState.board[self.position + direction.last].color == self.color
                            direction.pop
                            break
                        end
                    else
                        direction << direction.last + direction.first
                    end
                end
            end
        end
    end

    def direction_borders(direction)
        case direction.first
        when -8
            Table::TOP_BORDER.include?(self.position + direction.last)
        when 8
            Table::BOTTOM_BORDER.include?(self.position + direction.last)
        when -1
            Table::LEFT_BORDER.include?(self.position + direction.last)
        when 1
            Table::RIGHT_BORDER.include?(self.position + direction.last)
        else
            Table::ALL_BORDERS.include?(self.position + direction.last)
        end
    end

    def convert_to_squares
        self.moves.flatten!
        self.moves.map! do | single_move |
            single_move += @position
        end
    end

    def move_piece(destination)
        castling_move_tower(destination) if check_castling(destination)
        log_move(destination)
        en_passant_remove_pawn(destination) if check_en_passant(destination)
        BoardState.board[self.position] = " "
        self.position = destination
        BoardState.board[destination] = self
        self.displaced += 1
    end

    def check_castling(destination)
        return true if self.class.name == "King" && [1, 5, 57, 61].include?(destination) && self.displaced == 0
    end

    def castling_move_tower(destination)
        if self.color == "white"
            if destination == 1
                rook = BoardState.board[0]
                rook.position = 2
                BoardState.board[2] = rook
                BoardState.board[0] = " "
            elsif destination == 5
                rook = BoardState.board[7]
                rook.position = 4
                BoardState.board[4] = rook
                BoardState.board[7] = " "
            end
        elsif self.color == "black"
            if destination == 57
                rook.position = 58
                rook = BoardState.board[56]
                BoardState.board[58] = rook
                BoardState.board[56] = " "
            elsif destination == 61
                rook = BoardState.board[63]
                rook.position = 60
                BoardState.board[60] = rook
                BoardState.board[63] = " "
            end
        end
    end

    def discover_castling(destination)
        return BoardState.board[2], 2 if destination == 1
        return BoardState.board[4], -3 if destination == 5
        return BoardState.board[58], 2 if destination == 57
        return BoardState.board[60], -3 if destination == 61
    end

    def check_en_passant(destination)
        if self.class.name == "Pawn" && BoardState.board[destination] == " " && [-8, 8].any? { | single_move | BoardState.board[destination + single_move].class.name == "Pawn" } && (destination % 8 != self.position % 8)
            return true
        else
            return false
        end
    end

    def en_passant_remove_pawn(destination)
        BoardState.board[destination - 8] = " " if self.color == "white"
        BoardState.board[destination + 8] = " " if self.color == "black"
    end

    def log_move(destination)
        move = {
            :moved_piece => self,
            :distance_traveled => destination - self.position,
        }

        BoardState.board[destination] == " " ? move[:eaten_piece] = nil : move[:eaten_piece] = BoardState.board[destination]

        if check_castling(destination)
            move[:castled] = {
                :rook => discover_castling(destination)[0],
                :distance => discover_castling(destination)[1]
            }
        end

        if check_en_passant(destination)
            move[:en_passant] = {
                :pawn => PastMoves.move_history.tail.value[:moved_piece]
            }
        end

        PastMoves.move_history.append(move)
    end

end