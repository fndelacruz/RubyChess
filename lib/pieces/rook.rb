require_relative "base/slidable_piece"

class Rook < SlidablePiece
  START_IDYS = [0, 7]

  def initialize(color, board, pos)
    super(color, board, pos, :rook)
  end

  def move_steps
    Piece::CARDINAL_STEPS
  end
end
