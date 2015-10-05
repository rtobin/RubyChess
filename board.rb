require_relative "pieces"

class Board

  def self.starting_board
    board = Array.new(8) { Array.new(8) {"  "} }
    [0,  1].each { |i| board[i].map! { |el| el = Piece.new(:black) } }
    [-2, -1].each { |i| board[i].map! { |el| el = Piece.new(:white) } }

    Board.new(board)
  end

  def initialize(board = nil)
    @board = (board ||= self.class.starting_board)
  end


  def move_logic(start_pos, end_pos)
    raise "No piece there!" if board[start_pos].empty?
    raise "Cannot move there!" unless board[end_pos].empty? # check for good moves
    @board[start_pos]
    @board[end_pos] = @board[start_pos]
    @board[start_pos] = nil # unless eating
  end

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

  def []=(pos, val)
    row, col = pos
    @board[row][col] = val
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end
end
