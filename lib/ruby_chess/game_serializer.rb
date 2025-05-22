require 'oj'
class GameSerializer
  def save?(input)
    input.is_a?(String) && input.chomp.downcase == 'save'
  end

  def save_game(board, players, round)
    obj = { board: board, players: players, round: round }
    serialize(obj)
  end

  def serialize(obj)
    puts 'Saving the game!'
    msg = Oj.dump(obj)

    begin
      File.open('game.progress', 'w') do |file|
        file << msg
      end
    rescue StandardError
      puts 'Error during saving!'
    end
  end

  def deserialize
    return unless save_exists?

    begin
      Oj.load(File.read('game.progress'))
    rescue StandardError
      puts 'Error during loading'
    end
  end

  def save_exists?
    File.exist?('game.progress')
  end

  def load?(input)
    input.is_a?(String) && input.chomp.downcase == 'y' || input.chomp.downcase == 'yes'
  end
end
