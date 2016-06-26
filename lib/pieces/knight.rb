require_relative "base/steppable_piece"

class Knight < SteppablePiece
  START_IDYS = [1, 6]

  def initialize(color, board, pos)
    super(color, board, pos, :knight)
  end

  def move_steps
    [[-1, 2], [-2, 1], [1, 2], [2, 1], [-1, -2], [-2, -1], [1, -2], [2, -1]]
  end
end
