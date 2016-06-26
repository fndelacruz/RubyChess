class Piece
  ICONS = {
    white: { bishop: '♗', rook: '♖', queen: '♕', knight: '♘', king: '♔', pawn: '♙' },
    black: { bishop: '♝', rook: '♜', queen: '♛', knight: '♞', king: '♚', pawn: '♟' }
  }
  CARDINAL_STEPS = [[-1, 0], [1, 0], [0, -1], [0, 1]]
  DIAGONAL_STEPS = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
  START_IDXS = { black: 0, white: 7 }
  OP_COLOR = { black: :white, white: :black }

  attr_reader :color
  attr_accessor :pos, :board

  def initialize(color, board, pos, value)
    @color = color
    @board = board
    @pos = pos
    @value = value
  end

  def valid_moves
    moves.select { |move| !move_into_check?(move) }
  end

  def move_into_check?(move)
    bdup = @board.deep_dup
    bdup.move_piece!(@pos, move)
    bdup.in_check?(@color)
  end

  def to_s
    " #{Piece::ICONS[@color][@value]} "
  end

  def is_enemy?(piece)
    piece.color == Piece::OP_COLOR[@color]
  end

  def is_friendly?(piece)
    @color == piece.color
  end

  def name
    "#{@color.capitalize} #{@value}"
  end
end

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

class Bishop < SlidablePiece
  START_IDYS = [2, 5]

  def initialize(color, board, pos)
    super(color, board, pos, :bishop)
  end

  def move_steps
    Piece::DIAGONAL_STEPS
  end
end

class Rook < SlidablePiece
  START_IDYS = [0, 7]

  def initialize(color, board, pos)
    super(color, board, pos, :rook)
  end

  def move_steps
    Piece::CARDINAL_STEPS
  end
end

class Queen < SlidablePiece
  START_IDYS = [3]

  def initialize(color, board, pos)
    super(color, board, pos, :queen)
  end

  def move_steps
    Piece::DIAGONAL_STEPS + Piece::CARDINAL_STEPS
  end
end

class SteppablePiece < Piece
  def initialize(color, board, pos, value)
    super
  end

  def moves
    moves = move_steps.map { |move| [@pos[0] + move[0], @pos[1] + move[1]] }
    moves.select { |move| @board.in_bounds?(move) && !is_friendly?(@board[move]) }
  end
end

class King < SteppablePiece
  START_IDYS = [4]

  def initialize(color, board, pos)
    super(color, board, pos, :king)
  end

  def move_steps
    Piece::DIAGONAL_STEPS + Piece::CARDINAL_STEPS
  end
end

class Knight < SteppablePiece
  START_IDYS = [1, 6]

  def initialize(color, board, pos)
    super(color, board, pos, :knight)
  end

  def move_steps
    [[-1, 2], [-2, 1], [1, 2], [2, 1], [-1, -2], [-2, -1], [1, -2], [2, -1]]
  end
end

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
