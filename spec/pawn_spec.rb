require './lib/ruby_chess/figures/pawn'
require './lib/ruby_chess/modules/chess_teams'
describe Pawn do
  subject(:pawn) { described_class.new(1, 3, ChessTeams::BOTTOM_TEAM) }
  let(:occupied_figure) { instance_double(Pawn, direction: 1, position_history: [[0, 0]]) }
  let(:another_figure) { double('figure', { occupying: occupied_figure }) }
  let(:empty_field) { double('empty_field', { occupying: nil }) }
  let(:king) { double('king', { direction: ChessTeams::BOTTOM_TEAM }) }
  let(:king_field) { double('empty_field', { occupying: king }) }
  let(:board) { double('board') }
  describe '#available_moves' do
    before do
      allow(board).to receive(:fields).and_return([[king_field, another_figure, empty_field],
                                                   [empty_field, another_figure, empty_field],
                                                   [empty_field, another_figure, empty_field],
                                                   [empty_field, pawn, empty_field]])
      allow(board).to receive(:width).and_return(3)
      allow(board).to receive(:height).and_return(4)
      allow(board).to receive(:valid_move?).and_return(true)
      allow(board).to receive(:team_king).and_return(king)
      allow(board).to receive(:figure_at_position) do |x, y|
        board.fields[y][x]&.occupying
      end
      allow(occupied_figure).to receive(:class).and_return(Pawn)
      allow(OwnChekmateChecker).to receive(:will_cause_own_checkmate?).and_return(false)
      allow(OwnChekmateChecker).to receive(:en_passant_cause_own_checkmate?).and_return(false)
    end

    context('when its blocked and pawn is at the bottom') do
      it('returns nothing') do
        available_moves = pawn.available_moves(board)
        expect(available_moves).to eq([])
      end
    end

    context('when its blocked and pawn is at the top') do
      subject(:pawn) { described_class.new(1, 0, ChessTeams::UP_TEAM) }

      before do
        allow(board).to receive(:fields).and_return([[empty_field, pawn, empty_field],
                                                     [empty_field, another_figure, empty_field],
                                                     [empty_field, another_figure, empty_field],
                                                     [king_field, another_figure, empty_field]])
      end
      it('returns nothing') do
        available_moves = pawn.available_moves(board)
        expect(available_moves).to eq([])
      end
    end

    context('when its first move and forward fields are free') do
      before do
        allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field],
                                                     [empty_field, empty_field, empty_field],
                                                     [empty_field, empty_field, empty_field],
                                                     [king_field, pawn, empty_field]])
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

    context 'en passant' do
      let(:occupied_figure) { Pawn.new(0, 0, ChessTeams::UP_TEAM) }
      let(:another_figure) { double('figure', { occupying: occupied_figure }) }

      before do
        allow(board).to receive(:fields).and_return([[nil, nil, nil],
                                                     [nil, empty_field, nil],
                                                     [empty_field, another_figure, empty_field],
                                                     [another_figure, pawn, another_figure]])
        allow(occupied_figure).to receive(:is_a?).and_return(true)
      end

      context 'when it has en passant available' do
        before do
          occupied_figure.proceed_move(2, 2)
        end
        it('returns en passant move') do
          result = pawn.available_moves(board)
          expect(result).to eq([[0, 2], [2, 2]])
        end
      end

      context 'when en passant unavailable because of not double move' do
        before do
          occupied_figure.proceed_move(1, 1)
        end
        it('returns false') do
          result = pawn.available_moves(board)
          expect(result).to eq([])
        end
      end

      context 'when there was two moves, and first was double' do
        before do
          occupied_figure.proceed_move(2, 2)
          occupied_figure.proceed_move(1, 1)
        end

        it('returns false') do
          result = pawn.available_moves(board)
          expect(result).to eq([])
        end
      end
    end
  end
end
