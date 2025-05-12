require './lib/ruby_chess/figures/rook'
require './spec/shared_examples/cross_piece_spec'
describe Rook do
  it_behaves_like 'cross piece'
end
