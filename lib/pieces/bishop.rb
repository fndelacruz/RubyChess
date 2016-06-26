require_relative "base/slidable_piece"

class Bishop < SlidablePiece
  START_IDYS = [2, 5]

  def initialize(color, board, pos)
    super(color, board, pos, :bishop)
  end

  def move_steps
    Piece::DIAGONAL_STEPS
  end
end
