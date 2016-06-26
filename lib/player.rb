class Player
  attr_accessor :display, :board

  def initialize(color)
    @color = color
  end

  def play_turn
    choose_piece
    choose_destination
  end

  def render
    @display.render
    announcements
  end

  def announcements
    checkmate = [:white, :black].find { |color| @board.checkmate?(color) }
    if checkmate
      puts "#{checkmate.to_s.capitalize} is checkmated! #{Piece::OP_COLOR[checkmate].capitalize} wins!"
    else
      puts "#{@color.capitalize}'s turn."
      check = [:white, :black].find { |color| @board.in_check?(color) }
      puts "#{check.capitalize} is in check!" if check
    end
  end

  def is_enemy?(piece)
    piece.color == Piece::OP_COLOR[@color]
  end

  private

  def choose_piece
    begin
      render until chosen_pos = @display.get_input
      chosen_piece = @board[chosen_pos]
      if chosen_piece.is_a?(NullPiece)
        raise TileSelectionError.new "Error: Empty tile selected!"
      elsif is_enemy?(chosen_piece)
        raise TileSelectionError.new "Error: Can't select enemy piece!"
      else
        @board.selected = chosen_pos
        render
      end
    rescue TileSelectionError => e
      puts e
      retry
    end
  end

  def choose_destination
    begin
      render until destination_pos = @display.get_input
      piece = @board.selected_piece
      if destination_pos == @board.selected
        @board.selected = nil
        return
      end
      unless @board.selected_piece.moves.include?(destination_pos)
        raise IllegalMoveError.new "Error: #{piece.name} can't move there!"
      end
      unless @board.selected_piece.valid_moves.include?(destination_pos)
        raise IllegalMoveError.new "Error: Can't move self into check!"
      end
    rescue IllegalMoveError => e
      puts e
      retry
    end
    @board.move_piece!(@board.selected, destination_pos)
    true
  end
end

class TileSelectionError < StandardError
end

class IllegalMoveError < StandardError
end
