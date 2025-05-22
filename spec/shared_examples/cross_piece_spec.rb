require './lib/ruby_chess/modules/chess_teams'

RSpec.shared_examples 'cross piece' do
  describe '#available_moves' do
    subject(:rook) { described_class.new(2, 2, 1) }
    let(:board) { double('board') }
    let(:empty_field) { double('empty_field', { occupying: nil }) }
    let(:occupied_figure) { double('pawn', { direction: ChessTeams::BOTTOM_TEAM }) }
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

      allow(board).to receive(:figure_at_position) do |x, y|
        board.fields[y][x].occupying
      end
      allow(OwnChekmateChecker).to receive(:will_cause_own_checkmate?).and_return(false)
    end
    context 'when its alone' do
      it 'returns cross positions' do
        result = rook.available_moves(board)
        expect(result).to eq([[1, 2], [0, 2], [3, 2], [4, 2], [2, 1], [2, 0], [2, 3], [2, 4]])
      end
    end

    context 'when its blocked by enemy figures' do
      before do
        allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                     [empty_field, empty_field, another_figure, empty_field,
                                                      empty_field],
                                                     [empty_field, another_figure, rook, another_figure, empty_field],
                                                     [empty_field, empty_field, another_figure, empty_field,
                                                      empty_field],
                                                     [empty_field, empty_field, empty_field, empty_field, empty_field]])
      end
      it 'returns first cross figures' do
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
      end
      it 'returns correct figures' do
        result = rook.available_moves(board)
        expect(result).to eq([[1, 2], [0, 2], [3, 2], [2, 1], [2, 0], [2, 3]])
      end
    end

    context 'when its blocked by own figures' do
      let(:occupied_figure) { double('pawn', { direction: ChessTeams::UP_TEAM }) }
      let(:own_figure) { double('figure', { occupying: occupied_figure }) }

      before do
        allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                     [empty_field, empty_field, own_figure, empty_field,
                                                      empty_field],
                                                     [empty_field, own_figure, rook, own_figure, empty_field],
                                                     [empty_field, empty_field, own_figure, empty_field,
                                                      empty_field],
                                                     [empty_field, empty_field, empty_field, empty_field, empty_field]])
      end

      it 'returns nothing' do
        result = rook.available_moves(board)
        expect(result).to eq([])
      end
    end
  end
end
