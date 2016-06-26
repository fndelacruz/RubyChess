require_relative "piece"

class SlidablePiece < Piece
  def initialize(color, board, pos, value)
    super
  end

  def moves
    moves = []
    move_steps.each do |move_dir|
      new_pos = [@pos[0] + move_dir[0], @pos[1] + move_dir[1]]
      until !@board.in_bounds?(new_pos) || is_friendly?(@board[new_pos])
        moves << new_pos.dup
        break if is_enemy?(@board[new_pos])
        new_pos = [new_pos[0] + move_dir[0], new_pos[1] + move_dir[1]]
      end
    end
    moves
  end
end
