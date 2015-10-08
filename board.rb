require_relative "pieces"
class Board
  DIM = 8

  attr_reader :grid

  def self.starting_board
    grid = Array.new(DIM) { Array.new(DIM) }

    Piece::DEFAULT_WHITE_POSITIONS.each do |piece, positions|
      positions.each { |pos| grid[pos[0]][pos[1]] = Piece.create_piece(piece, pos, :white)}
    end

    Piece::DEFAULT_BLACK_POSITIONS.each do |piece, positions|
      positions.each { |pos| grid[pos[0]][pos[1]] = Piece.create_piece(piece, pos, :black)}
    end

    Board.new(grid)
  end

  def initialize(grid)
    @grid = grid
    @king_pieces = get_king_pieces
  end

  def move(start_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[end_pos].change_pos(end_pos)
    self[start_pos] = nil

  end

  def valid_move?(piece, end_pos)
    # other validation is done in display
    # return false if the move puts oneself in check
    color = piece.color
    start_pos = piece.current_pos
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
        piece = @grid[row][col]
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
        space = @grid[row][col]
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
    @grid.map do |row|
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
    @grid[row][col] = val
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

end
