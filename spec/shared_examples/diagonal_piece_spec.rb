RSpec.shared_examples 'diagonal piece' do
  subject(:bishop) { described_class.new(2, 2, 1) }
  let(:board) { double('board') }
  let(:empty_field) { double('empty_field', { occupying: nil }) }
  let(:occupied_figure) { double('pawn', { direction: -1 }) }
  let(:enemy_field) { double('figure', { occupying: occupied_figure }) }
  let(:own_pawn) { double('pawn', { direction: 1 }) }
  let(:own_field) { double('figure', { occupying: own_pawn }) }

  before do
    allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                 [empty_field, empty_field, own_field, empty_field, empty_field],
                                                 [empty_field, own_field, bishop, own_field, empty_field],
                                                 [empty_field, empty_field, own_field, empty_field, empty_field],
                                                 [empty_field, empty_field, empty_field, empty_field, empty_field]])
    allow(board).to receive(:valid_move?).and_return(true)
    allow(board).to receive(:valid_move?) do |x, y|
      x >= 0 && y >= 0 && y < board.fields.length && x < board.fields[0].length
    end

    allow(board).to receive(:figure_at_position) do |x, y|
      board.fields[y][x].occupying
    end
  end
  describe '#available_moves' do
    it 'returns cross moves' do
      moves = bishop.available_moves(board)
      expect(moves).to eq([[1, 1], [0, 0], [3, 1], [4, 0], [1, 3], [0, 4], [3, 3], [4, 4]])
    end

    context 'when its blocked by own figures' do
      before do
        allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                     [empty_field, own_field, empty_field, own_field, empty_field],
                                                     [empty_field, empty_field, bishop, empty_field, empty_field],
                                                     [empty_field, own_field, empty_field, own_field, empty_field],
                                                     [empty_field, empty_field, empty_field, empty_field, empty_field]])
      end

      it 'returns no field' do
        moves = bishop.available_moves(board)
        expect(moves).to eq([])
      end
    end

    context 'when its blocked by enemy figures' do
      before do
        allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                     [empty_field, enemy_field, empty_field, enemy_field, empty_field],
                                                     [empty_field, empty_field, bishop, empty_field, empty_field],
                                                     [empty_field, enemy_field, empty_field, enemy_field, empty_field],
                                                     [empty_field, empty_field, empty_field, empty_field, empty_field]])
      end

      it 'returns first cross positions' do
        moves = bishop.available_moves(board)
        expect(moves).to eq([[1, 1], [3, 1], [1, 3], [3, 3]])
      end
    end
  end
end
