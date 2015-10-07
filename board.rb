require_relative "pieces"
class Board
  DIM = 8

  attr_reader :board

  def self.starting_board
    board = Array.new(DIM) { Array.new(DIM) }

    Piece::DEFAULT_WHITE_POSITIONS.each do |piece, positions|
      positions.each { |pos| board[pos[0]][pos[1]] = Piece.create_piece(piece, pos, :white)}
    end

    Piece::DEFAULT_BLACK_POSITIONS.each do |piece, positions|
      positions.each { |pos| board[pos[0]][pos[1]] = Piece.create_piece(piece, pos, :black)}
    end

    Board.new(board)
  end

  def initialize(board = nil)
    @board = (board ||= self.class.starting_board)
    @king_pieces = get_king_pieces
  end

  def move(start_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
    self[end_pos].current_pos = end_pos
    #some_board[end_pos[0]][end_pos[1]] = some_board[start_pos[0]][start_pos[1]]
    #some_board[start_pos[0]][start_pos[1]] = nil
    #some_board[end_pos[0]][end_pos[1]].current_pos = end_pos
  end

  def valid_move?(start_pos, end_pos)
    # other validation is done in display
    # return false if the move puts oneself in check
    color = self[start_pos].color
    move(start_pos, end_pos)
    result = true
    result = false if in_check?(color)

    #reset
    move(end_pos, start_pos)

    result
  end

  def in_check?(color)
    king_pos = find_king(color)
    (0...DIM).each do |row|
      (0...DIM).each do |col|
        piece = @board[row][col]
        if piece && piece.color != color
          possible_moves(piece).each { |pos| return true if pos == king_pos}
        end
      end
    end

    false
  end

  def find_king(color)
    @king_pieces.each { |piece| return piece.current_pos if piece.color == color}
  end

  def get_king_pieces
    kings = []
    (0...DIM).each do |row|
      (0...DIM).each do |col|
        space = @board[row][col]
        kings << space if space.is_a?(King)
      end
    end

    kings
  end

  def possible_moves(piece)
    some_moves = []
    moves = piece.board_moves
    color = piece.color

    if piece.is_a?(Pawn)
      attacking_moves = moves.pop(2)

      attacking_moves.each do |move|
        target = self[move]
        some_moves << move if target.is_a?(Piece) && target.color != color && Board.inbounds?(move)
      end

      moves.each do |move|
        target = self[move]
        some_moves << move unless target.is_a?(Piece)
      end

    else
      moves.each do |move|

        # stepping move
        if piece.is_a?(SteppingPiece) || piece.is_a?(Pawn)
          target = self[move]
          some_moves << move if !target.is_a?(Piece) || target.color != color

        # sliding move
        elsif piece.is_a?(SlidingPiece)
          move.each do |pos|
            target = self[pos]

            if target.is_a?(Piece)
              some_moves << pos unless target.color == color
              break
            else
              some_moves << pos
            end

          end
        end
      end
    end

    some_moves
  end

  def dup
    @board.map do |row|
      row.map do |space|
        space.is_a?(Piece) ? space.dup : nil
      end
    end
  end



  ## Bounds checking class method##
  def self.inbounds?(pos)
    pos.all? { |i| i.between?(0, 7) }
  end

  ## Bracket Methods ##
  def []=(pos, val)
    row, col = pos
    @board[row][col] = val
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end


## Legacy code ##
  def empty_space?(start_pos)
    return false if empty_spaces.include?(start_pos)
    true
  end

  def empty_spaces
    empty_spaces = []
    (0...DIM).each do |row|
      (0...DIM).each do |col|
        empty_spaces.concat([row, col]) if board[row, col] == "  "
      end
    end
    empty_spaces #filler for "valid spaces"
  end

end


if __FILE__ == $PROGRAM_NAME
  board = Board.starting_board
  piece = board[[6,0]]
  p board.possible_moves(piece)
end
