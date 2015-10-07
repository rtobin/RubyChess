require_relative "board"


class Piece

    DEFAULT_WHITE_POSITIONS = {
      :pawn   => [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]],
      :knight => [[7, 1], [7, 6]],
      :bishop => [[7, 2], [7, 5]],
      :rook   => [[7, 0], [7, 7]],
      :queen  => [[7, 3]],
      :king   => [[7, 4]],
      }

      DEFAULT_BLACK_POSITIONS = {
      :pawn   => [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]],
      :knight => [[0, 1], [0, 6]],
      :bishop => [[0, 2], [0, 5]],
      :rook   => [[0, 0], [0, 7]],
      :queen  => [[0, 3]],
      :king   => [[0, 4]],
      }



    PIECE_UNICODE = {
      king:   ["♚", "♔"],
      queen:  ["♛", "♕"],
      rook:   ["♜", "♖"],
      bishop: ["♝", "♗"],
      knight: ["♞", "♘"],
      pawn:   ["♟", "♙"]

    }


  attr_accessor :color, :name, :current_pos

  def self.create_piece(piece, pos, color)
     case piece
     when :pawn
       Pawn.new(pos, color)
     when :knight
       Knight.new(pos, color)
     when :bishop
       Bishop.new(pos, color)
     when :rook
       Rook.new(pos, color)
     when :queen
       Queen.new(pos, color)
     when :king
       King.new(pos, color)
     end
  end

  def initialize(current_pos, color)
    @current_pos = current_pos
    @color = color
  end

  def unicode
    PIECE_UNICODE[self.class::NAME]
  end

  def dup
    piece = self.class.new(self.current_pos, self.color)
    piece.first_move = self.first_move if self.is_a?(Pawn)
  end


end

class Pawn < Piece
  NAME = :pawn
  attr_reader :first_move

  def initialize(current_pos, color, first_move = true)
    @first_move = first_move
    super(current_pos, color)
  end

  def board_moves
    x, y = @current_pos
    positions = []
    if color == :black
      # positions = unidirectional forward moves and possible attack moves
      # and transitory "first" move for black and white pieces.
      first_move ? positions += [[x + 1, y], [x + 2, y], [x + 1, y + 1], [x + 1, y - 1]]
              :  ( positions += [[x + 1, y], [x + 1, y + 1], [x + 1, y - 1]] )

    else

      first_move ? positions += [[x - 1, y], [x - 2, y], [x - 1, y + 1], [x - 1, y - 1]]
              :  ( positions += [[x - 1, y], [x - 1, y + 1], [x - 1, y - 1]] )

    end

    positions
  end
end

class SlidingPiece < Piece

  def board_moves
    positions = []
    x, y = @current_pos

    # DELTAS is defined in subclasses
    self.class::DELTAS.each do |delta|
      dx, dy = delta

      step = 1
      moves = []
      while Board.inbounds?([x + dx * step, y + dy * step])
        moves << [x + dx * step, y + dy * step]
        step +=1
      end

      positions << moves
    end

    positions
  end

end

class SteppingPiece < Piece

  def board_moves
    positions = []
    x, y = @current_pos

    # DELTAS is defined in subclasses
    self.class::DELTAS.each do |delta|
      dx, dy = delta
      if Board.inbounds?([x + dx, y + dy])
        positions << [x + dx, y + dy]
      end
    end
    positions
  end
end

class Bishop < SlidingPiece
  NAME = :bishop
  DELTAS = [
    [1,  1],
    [1, -1],
    [-1, 1],
    [-1, -1]
  ]


end

class Rook < SlidingPiece
  NAME = :rook
  DELTAS =[
    [0, 1],
    [1, 0],
    [-1, 0],
    [0, -1]
  ]

end

class Queen < SlidingPiece
  NAME = :queen
  DELTAS = [
    [1, 1 ],
    [1, -1],
    [-1, 1],
    [-1, -1],
    [0, 1],
    [1, 0],
    [-1, 0],
    [0, -1]
  ]


end

class Knight < SteppingPiece
  NAME = :knight
  DELTAS = [
    [ 2,  1],
    [ 2, -1],
    [-2,  1],
    [-2, -1],
    [ 1,  2],
    [ 1, -2],
    [-1,  2],
    [-1, -2]
  ]

end

class King < SteppingPiece
  NAME = :king
  DELTAS = [
    [0 ,  1],
    [0 , -1],
    [1 ,  0],
    [-1,  0],
    [ 1,  1],
    [ 1, -1],
    [-1,  1],
    [-1, -1]
  ]
end
