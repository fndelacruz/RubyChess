require_relative "base/piece"

class Pawn < Piece
  START_IDXS = { black: 1, white: 6 }
  START_IDYS = (0..7)

  def initialize(color, board, pos)
    super(color, board, pos, :pawn)
  end

  def moves
    moves = []

    fwd = [@pos[0] + steps[:forward][0], @pos[1] + steps[:forward][1]]
    if @board.in_bounds?(fwd) && @board[fwd].is_a?(NullPiece)
      moves << fwd
      moves << double_step if @board[double_step].is_a?(NullPiece) && first_move?
    end

    steps[:diagonals].each do |diag_step|
      diag_pos = [@pos[0] + diag_step[0], @pos[1] + diag_step[1]]
      next unless @board.in_bounds?(diag_pos)
      moves << diag_pos if is_enemy?(@board[diag_pos])
    end

    moves
  end

  private

  def steps
    forward = @color == :white ? -1 : 1
    { forward: [forward, 0], diagonals: [[forward, -1], [forward, 1]] }
  end

  def double_step
    double_step = [steps[:forward][0] * 2, 0]
    [@pos[0] + double_step[0], @pos[1]]
  end

  def first_move?
    @pos[0] == Pawn::START_IDXS[@color]
  end
end
