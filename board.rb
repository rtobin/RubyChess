require_relative "pieces"
class Board
  DIM = 8

  attr_reader :grid, :dead_pieces, :move_history

  class << self

    def starting_board
      grid = Array.new(DIM) { Array.new(DIM) }

      Piece::DEFAULT_WHITE_POSITIONS.each do |piece, positions|
        positions.each { |pos| grid[pos[0]][pos[1]] = Piece.create_piece(piece, pos, :white)}
      end

      Piece::DEFAULT_BLACK_POSITIONS.each do |piece, positions|
        positions.each { |pos| grid[pos[0]][pos[1]] = Piece.create_piece(piece, pos, :black)}
      end

      Board.new(grid)
    end

    def load_move_history(move_history)
      board = starting_board
      move_history.each do |go|
        move(*go)
      end

      board
    end

  end


  def initialize(grid)
    @grid = grid
    @king_pieces = get_king_pieces
    @dead_pieces = []
    @move_history = []
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]
    if piece.is_a?(King) && piece.first_move

      if end_pos == [start_pos[0], start_pos[1] - 2]
        # castle left
        rook_piece = self[[start_pos[0], start_pos[1] - 4]]
        rook_piece.change_pos([start_pos[0], start_pos[1] - 2])
        self[[start_pos[0], start_pos[1] - 2]] = rook_piece
        self[[start_pos[0], start_pos[1] - 4]] = nil

      elsif end_pos == [start_pos[0], start_pos[1] + 2]
        # castle right
        rook_piece = self[[start_pos[0], start_pos[1] + 3]]
        rook_piece.change_pos([start_pos[0], start_pos[1] + 1])
        self[[start_pos[0], start_pos[1] + 1]] = rook_piece
        self[[start_pos[0], start_pos[1] + 3]] = nil
      end
    end

    @move_history << [start_pos, end_pos]
    @dead_pieces << self[end_pos] if self[end_pos].is_a?(Piece)
    piece.change_pos(end_pos)
    self[end_pos] = piece
    self[start_pos] = nil


    #return save_piece
  end

  def valid_move?(piece, end_pos)
    # other validation is done in display
    # return false if the move puts oneself in check
    return false unless piece.is_a?(Piece)
    trial_board = dup
    color = piece.color
    start_pos = piece.current_pos
    trial_board.move(start_pos, end_pos)
    ! trial_board.in_check?(color)
  end

  def valid_moves(piece)
    possible_moves(piece).select { |move| valid_move?(piece, move) }
  end

  def all_valid_moves(color)
    pieces = grid.flatten.select { |square| square.is_a?(Piece) && square.color == color}
    pieces.inject([]) do |acc, piece|
      acc + valid_moves(piece).map { |end_pos| [piece.current_pos, end_pos]}
    end
  end

  def checkmate?(color)
    piece_moves = []
    if in_check?(color)
      (0...DIM).each do |row|
        (0...DIM).each do |col|
          piece = @grid[row][col]
          if piece.is_a?(Piece) && piece.color == color
            piece_moves += possible_moves(piece).select { |move| valid_move?(piece, move) }
          end
        end
      end

      piece_moves.empty?

    else
      false
    end
  end

  def in_check?(color)
    king_pos = find_king(color)
    (0...DIM).each do |row|
      (0...DIM).each do |col|
        piece = @grid[row][col]
        if piece.is_a?(Piece) && piece.color != color
          possible_moves(piece).each do |pos|

            return true if pos == king_pos #&& valid_move?(piece, pos)
          end
        end
      end
    end

    false
  end

  def find_king(color)
    @king_pieces.each { |piece| return piece.current_pos if piece.color == color }
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

    # check if castle is possible and add to moves list
    if piece.is_a?(King) && piece.first_move
      pos = piece.current_pos
      left_rook = self[[pos[0], pos[1] - 4]]
      right_rook = self[[pos[0], pos[1] + 3]]

      if self[[pos[0], pos[1] + 1]].nil? &&
           self[[pos[0], pos[1] + 2]].nil? &&
           right_rook.is_a?(Rook) && right_rook.first_move
        some_moves << [pos[0], pos[1] + 2]
      end
      if self[[pos[0], pos[1] - 1]].nil? &&
           self[[pos[0], pos[1] - 2]].nil? &&
           self[[pos[0], pos[1] - 3]].nil? &&
           left_rook.is_a?(Rook) && left_rook.first_move
        some_moves << [pos[0], pos[1] - 2]
      end
    end
    some_moves#.select { |move| valid_move?(piece, move) }
  end



  def dup
    dup_board = @grid.map do |row|
      row.map do |space|
        space.is_a?(Piece) ? space.dup : nil
      end
    end

    Board.new(dup_board)
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
