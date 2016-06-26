require_relative "base/steppable_piece"

class King < SteppablePiece
  START_IDYS = [4]

  def initialize(color, board, pos)
    super(color, board, pos, :king)
  end

  def move_steps
    Piece::DIAGONAL_STEPS + Piece::CARDINAL_STEPS
  end
end
