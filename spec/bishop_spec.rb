require './lib/ruby_chess/figures/bishop'
require './spec/shared_examples/diagonal_piece_spec'

describe Bishop do
  it_behaves_like 'diagonal piece'
end
