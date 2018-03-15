class CLIPS; end

class CLIPS::Rule
    attr_reader :actions
    attr_reader :patterns
    attr_reader :salience

    def initialize(*args, actions:[], patterns:[], salience:0)
	@actions = [actions].flatten(1)
	@patterns = patterns
	@salience = salience

	@patterns.push args unless args.empty?
    end

    # Assumes that the patterns have already been checked
    def run!(environment)
	self.actions.each do |action|
	    environment.add(action)
	end
    end
end
