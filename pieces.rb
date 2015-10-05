


class Piece
  attr_accessor :team_color

  def initialize(current_pos, team_color)
    @current_post = start_pos
    @team_color = team_color
  end
end

class SlidingPiece < Piece
end

class SteppingPiece < Piece
end

class Bishop < SlidingPiece
  BISHOP_DELTAS = [
    [1, 1 ],
    [1, -1],
    [-1, 1],
    [-1, -1]
  ]
end

class Rook < SlidingPiece
  ROOK_DELTAS =[
    [0, 1],
    [1, 0],
    [-1, 0],
    [0, -1]
  ]
end

class Queen < SlidingPiece
  QUEEN_DELTAS = [
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
  KNIGHT_DELTAS = [
    [ 2,  1],
    [ 2, -1],
    [-2,  1],
    [-2, -1],
    [1 ,  2],
    [1 , -2],
    [-1,  2],
    [-1, -2]
  ]
end

class King < SteppingPiece
  KING_DELTAS = [
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

class Pawn < Piece
end
