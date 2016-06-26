require_relative "base/slidable_piece"

class Queen < SlidablePiece
  START_IDYS = [3]

  def initialize(color, board, pos)
    super(color, board, pos, :queen)
  end

  def move_steps
    Piece::DIAGONAL_STEPS + Piece::CARDINAL_STEPS
  end
end
