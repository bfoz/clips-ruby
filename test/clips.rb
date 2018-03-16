require 'clips'

RSpec.describe CLIPS do
    context 'when adding a fact' do
	it 'must add a single field fact' do
	    subject.add("foo")
	    expect(subject.facts).to eq(Set[['foo']])
	end

	it 'must add a fact that has two fields' do
	    subject.add("foo", 5)
	    expect(subject.facts).to eq(Set[['foo', 5]])
	end

	it 'must add a fact that has multiple fields' do
	    subject.add("foo", 'bar', 5)
	    expect(subject.facts).to eq(Set[['foo', 'bar', 5]])
	end

	it 'must add a similar fact that has multiple fields' do
	    subject.add("foo", 'bar', 5)
	    subject.add("foo", 'baz', 7)
	    expect(subject.facts).to eq(Set[['foo', 'bar', 5], ['foo', 'baz', 7]])
	end

	it 'must not add a duplicate fact' do
	    subject.add("foo")
	    subject.add("foo")
	    expect(subject.facts).to eq(Set[['foo']])
	end

	it 'must not add a duplicate fact that has multiple fields' do
	    subject.add("foo", 'bar', 5)
	    subject.add("foo", 'bar', 5)
	    expect(subject.facts).to eq(Set[['foo', 'bar', 5]])
	end

	it 'must add an activation for a new fact' do
	    subject.add('foo', 'bar')
	    expect(subject.activations).to eq(Set[['foo', 'bar']])
	end

	it 'must not add an activation for a duplicate fact' do
	    subject.add('foo')
	    subject.add('foo')
	    expect(subject.activations).to eq(Set[['foo']])
	end
    end

    context 'when adding a Rule' do
	it 'must add a Rule' do
	    subject.add :rule, CLIPS::Rule.new
	    expect(subject.rules.length).to eq(1)
	end

	it 'must replace a Rule with the same name' do
	    subject.add :rule, CLIPS::Rule.new
	    expect(subject.rules.length).to eq(1)

	    # Add the Rule again and check that there's still only one
	    subject.add 'rule', CLIPS::Rule.new
	    expect(subject.rules.length).to eq(1)
	end
    end

    context 'when clearing' do
	it 'must delete all facts' do
	    subject.add("foo")
	    subject.add("bar")

	    subject.clear
	    expect(subject.facts).to be_empty
	end

	it 'must delete all activations' do
	    subject.add("foo")
	    subject.add("bar")

	    subject.clear
	    expect(subject.activations).to be_empty
	end

	it 'must delete all rules' do
	    subject.add :rule, CLIPS::Rule.new
	    expect(subject.rules).not_to be_empty

	    subject.clear
	    expect(subject.rules).to be_empty
	end

	it 'must delete all default facts' do
	    subject.default_facts['facts'] = Set[['foo'], ['bar']]
	    subject.clear
	    expect(subject.default_facts).to be_empty
	end
    end

    context 'when resetting' do
	it 'must delete all facts' do
	    subject.add("foo")
	    subject.add("bar")

	    subject.reset
	    expect(subject.facts).to be_empty
	end

	it 'must delete all activations' do
	    subject.add("foo")
	    subject.add("bar")

	    subject.reset
	    expect(subject.activations).to be_empty
	end

	it 'must not delete rules' do
	    subject.add :rule, CLIPS::Rule.new
	    expect(subject.rules).not_to be_empty

	    subject.reset
	    expect(subject.rules).not_to be_empty
	end

	it 'must instantiate the default facts' do
	    subject.default_facts['facts'] = Set[['foo'], ['bar']]
	    subject.reset
	    expect(subject.facts).to eq(Set[['foo'], ['bar']])
	    expect(subject.default_facts).to eq({'facts' => Set[['foo'], ['bar']]})
	end
    end

    context 'when retracting a fact' do
	it 'must delete a fact' do
	    subject.add('foo')
	    subject.add('bar')

	    subject.delete('foo')
	    expect(subject.facts).to eq(Set[['bar']])
	    expect(subject.activations).to eq(subject.facts)
	end

	it 'must delete a fact that has multiple fields' do
	    subject.add('foo', 5)
	    subject.add('bar', 7)

	    subject.delete('foo', 5)
	    expect(subject.facts).to eq(Set[['bar', 7]])
	    expect(subject.activations).to eq(subject.facts)
	end

	it 'must not delete a fact that does not exist' do
	    subject.add('foo', 5)
	    subject.add('bar', 7)

	    subject.delete('foo', 7)
	    expect(subject.facts).to eq(Set[['foo', 5], ['bar', 7]])
	    expect(subject.activations).to eq(subject.facts)
	end
    end

    context 'when running' do
	it 'must trigger any patternless rules' do
	    subject.add 'foo', CLIPS::Rule.new(actions:'bar')
	    subject.run
	    expect(subject.facts).to eq(Set.new([['bar']]))
	end

	it 'must trigger the rules for any facts that were added before running' do
	    subject.add 'foo', CLIPS::Rule.new('bar', actions:'baz')
	    subject.add 'bar'
	    subject.run
	    expect(subject.facts).to eq([['bar'], ['baz']].to_set)
	end
    end
end
