require './lib/ruby_chess/figures/king'
describe King do
  subject(:king) { described_class.new(2, 2, 1) }
  let(:king_field) { double('king_field', { occupying: king }) }
  let(:board) { double('board') }
  let(:empty_field) { double('empty_field', { occupying: nil }) }
  let(:occupied_figure) { double('pawn', { direction: -1 }) }
  let(:another_figure) { double('figure', { occupying: occupied_figure }) }

  before do
    allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                 [empty_field, empty_field, empty_field, empty_field, empty_field],
                                                 [empty_field, empty_field, king_field, empty_field, empty_field],
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
    it 'returns neighboring positions' do
      moves = king.available_moves(board)
      expect(moves).to eq([[1, 1], [2, 1], [3, 1], [1, 2], [3, 2], [1, 3], [2, 3], [3, 3]])
    end
  end

  context 'when castling is available' do
    it 'returns castling moves' do
    end
  end

  context 'when king moved once' do
    it "doesn't return castle moves" do
    end
  end

  context 'when rooks moved once' do
    it "doesn't return castle moves" do
    end
  end

  context 'when its checked' do
    context 'when its empty between rook' do
      it "doesn't return castle moves" do
      end
    end
    it "returns available moves that doesn't end in check-mate " do
    end
  end

  context 'when its check-mate' do
    it 'returns no move' do
    end
  end
end
