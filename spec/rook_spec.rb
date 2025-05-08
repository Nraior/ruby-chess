require './lib/ruby_chess/figures/rook'
describe Rook do
  describe '#available_moves' do
    subject(:rook) { described_class.new(2, 2, 1) }
    let(:board) { double('board') }
    let(:empty_field) { double('empty_field', { occupying: nil }) }
    let(:occupied_figure) { double('pawn', { direction: 1 }) }
    let(:another_figure) { double('figure', { occupying: occupied_figure }) }

    before do
      allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                   [empty_field, empty_field, empty_field, empty_field, empty_field],
                                                   [empty_field, empty_field, rook, empty_field, empty_field],
                                                   [empty_field, empty_field, empty_field, empty_field, empty_field],
                                                   [empty_field, empty_field, empty_field, empty_field, empty_field]])
      allow(board).to receive(:valid_move?).and_return(true)
      allow(board).to receive(:valid_move?) do |x, y|
        x >= 0 && y >= 0 && y < board.fields.length && x < board.fields[0].length
      end

      allow(board).to receive(:enemy_at_position?).and_return(false)
    end
    context 'when its alone' do
      it 'returns valid positions' do
        result = rook.available_moves(board)
        expect(result).to eq([[1, 2], [0, 2], [3, 2], [4, 2], [2, 1], [2, 0], [2, 3], [2, 4]])
      end
    end

    context 'when its blocked' do
      before do
        allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                     [empty_field, empty_field, another_figure, empty_field,
                                                      empty_field],
                                                     [empty_field, another_figure, rook, another_figure, empty_field],
                                                     [empty_field, empty_field, another_figure, empty_field,
                                                      empty_field],
                                                     [empty_field, empty_field, empty_field, empty_field, empty_field]])
        allow(board).to receive(:enemy_at_position?).and_return(true)
      end
      it 'returns first figures' do
        result = rook.available_moves(board)
        expect(result).to eq([[1, 2], [3, 2], [2, 1], [2, 3]])
      end
    end
    context 'when two sides are blocked' do
      before do
        allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                     [empty_field, empty_field, empty_field, empty_field,
                                                      empty_field],
                                                     [empty_field, empty_field, rook, another_figure, empty_field],
                                                     [empty_field, empty_field, another_figure, empty_field,
                                                      empty_field],
                                                     [empty_field, empty_field, empty_field, empty_field, empty_field]])
        allow(board).to receive(:enemy_at_position?).and_return(true)
        allow(board).to receive(:enemy_at_position?).with(rook, 2, 1).and_return(false)
        allow(board).to receive(:enemy_at_position?).with(rook, 3, 2).and_return(false)
      end
      it 'returns correct figures' do
        result = rook.available_moves(board)
        expect(result).to eq([[1, 2], [3, 2], [4, 2], [2, 1], [2, 0], [2, 3]])
      end
    end
  end
end
