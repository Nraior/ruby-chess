require_relative './input_converter'
require_relative 'modules/chess_teams'

class GameController
  def initialize(players, board, move_controller, end_checker, game_serializer)
    @board = board
    @players = players
    @running = false
    @round = 0
    @converter = InputConverter.new
    @end_checker = end_checker
    @serializer = game_serializer
    @move_controller = move_controller
  end

  def start_game
    @running = true
    # Check for deserialize
    ask_for_load
    game_loop
  end

  def ask_for_load
    return unless @serializer.save_exists?

    puts 'Load game? Y for yes'
    load_input = current_player.input
    handle_game_load if @serializer.load?(load_input)
  end

  def game_loop
    while @running
      @board.display
      loop do
        puts 'Choose figure using X Y coordinates'
        puts "Current Team: #{current_player_direction == 1 ? 'Up' : 'Bottom'}"
        player_input = current_player.input

        next if handle_game_save(player_input)

        p player_input

        figure = @converter.input_to_figure(player_input, @board)

        legal_moves = figure&.legal_moves(@board)
        next if figure.nil? || figure.direction != current_player_direction || legal_moves.empty?

        puts 'Choose move'
        puts "Available moves: #{legal_moves}"
        move_input = current_player.input
        move = @converter.input_to_array(move_input)

        next if move.nil?
        next unless legal_moves.include?(move)

        # process move
        @move_controller.handle_move(@board, figure, move)
        break
      end
      handle_after_move
    end
  end

  def handle_game_save(player_input)
    if @serializer.save?(player_input)
      @serializer.save_game(@board, @players, @round)
      return true
    end
    false
  end

  def handle_game_load
    obj = @serializer.deserialize
    return if obj.nil?

    @running = true

    @board = obj[:board]
    @players = obj[:players]
    @round = obj[:round]
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
