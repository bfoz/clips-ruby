require 'clips'

RSpec.describe CLIPS::Rule do
    it 'must initialize with a single-field fact' do
	expect(CLIPS::Rule.new('foo').patterns).to eq([['foo']])
    end

    it 'must initialize with a multi-field fact' do
	expect(CLIPS::Rule.new('foo', 'bar').patterns).to eq([['foo', 'bar']])
    end
end
