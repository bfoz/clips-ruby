require 'clips'

RSpec.describe CLIPS::Rule do
    it 'must initialize with a single-field fact' do
	expect(CLIPS::Rule.new('foo').patterns).to eq([['foo']])
    end

    it 'must initialize with a multi-field fact' do
	expect(CLIPS::Rule.new('foo', 'bar').patterns).to eq([['foo', 'bar']])
    end

    it 'must initialize with an action block' do
	b = ->{}
	expect(CLIPS::Rule.new('foo', &b).block).to eq(b)
    end

    it 'must call the block' do
	expect {|b| CLIPS::Rule.new('foo', &b).run!(nil)}.to yield_control
    end
end
