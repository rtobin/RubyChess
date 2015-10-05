require_relative "pieces"

class Board

  def self.starting_board
    board = Array.new(8) { Array.new(8) }
    [0, 1 , -2, -1].each do |i|
      board[i].map! { |el| el = Piece.new } # choose colors and pieces later
    end

    Board.new(board)
  end

  def initialize(board = nil)
    @board = (board ||= self.class.starting_board)
  end

  def []=(pos, val)
    x, y = pos
    @board[x][y] = val
  end

  def [](pos)
    x, y = pos
    @board[x][y]
  end

  def move(start_pos, end_pos)
    raise "No piece there!" if board[start_pos].empty?
    raise "Cannot move there!" unless board[end_pos].empty? # check for good moves
    @board[end_pos] = @board[start_pos]
    @board[start_pos] = nil # unless eating       
  end
end
