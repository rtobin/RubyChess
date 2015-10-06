


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
    @name = :pawn
    super(current_pos, team_color)
  end

  def board_moves
    x, y = @current_pos
    if team_color == :black

      first_move ? [[x + 1, y], [x + 2, y]] : ( [[x + 1, y]] if Board.inbounds?([x + dx, y + dy]) )

    else

      first_move ? [[x - 1, y], [x - 2, y]] : ( [[x - 1, y]] if Board.inbounds?([x + dx, y + dy]) )

    end
  end

class SlidingPiece < Piece

  def board_moves
    positions = []
    x, y = @current_pos

    # DELTAS is defined in subclasses
    self.class.DELTAS.each do |delta|
      dx, dy = delta

      step = 1
      moves = []
      while Board.inbounds?([x + dx, y + dy])
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
    self.class.DELTAS.each do |delta|
      dx, dy = delta
      if Board.inbounds?([x + dx, y + dy])
        positions << [x + dx, y + dy]
      end
    end
    positions
  end


end

class Bishop < SlidingPiece
  DELTAS = [
    [1,  1],
    [1, -1],
    [-1, 1],
    [-1, -1]
  ]

  def initialize(current_pos, team_color)
    super
    @name = :bishop
  end
end

class Rook < SlidingPiece
  DELTAS =[
    [0, 1],
    [1, 0],
    [-1, 0],
    [0, -1]
  ]

  def initialize(current_pos, team_color)
    super
    @name = :rook
  end
end

class Queen < SlidingPiece
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

  def initialize(current_pos, team_color)
    super
    @name = :queen
  end
end

class Knight < SteppingPiece
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

  def initialize(current_pos, team_color)
    super
    @name = :knight
  end
end

class King < SteppingPiece
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

  def initialize(current_pos, team_color)
    super
    @name = :king
  end
end
