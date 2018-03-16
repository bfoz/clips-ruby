require 'set'

require_relative 'clips/rule'

class CLIPS
    # @return [Set]	The currently activated Facts awaiting processing
    attr_reader :activations

    # @return [Set]	The Rules waiting to be processed
    attr_reader :agenda

    # @return [Hash]	The set of facts that will be instantiated on each reset
    attr_reader :default_facts

    # @return [Set]	Just the Facts
    attr_reader :facts

    # @return [Hash]	The set of Rules and their names
    attr_reader :rules

    def initialize
	@activations = Set.new
	@agenda = Set.new
	@default_facts = Hash.new
	@facts = Set.new
	@rules = Hash.new
    end

    # @overload add(name, rule)
    #   Add the named {Rule}
    #   @param [String]	name 	The name of the {Rule}
    #   @param [Rule]	rule 	The {Rule} to add
    #   @return [CLIPS]
    # @overload add(*fields)
    #   Add a fact using the given field values
    #   @return [CLIPS]
    def add(*fields)
	if (2==fields.length) and fields.last&.is_a?(Rule)
	    self.rules[fields.first.to_sym] ||= fields.last
	else	# Assume the item to be a Fact
	    # Add the new Fact to the activations list for processing during the next call to run()
	    self.activations.add(fields)
	    self.facts.add(fields)
	    fields
	end
	self
    end

    # Remove all Facts and return self
    # @return [CLIPS]
    def clear
	self.activations.clear
	self.agenda.clear
	self.default_facts.clear
	self.facts.clear
	self.rules.clear
	self
    end

    # Remove the given fact
    # @return [CLIPS]
    def delete(*fact)
	if self.facts.delete?(fact)
	    self.activations.delete(fact)
	end
	self
    end

    # Delete everything but the rules, then add the default facts
    # @return [CLIPS]	self
    def reset
	self.activations.clear
	self.agenda.clear
	self.facts.clear

	self.default_facts.each do |name, fact_set|
	    fact_set.each {|fact| self.add(*fact)}
	end

	self
    end

    # @param [Integer] limit	The maximum number of rules that will fire before the function returns. The limit is disabled if nil.
    # @return [Integer]	The number of rules that were fired
    def run(limit=nil)
	self.rules.each do |name, rule|
	    self.agenda.add(rule) if rule.patterns.empty?
	end

	rule_counter = 0
	begin
	    # If all of a Rule's patterns match, and any of those patterns are on the activation list, then fire the Rule
	    self.rules.each do |name, rule|
		activated = false
		_all = rule.patterns.all? do |pattern|
		    activated = true if not activated and self.activations.include?(pattern)
		    self.facts.include?(pattern)
		end
		self.agenda.add(rule) if activated and _all
	    end

	    self.activations.clear	# All activations have been processed, so clear the Set

	    # Fire all of the Rules on the agenda in salience-order
	    sorted_agenda = self.agenda.sort {|a,b| b.salience <=> a.salience}
	    self.agenda.clear
	    sorted_agenda.each do |rule|
		rule.run!(self)
		rule_counter += 1

		if limit
		    limit -= 1
		    return rule_counter if limit.zero?
		end
	    end
	end until self.agenda.empty?

	rule_counter
    end
end
