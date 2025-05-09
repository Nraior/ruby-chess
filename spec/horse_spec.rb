require_relative '../lib/ruby_chess/figures/horse'
describe Horse do
  subject(:horse) { described_class.new(2, 2, 1) }
  let(:board) { double('board') }
  let(:empty_field) { double('empty_field', { occupying: nil }) }
  let(:occupied_figure) { double('pawn', { direction: -1 }) }
  let(:another_figure) { double('figure', { occupying: occupied_figure }) }

  before do
    allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                 [empty_field, empty_field, empty_field, empty_field, empty_field],
                                                 [empty_field, empty_field, horse, empty_field, empty_field],
                                                 [empty_field, empty_field, empty_field, empty_field, empty_field],
                                                 [empty_field, empty_field, empty_field, empty_field, empty_field]])
    allow(board).to receive(:valid_move?) do |x, y|
      x >= 0 && y >= 0 && y < board.fields.length && x < board.fields[0].length
    end

    allow(board).to receive(:figure_at_position) do |x, y|
      board.fields[y][x].occupying
    end
  end

  context 'when its empty' do
    it 'returns L shape positions' do
      positions = horse.available_moves(board)
      expect(positions).to eq([[1, 0], [0, 1], [3, 0], [4, 1], [1, 4], [0, 3], [4, 3], [3, 4]])
    end
  end

  context 'when enemies are on position' do
    before do
      allow(board).to receive(:fields).and_return([[empty_field, another_figure, empty_field, another_figure, empty_field],
                                                   [another_figure, empty_field, empty_field, empty_field,
                                                    another_figure],
                                                   [empty_field, empty_field, horse, empty_field, empty_field],
                                                   [another_figure, empty_field, empty_field, empty_field,
                                                    another_figure],
                                                   [empty_field, another_figure, empty_field, another_figure,
                                                    empty_field]])
    end

    it 'returns L shape positions' do
      positions = horse.available_moves(board)
      expect(positions).to eq([[1, 0], [0, 1], [3, 0], [4, 1], [1, 4], [0, 3], [4, 3], [3, 4]])
    end
  end

  context 'when allies are on positions' do
    let(:occupied_figure) { double('pawn', { direction: 1 }) }
    let(:own_figure) { double('figure', { occupying: occupied_figure }) }

    before do
      allow(board).to receive(:fields).and_return([[empty_field, own_figure, empty_field, own_figure, empty_field],
                                                   [own_figure, empty_field, empty_field, empty_field,
                                                    own_figure],
                                                   [empty_field, empty_field, horse, empty_field, empty_field],
                                                   [own_figure, empty_field, empty_field, empty_field,
                                                    own_figure],
                                                   [empty_field, own_figure, empty_field, own_figure,
                                                    empty_field]])
    end
    it 'returns nothing' do
      positions = horse.available_moves(board)
      expect(positions).to eq([])
    end
  end
end
