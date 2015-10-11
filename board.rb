require_relative "pieces"
require "byebug"
class Board
  DIM = 8
  PIECE_POINTS = {
    pawn:   1.0,
    knight: 2.4,
    bishop: 4.0,
    rook:   6.4,
    queen:  10.4,
    king:   3.0
  }

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
    @movehistory = []
  end

  def move(start_pos, end_pos)
    #save_piece = self[end_pos] if self[end_pos].is_a?(Piece)
    self[end_pos] = self[start_pos]
    self[end_pos].change_pos(end_pos)
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
