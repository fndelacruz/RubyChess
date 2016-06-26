require_relative "piece"

class SteppablePiece < Piece
  def initialize(color, board, pos, value)
    super
  end

  def moves
    moves = move_steps.map { |move| [@pos[0] + move[0], @pos[1] + move[1]] }
    moves.select { |move| @board.in_bounds?(move) && !is_friendly?(@board[move]) }
  end
end
