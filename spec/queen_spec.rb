require './lib/ruby_chess/figures/queen'

describe Queen do
  describe '#available_moves' do
    subject(:queen) { described_class.new(2, 2, 1) }
    let(:board) { double('board') }
    let(:empty_field) { double('empty_field', { occupying: nil }) }
    let(:occupied_figure) { double('pawn', { direction: -1 }) }
    let(:another_figure) { double('figure', { occupying: occupied_figure }) }

    before do
      allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                   [empty_field, empty_field, empty_field, empty_field, empty_field],
                                                   [empty_field, empty_field, queen, empty_field, empty_field],
                                                   [empty_field, empty_field, empty_field, empty_field, empty_field],
                                                   [empty_field, empty_field, empty_field, empty_field, empty_field]])
      allow(board).to receive(:valid_move?).and_return(true)
      allow(board).to receive(:valid_move?) do |x, y|
        x >= 0 && y >= 0 && y < board.fields.length && x < board.fields[0].length
      end

      allow(board).to receive(:figure_at_position) do |x, y|
        board.fields[y][x].occupying
      end
    end
    context 'when its alone' do
      it 'returns cross and diagonal positions' do
        result = queen.available_moves(board)
        expect(result).to eq([[1, 2], [0, 2], [3, 2], [4, 2], [2, 1], [2, 0], [2, 3], [2, 4], [1, 1], [0, 0], [3, 1],
                              [4, 0], [1, 3], [0, 4], [3, 3], [4, 4]])
      end
    end

    context 'when its blocked by enemy figures' do
      before do
        allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                     [empty_field, another_figure, another_figure, another_figure,
                                                      empty_field],
                                                     [empty_field, another_figure, queen, another_figure, empty_field],
                                                     [empty_field, another_figure, another_figure, another_figure,
                                                      empty_field],
                                                     [empty_field, empty_field, empty_field, empty_field, empty_field]])
      end
      it 'returns first cross + diagonal figures' do
        result = queen.available_moves(board)
        expect(result).to eq([[1, 2], [3, 2], [2, 1], [2, 3], [1, 1], [3, 1], [1, 3], [3, 3]])
      end
    end

    context 'when its blocked by own figures' do
      let(:occupied_figure) { double('pawn', { direction: 1 }) }
      let(:own_figure) { double('figure', { occupying: occupied_figure }) }

      before do
        allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                     [empty_field, own_figure, own_figure, own_figure,
                                                      empty_field],
                                                     [empty_field, own_figure, queen, own_figure, empty_field],
                                                     [empty_field, own_figure, own_figure, own_figure,
                                                      empty_field],
                                                     [empty_field, empty_field, empty_field, empty_field, empty_field]])
      end

      it 'returns nothing' do
        result = queen.available_moves(board)
        expect(result).to eq([])
      end
    end
  end
end
