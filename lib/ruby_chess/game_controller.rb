require_relative './input_converter'
require_relative 'modules/chess_teams'

class GameController
  def initialize(players, board, move_controller, end_checker)
    @board = board
    @players = players
    @running = false
    @round = 0
    @converter = InputConverter.new
    @end_checker = end_checker
    @move_controller = move_controller
  end

  def start_game
    @running = true
    # Check for deserialize
    game_loop
  end

  def game_loop
    while @running
      p 'yay'

      loop do
        @board.display

        puts 'Choose figure using X Y coordinates'
        puts "Current Team: #{current_player_direction == 1 ? 'Up' : 'Bottom'}"
        player_input = current_player.input
        p player_input
        if player_input == 'save'
          # handle serialization
          p 'Handle serialization'
          next
        end
        figure = @converter.input_to_figure(player_input, @board)

        next if figure.nil? # validator class maybe
        next if figure.direction != current_player_direction

        legal_moves = figure.legal_moves(@board)
        next if legal_moves.length.zero?

        puts 'Choose move'
        puts "Available moves: #{legal_moves}"
        move_input = current_player.input
        move = @converter.input_to_array(move_input)

        next if move.nil?
        next unless legal_moves.include?(move)

        # process move
        @move_controller.handle_move(@board, figure, move)
        @board.display
        break
      end
      handle_after_move
    end
  end

  def handle_after_move
    result = @end_checker.game_status(@board)

    handle_game_win(result) if [ChessTeams::UP_TEAM, ChessTeams::BOTTOM_TEAM].include?(result)
    draw if result.is_a?(Integer) && result.zero?
    next_move
  end

  def current_player
    @players[@round % 2]
  end

  def current_player_direction
    @round.even? ? ChessTeams::UP_TEAM : ChessTeams::BOTTOM_TEAM
  end

  def next_move
    @round += 1
    @board.display
  end

  def handle_game_win(result)
    puts "WIN TEAM: #{result}"
    stop_game
  end

  def draw
    p 'Draw!'
    stop_game
  end

  def stop_game
    @running = false
  end
end
