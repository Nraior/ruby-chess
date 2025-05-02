require './lib/ruby_chess/pawn'
describe Pawn do
  subject(:pawn) { described_class.new(1, 3, -1) }
  let(:another_figure) { double('figure', { occupying: true }) }
  let(:empty_field) { double('empty_field', { occupying: nil }) }
  let(:small_board) { double('small_board') }
  describe '#available_moves' do
    before do
      allow(small_board).to receive(:fields).and_return([[nil, another_figure, nil],
                                                         [nil, another_figure, nil],
                                                         [nil, another_figure, nil],
                                                         [nil, pawn, nil]])
      allow(small_board).to receive(:width).and_return(3)
      allow(small_board).to receive(:height).and_return(4)
      allow(small_board).to receive(:valid_move?).and_return(true)
    end

    context('when its blocked and pawn is at the bottom') do
      it('returns nothing') do
        available_moves = pawn.available_moves(small_board)
        expect(available_moves).to eq([])
      end
    end

    context('when its blocked and pawn is at the top') do
      subject(:pawn) { described_class.new(1, 0, 1) }

      before do
        allow(small_board).to receive(:fields).and_return([[nil, pawn, nil],
                                                           [nil, another_figure, nil],
                                                           [nil, another_figure, nil],
                                                           [nil, another_figure, nil]])
      end
      it('returns nothing') do
        available_moves = pawn.available_moves(small_board)
        expect(available_moves).to eq([])
      end
    end

    context('when its first move') do
      it('returns forward & two_forward moves') do
      end
    end

    context 'when it has en passant available' do
      it('returns en passant move')
    end
  end
end
