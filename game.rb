require_relative 'board'
require_relative 'player'

class Game
  def initialize(player1, player2)
    @players = { white: player1, black: player2 }
    @board = Board.new
    @display = Display.new(@board)
    @current_player = :white
  end

  def setup!
    @board.populate_pieces!
    player_setup
  end

  def run
    until @board.is_over?
      render
      switch_players if prompt_move
    end
    render
  end

  private

  def announcements
    checkmate = [:white, :black].find { |color| @board.checkmate?(color) }
    if checkmate
      puts "#{checkmate.to_s.capitalize} is checkmated! #{Piece::OP_COLOR[checkmate].capitalize} wins!"
    else
      puts "#{@current_player.capitalize}'s turn."
      check = [:white, :black].find { |color| @board.in_check?(color) }
      puts "#{check.to_s} is in check!" if check
    end
  end

  def render
    @players[@current_player].render
  end

  def player_setup
    @players.each do |_, player|
      player.display = @display
      player.board = @board
    end
  end

  def prompt_move
    @players[@current_player].play_turn
  end

  def switch_players
    @current_player = Piece::OP_COLOR[@current_player]
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(Player.new(:white), Player.new(:black))
  game.setup!
  game.run
end
