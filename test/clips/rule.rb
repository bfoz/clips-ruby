require 'clips'

RSpec.describe CLIPS::Rule do
    context 'when initializing' do
	it 'must initialize with a single-field pattern' do
	    expect(CLIPS::Rule.new('foo').patterns).to eq([['foo']])
	end

	it 'must initialize with multiple single-field patterns' do
	    expect(CLIPS::Rule.new('foo', 'bar').patterns).to eq([['foo'], ['bar']])
	end

	it 'must initialize with a multi-field pattern' do
	    expect(CLIPS::Rule.new(%i{foo bar}).patterns).to eq([[:foo, :bar]])
	end

	it 'must initialize with multiple multi-field patterns' do
	    expect(CLIPS::Rule.new(%i{foo bar}, %i{baz qux}).patterns).to eq([[:foo, :bar], [:baz, :qux]])
	end
    end

    it 'must initialize with an action block' do
	b = ->{}
	expect(CLIPS::Rule.new('foo', &b).block).to eq(b)
    end

    it 'must call the block' do
	expect {|b| CLIPS::Rule.new('foo', &b).run!(nil)}.to yield_control
    end
end
