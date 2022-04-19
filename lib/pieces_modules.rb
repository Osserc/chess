module King_Limitations

    UPPER_LIMITATIONS = [-9, -8, -7]
    LEFT_LIMITATIONS = [-9, -1, 7]
    RIGHT_LIMITATIONS = [-7, 1, 9]
    LOWER_LIMITATIONS = [9, 8, 7]

    def refine_moveset_king
        king_borders
        check_friendly
        check_castling
        convert_to_squares
    end

    def king_borders
        self.moves -= UPPER_LIMITATIONS if Table::TOP_BORDER.include?(self.position) 
        self.moves -= LEFT_LIMITATIONS if Table::LEFT_BORDER.include?(self.position)
        self.moves -= RIGHT_LIMITATIONS if Table::RIGHT_BORDER.include?(self.position)
        self.moves -= LOWER_LIMITATIONS if Table::BOTTOM_BORDER.include?(self.position)
    end

    def check_castling
        if @turn.odd? && self.displaced == 0
            if @board[0].class.ancestors.include?(Piece)
                self.moves += [-2] if @board[0].displaced == 0 && @board[1] == " " && @board[2] == " " && [1, 2, self.position].none? { | square | generate_threatened_squares(collect_set("black")).include?(square) }
            end
            if @board[7].class.ancestors.include?(Piece)
                self.moves += [2] if @board[7].displaced == 0 && @board[4] == " " && @board[5] == " " && @board[6] == " " && [self.position, 4, 5].none? { | square | generate_threatened_squares(collect_set("black")).include?(square) }
            end
        elsif !@turn.odd? && self.displaced == 0
            if board[56].class.ancestors.include?(Piece)
                self.moves += [-2] if @board[56].displaced == 0 && @board[57] == " " && @board[58] == " " && [57, 58, self.position].none? { | square | generate_threatened_squares(collect_set("black")).include?(square) }
            end
            if @board[63].class.ancestors.include?(Piece)
                self.moves += [2] if @board[63].displaced == 0 && @board[60] == " " && @board[61] == " " && @board[62] = " " && [self.position, 60, 61].none? { | square | generate_threatened_squares(collect_set("black")).include?(square) }
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
    LOWER_LIMITATIONS = [[-8]]

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
        check_friendly
        pawn_eating
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
        self.moves -= [16] if self.board[self.position + 16] != " "
        self.moves -= [8] if self.board[self.position + 8] != " "
        self.moves -= [-16] if self.board[self.position - 16] != " "
        self.moves -= [-8] if self.board[self.position - 8] != " "
    end

    def pawn_eating
        self.moves -= [7] if self.board[self.position + 7] == " "
        self.moves -= [9] if self.board[self.position + 9] == " "
        self.moves -= [-7] if self.board[self.position - 7] == " "
        self.moves -= [-9] if self.board[self.position - 9] == " "
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
            if self.board[self.position + single_move].class.ancestors.include?(Piece)
                single_move = nil if self.board[self.position + single_move].color == self.color
            end
            single_move
        end
        moves.compact!
    end

    def special_borders

    end

    def build_directions
        self.moves.each do | direction |
            unless direction.empty?
                until direction_borders(direction) do
                    if self.board[self.position + direction.last].class.ancestors.include?(Piece)
                        if self.board[self.position + direction.last].color != self.color
                            break
                        elsif self.board[self.position + direction.last].color == self.color
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
        log_move(destination)
        self.board[self.position] = " "
        self.position = destination
        self.board[destination] = self
    end

    def log_move(destination)
        move = {
            :moved_piece => self,
            :distance_traveled => destination - self.position,
        }
        self.board[destination] == " " ? move[:eaten_piece] = nil : move[:eaten_piece] = self.board[destination]
        self.move_history.append(move)
    end

end