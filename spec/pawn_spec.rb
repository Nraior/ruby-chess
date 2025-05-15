require './lib/ruby_chess/figures/pawn'
describe Pawn do
  subject(:pawn) { described_class.new(1, 3, -1) }
  let(:pawn_field) { double('empty_field', { occupying: pawn }) }
  let(:occupied_figure) { instance_double(Pawn, direction: 1, position_history: [[0, 0]]) }
  let(:another_figure) { double('figure', { occupying: occupied_figure }) }
  let(:empty_field) { double('empty_field', { occupying: nil }) }
  let(:king) { double('king', { direction: -1 }) }
  let(:king_field) { double('empty_field', { occupying: king }) }
  let(:board) { double('board') }
  describe '#available_moves' do
    before do
      allow(board).to receive(:fields).and_return([[king_field, another_figure, empty_field],
                                                   [empty_field, another_figure, empty_field],
                                                   [empty_field, another_figure, empty_field],
                                                   [empty_field, pawn_field, empty_field]])
      allow(board).to receive(:width).and_return(3)
      allow(board).to receive(:height).and_return(4)
      allow(board).to receive(:valid_move?).and_return(true)
      allow(board).to receive(:team_king).and_return(king)
      allow(board).to receive(:figure_at_position) do |x, y|
        board.fields[y][x]&.occupying
      end
      allow(occupied_figure).to receive(:class).and_return(Pawn)

      allow(board).to receive(:update_inside_field_element) do |x, y, figure|
        p board.fields[y][x]
        p board.fields[y][x].occupying
        p 'enxt'
        # p
        board.fields[y][x].occupying = figure
        # board.fields[y][x].occupy(figure)
      end

      allow(board).to receive(:team_figures) do |direction|
        figures = []
        p board.fields[0]
        puts ''

        p board.fields[1]
        puts ''

        p board.fields[2]
        puts ''
        p board.fields[3]

        board.fields.flatten.each do |field|
          # p field
          # p field.occupying
          figures.push(field.occupying) if field.occupying&.direction == direction
        end
        figures
      end
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
        allow(board).to receive(:fields).and_return([[empty_field, pawn_field, empty_field],
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
                                                     [king_field, pawn_field, empty_field]])
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
                                                     [nil, pawn_field, nil]])
        allow(pawn).to receive(:moves_count).and_return(1)
      end

      xit 'returns forward field' do
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
      xit 'returns diagonal moves as kill' do
        result = pawn.available_moves(board)
        expect(result).to eq([[0, 2], [2, 2]])
      end
    end

    context 'en passant' do
      let(:occupied_figure) { Pawn.new(0, 0, 1) }
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
        xit('returns en passant move') do
          result = pawn.available_moves(board)
          expect(result).to eq([[0, 2], [2, 2]])
        end
      end

      context 'when en passant unavailable because of not double move' do
        before do
          occupied_figure.proceed_move(1, 1)
        end
        xit('returns false') do
          result = pawn.available_moves(board)
          expect(result).to eq([])
        end
      end

      context 'when there was two moves, and first was double' do
        before do
          occupied_figure.proceed_move(2, 2)
          occupied_figure.proceed_move(1, 1)
        end

        xit('returns false') do
          result = pawn.available_moves(board)
          expect(result).to eq([])
        end
      end
    end

    context 'when one standard move would result in checkmate' do
      let(:king_figure) { double('king', { direction: -1 }) }
      before do
        allow(board).to receive(:fields).and_return([[nil, another_figure, nil],
                                                     [nil, another_figure, nil],
                                                     [empty_field, another_figure, empty_field],
                                                     [nil, pawn, nil]])
      end
      xit "doesn't return that move " do
      end
    end
  end
end
