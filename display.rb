require "colorize"
require_relative "cursorable"

class Display
  include Cursorable

  COLORS = {
    cursor: :light_green,
    white_tile: :blue,
    black_tile: :light_black,
    selected_piece: :red,
    selected_bg: :cyan,
    potential_move: :light_magenta
  }

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
  end

  def build_grid
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def render
    system("clear")
    alpha_borders
    build_grid.each_with_index { |row, idx| puts "#{8 - idx} #{row.join} #{8 - idx}" }
    alpha_borders
    puts
  end

  private

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    color = :white
    if [i, j] == @cursor_pos
      bg = Display::COLORS[:cursor]
      color = Display::COLORS[:selected_piece] if [i, j] == @board.selected
    elsif [i, j] == @board.selected
      bg = Display::COLORS[:selected_bg]
      color = Display::COLORS[:selected_piece]
    elsif @board.selected
      if @board.selected_piece.moves.include?([i, j])
        bg = Display::COLORS[:potential_move]
      elsif (i + j).odd?
        bg = Display::COLORS[:black_tile]
      else
        bg = Display::COLORS[:white_tile]
      end
    else
      if @board[@cursor_pos].moves.include?([i, j])
        bg = Display::COLORS[:potential_move]
      elsif (i + j).odd?
        bg = Display::COLORS[:black_tile]
      else
        bg = Display::COLORS[:white_tile]
      end
    end
    { background: bg, color: color }
  end

  def alpha_borders
    print "  "
    8.times { |idx| print " #{('a'.ord + idx).chr} "}
    puts
  end
end
