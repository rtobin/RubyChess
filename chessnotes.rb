'''
Players/AI
  - has "pieces" array with all pieces (kings as zeroeth piece)
  - has method "available_moves" that checks the available moves
    of each piece
  - if king piece variable "checked" is true, must move king
    - if king has no available moves...checkmate
AI
 - has "prev_move_list" that stores array of moves (structs)
  this allows the AI to undo


Piece
  - after move, checks next available moves for piece
  - if next available moves includes enemy king, place that king in check

Board


    white chess king	♔	U+2654	&#9812;
    white chess queen	♕	U+2655	&#9813;
    white chess rook	♖	U+2656	&#9814;
    white chess bishop	♗	U+2657	&#9815;
    white chess knight	♘	U+2658	&#9816;
    white chess pawn	♙	U+2659	&#9817;
    black chess king	♚	U+265A	&#9818;
    black chess queen	♛	U+265B	&#9819;
    black chess rook	♜	U+265C	&#9820;
    black chess bishop	♝	U+265D	&#9821;
    black chess knight	♞	U+265E	&#9822;
    black chess pawn	♟	U+265F	&#9823;

'''
class Board
  

  def valid_moves(piece)
    some_moves = []
    moves = piece.board_moves
    color = piece.color
    moves.each do |move|

      # stepping move
      if move.size == 1
        space = self[move[0]]
        some_moves << move[0] unless space.is_a?(Piece) && space. color == color

      # sliding move
      else
        blocked = false
        move.each do |pos, i|
          space = self[pos]
          if space.is_a?(Piece)
            blocked = true
            some_moves << pos unless space.color == color
          else
            some_moves << pos
          end
        end
      end

      some_moves
    end
  end

  def dup
    @board.map do |row|
      row.map do |space|
        space.dup if space
      end
    end
  end

end

class Piece
  def dup
    piece = self.class.new(self.current_pos, self.team_color)
    piece.first_move = self.first_move if self.is_a?(Pawn)
  end
end
