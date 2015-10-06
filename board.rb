require_relative "pieces"

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

    # [0,  1].each { |i| board[i].map! { |el| el = Piece.new(:black) } }
    # [-2, -1].each { |i| board[i].map! { |el| el = Piece.new(:white) } }
    Board.new(board)
    #puts board
  end

  def initialize(board = nil)
    @board = (board ||= self.class.starting_board)
  end


  def move_logic(start_pos, end_pos)

  end

## Bounds checking class method##
  def self.inbounds?(pos)
    pos.all { |i| i.between?(0, 7) }
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
