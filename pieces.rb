


class Piece
  attr_accessor :team_color

  def initialize(current_pos, team_color)
    @current_pos = current_pos
    @team_color = team_color
  end

end

class Pawn < Piece

  def initialize(current_pos, team_color, first_move = true)
    @first_move = first_move
    super(current_pos, team_color)
  end

  def board_moves
    x, y = @current_pos
    if team_color == :black

      first_move ? [[x + 1, y], [x + 2, y]] : [[x + 1, y]]

    else

      first_move ? [[x - 1, y], [x - 2, y]] : [[x - 1, y]]

    end
  end


  def conditional_moves
    PAWN_TAKE = [
      [1, 1],
      [1,-2]
    ]
end

class SlidingPiece < Piece

  def board_moves
    positions = []
    x, y = @current_pos
    self.class.DELTAS.each do |delta|
      dx, dy = delta

      step = 1
      moves = []
      while (x + dx * step).between?(0, 7) && (y + dy * step).between?(0, 7)
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
    self.class.DELTAS.each do |delta|
      dx, dy = delta
      if (x + dx).between?(0, 7) && (y + dy).between?(0, 7)
        positions << [x + dx, y + dy]
      end
    end
    positions
  end


end

class Bishop < SlidingPiece

  def move_dirs
    DELTAS = [
      [1,  1],
      [1, -1],
      [-1, 1],
      [-1, -1]
    ]
  end
end

class Rook < SlidingPiece
  def move_dirs
    DELTAS =[
      [0, 1],
      [1, 0],
      [-1, 0],
      [0, -1]
    ]
end

class Queen < SlidingPiece
  def move_dirs
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
end

class Knight < SteppingPiece
  def move_dirs
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
end

class King < SteppingPiece
  def move_dirs
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
end
