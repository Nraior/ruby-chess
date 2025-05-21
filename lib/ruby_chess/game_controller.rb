require_relative './input_converter'
class GameController
  def initialize(players, board)
    @board = board
    @players = players
    @running = false
    @round = 0
    @converter = InputConverter.new
  end

  def start_game
    @running = true
    game_loop
  end

  def game_loop
    while @running
      p 'yay'

      while true
        @board.display

        player_input = current_player.input

        figure = @converter.input_to_figure(player_input, @board)
        next if figure.nil? # validator class maybe

        available_moves = figure.available_moves(@board)
        next if available_moves.length == 0

        p "available moves: #{figure.available_moves(@board)}"

        move_input = current_player.input
        move = @converter.input_to_array(move_input)

        next if move.nil?
        next unless available_moves.include?(move)

        p 'VALID MOVE, YAY'

        # process move
        #
        # validate used move
        # "We ve got valid figure, so"
        @board.display

      end
      # validate input

      next_move
    end
  end

  def current_player
    @players[@round % 2]
  end

  def next_move
    @round += 1
    @board.display
  end

  def check_game_end
    game_won?
  end

  def game_won?
    false
  end

  def handle_game_win
    p 'game win'
    stop_game
  end

  def game_draw?
    false
  end

  def draw
    p 'draw'
    stop_game
  end

  def stop_game
    @running = false
  end
end
