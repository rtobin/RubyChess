require_relative "pieces"
require "byebug"
class Board
  attr_reader :board

  # Do BOARD_SIZE = 8, then anywhere there is a 7, replace with BOARD_SIZE -1 OR (0...BOARD_SIZE)
  def self.starting_board
    board = Array.new(8) { Array.new(8) {"  "} }

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
  end

  def move
  end

  def possible_moves(piece)
    byebug
    some_moves = []
    moves = piece.board_moves
    color = piece.color

    if piece.is_a?(Pawn) # Board.inbounds? called here instead of Pieces because we are dumb
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
          blocked = false
          move.each do |pos|
            target = self[pos]

            if target.is_a?(Piece)
              blocked = true
              some_moves << pos unless target.color == color
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
        space.dup if space
      end
    end
  end

  def valid_move?(start_pos, end_pos)

  end

## Bounds checking class method##
  def self.inbounds?(pos)
    pos.all? { |i| i.between?(0, 7) }
  end




## Legacy software ##
  def empty_space?(start_pos)
    return false if empty_spaces.include?(start_pos)
    true
  end

  def empty_spaces
    empty_spaces = []
    (0..7).each do |row|
      (0..7).each do |col|
        empty_spaces.concat([row, col]) if board[row, col] == "  "
      end
    end
    empty_spaces #filler for "valid spaces"
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
end


if __FILE__ == $PROGRAM_NAME
  board = Board.starting_board
  piece = board[[6,0]]
  p board.possible_moves(piece)
end
