# CLIPS for Ruby

This is a reimplemtation of the [CLIPS](http://www.clipsrules.net/) engine in Ruby, as well as a DSL for working with CLIPS rules.

The inference engine portion of this implementation has been structured to resemble Ruby's standard Set class. While this doesn't mirror the syntax used by the CLIPS language, it does stay true to the underlying functionality of the engine (ie. no duplicate facts).

The C implementation of CLIPS includes a command line shell, however this implementation does not. There are a million ways to make a shell-like interface in Ruby, none of which are appropriate to be included in this gem.

## Usage

```ruby
require 'clips'

clips = CLIPS.new
clips.add 'rule1', CLIPS::Rule.new('foo', actions:'bar')
clips.add 'foo'
...
clips.run
clips.facts	# => #<Set: {["foo"], ["bar"]}>
```

## Facts and Rules

Facts are represented by Arrays, and Rules are instances of the Rule class. Rule names can be given as Symbols or Strings, and are converted to Symbols internally.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clips'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clips

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `clips.gemspec`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
