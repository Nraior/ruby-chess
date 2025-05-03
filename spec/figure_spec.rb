require './lib/ruby_chess/figure'
describe Figure do
  let(:figure_controller) { double('figure_controller', { symbol: '♙' }) }
  subject(:figure) { described_class.new(0, 1, figure_controller) }

  describe '#proceed_move' do
    it('updates move counter') do
      expect { figure.proceed_move(1, 0) }.to change { figure.moves_count }.by(1)
    end

    it('updates x, y integer coordinates') do
      expect { figure.proceed_move(4, 3) }.to change { [figure.x, figure.y] }.to([4, 3])
    end

    it('does not updates x & y that is not integer') do
      expect { figure.proceed_move('2', '5') }.not_to(change { [figure.x, figure.y] })
    end

    it('updates last move') do
      expect { figure.proceed_move(3, 3) }.to change { figure.position_history }.to([[0, 1]])
    end
  end
end
