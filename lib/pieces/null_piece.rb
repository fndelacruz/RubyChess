require_relative "base/piece"

class NullPiece < Piece
  def initialize
  end

  def to_s
    "   "
  end

  def moves
    []
  end
end
