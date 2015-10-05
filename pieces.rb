


class Piece
  attr_accessor :team_color

  def initialize(current_pos, team_color)
    @current_pos = start_pos
    @team_color = team_color
  end

end

class SlidingPiece < Piece
  # in board class?
  # def move_to_target?(target) # [row, col]
  #   self.move_dirs.each do |pos|
  #     if target[0] % pos[0] == 0 && target[1] % pos[1] == 0
  #       return true
  #     end
  #   end
  #   false
  # end
  def valid_move?
  end

  def spaces_to_target(target) #for collision
  end

end

class SteppingPiece < Piece

end

class Bishop < SlidingPiece

  def move_dirs
    BISHOP_DELTAS = [
      [1,  1],
      [1, -1],
      [-1, 1],
      [-1, -1]
    ]
  end
end

class Rook < SlidingPiece
  def move_dirs
    ROOK_DELTAS =[
      [0, 1],
      [1, 0],
      [-1, 0],
      [0, -1]
    ]
end

class Queen < SlidingPiece
  def move_dirs
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
end

class Knight < SteppingPiece
  def move_dirs
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
end

class King < SteppingPiece
  def move_dirs
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
end

class Pawn < Piece
  def move_dirs
    PAWN_DELTAS = [
      [1, 0],
      [2, 0],
    ]
  def conditional_moves
    PAWN_TAKE = [
      [1, 1],
      [1,-2]
    ]
end
