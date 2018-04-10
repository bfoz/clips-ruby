class CLIPS; end

class CLIPS::Rule
    attr_reader :actions
    attr_reader :block
    attr_reader :patterns
    attr_reader :salience

    def initialize(*args, actions:[], patterns:[], salience:0, &block)
	@actions = [actions].flatten(1)
	@block = block
	@patterns = patterns
	@salience = salience

	args.each do |arg|
	    if arg.is_a?(Array)
		@patterns.push arg unless arg.empty?
	    else
		@patterns.push [arg]
	    end
	end
    end

    # Assumes that the patterns have already been checked
    # @param [CLIPS]	environment	The thing with all of the facts
    # @param [Array]	patterns	The matching patterns that triggered this {Rule}
    def run!(environment, *patterns)
	if @block
	    @block.call(*patterns)
	else
	    self.actions.each do |action|
		environment.add(action)
	    end
	end
    end
end
