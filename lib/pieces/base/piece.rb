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
