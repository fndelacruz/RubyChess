require_relative "display"
require_relative "pieces"

class Board
  attr_accessor :selected
  attr_reader :grid

  def initialize(grid = nil)
    @grid = grid || Array.new(8) { Array.new (8) { NullPiece.new } }
    @selected = nil
  end

  def populate_pieces!
    populate_pawns!
    populate_nonpawns!
  end

  def move_piece!(start_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.new
    self[end_pos].pos = end_pos
    @selected = nil
  end

  def in_check?(color)
    return unless king(color)
    enemy_pieces = pieces(Piece::OP_COLOR[color])
    enemy_pieces.map(&:moves).any? do |moveset|
      moveset.include?(king(color).pos)
    end
  end

  def checkmate?(color)
    in_check?(color) && pieces(color).map(&:valid_moves).all?(&:empty?)
  end

  def pieces(color)
    @grid.flatten.select { |piece| piece.color == color }
  end

  def king(color)
    @grid.flatten.find { |piece| piece.is_a?(King) && piece.color == color }
  end

  def is_over?
    [:white, :black].any? { |color| checkmate?(color) }
  end

  def rows
    @grid
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos,val)
    @grid[pos[0]][pos[1]] = val
  end

  def in_bounds?(pos)
    dim = @grid.length
    pos.all? { |coord| (0...dim).include?(coord) }
  end

  def selected_piece
    self[@selected]
  end

  def deep_dup
    grid_dup = @grid.map { |row| row.map { |piece| piece.dup } }
    board_dup = Board.new(grid_dup)
    grid_dup.flatten.each { |piece| piece.board = board_dup }
    board_dup
  end

  private

  def populate_pawns!
    Pawn::START_IDXS.each do |color, idx|
      Pawn::START_IDYS.each do |idy|
        self[[idx, idy]] = Pawn.new(color, self, [idx, idy])
      end
    end
  end

  def populate_nonpawns!
    [Rook, Knight, Bishop, Queen, King].each do |piece|
      [:white, :black].each do |color|
        piece::START_IDYS.each do |idy|
          pos = [piece::START_IDXS[color], idy]
          self[pos] = piece.new(color, self, pos)
        end
      end
    end
  end
end
