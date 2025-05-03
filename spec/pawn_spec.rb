require './lib/ruby_chess/pawn'
describe Pawn do
  subject(:pawn) { described_class.new(1, 3, -1) }
  let(:another_figure) { double('figure', { occupying: true }) }
  let(:empty_field) { double('empty_field', { occupying: nil }) }
  let(:board) { double('board') }
  describe '#available_moves' do
    before do
      allow(board).to receive(:fields).and_return([[nil, another_figure, nil],
                                                   [nil, another_figure, nil],
                                                   [empty_field, another_figure, empty_field],
                                                   [nil, pawn, nil]])
      allow(board).to receive(:width).and_return(3)
      allow(board).to receive(:height).and_return(4)
      allow(board).to receive(:valid_move?).and_return(true)
    end

    context('when its blocked and pawn is at the bottom') do
      it('returns nothing') do
        available_moves = pawn.available_moves(board)
        expect(available_moves).to eq([])
      end
    end

    context('when its blocked and pawn is at the top') do
      subject(:pawn) { described_class.new(1, 0, 1) }

      before do
        allow(board).to receive(:fields).and_return([[nil, pawn, nil],
                                                     [empty_field, another_figure, empty_field],
                                                     [empty_field, another_figure, empty_field],
                                                     [nil, another_figure, nil]])
      end
      it('returns nothing') do
        available_moves = pawn.available_moves(board)
        expect(available_moves).to eq([])
      end
    end

    context('when its first move and forward fields are free') do
      before do
        allow(board).to receive(:fields).and_return([[nil, nil, nil],
                                                     [nil, empty_field, nil],
                                                     [empty_field, empty_field, empty_field],
                                                     [nil, pawn, nil]])
      end
      it('returns forward & two_forward moves') do
        result = pawn.available_moves(board)
        expect(result).to eq([[1, 2], [1, 1]])
      end
    end

    context 'when its second move and forward field is available ' do
      before do
        allow(board).to receive(:fields).and_return([[nil, nil, nil],
                                                     [empty_field, empty_field, empty_field],
                                                     [empty_field, empty_field, empty_field],
                                                     [nil, pawn, nil]])
        allow(pawn).to receive(:moves_count).and_return(1)
      end

      it 'returns forward field' do
        result = pawn.available_moves(board)
        expect(result).to eq([[1, 2]])
      end
    end

    context 'when it can kill another figures' do
      before do
        allow(board).to receive(:fields).and_return([[nil, nil, nil],
                                                     [nil, empty_field, nil],
                                                     [another_figure, another_figure, another_figure],
                                                     [nil, pawn, nil]])
      end
      it 'returns diagonal moves as kill' do
        result = pawn.available_moves(board)
        expect(result).to eq([[0, 2], [2, 2]])
      end
    end

    context 'when it has en passant available' do
      xit('returns en passant move') do
      end
    end
  end
end
