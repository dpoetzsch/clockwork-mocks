# ClockworkMocks

This gem provides **helpers for integration testing with clockwork**.
[Clockwork](https://github.com/Rykian/clockwork) provides a cron-like utility for ruby.
It works especially well in combination with [timecop](https://github.com/travisjeffery/timecop).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clockwork-mocks'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clockwork-mocks

## Usage

### Initialization with RSpec

```ruby
RSpec.describe ... do
  let!(:clockwork_scheduler) { ClockworkMocks::Scheduler.init_rspec(->(a) { allow a }, ->(a) { receive a }, 'path/to/clock.rb') }
end
```

If you do not pass a clock file path to `ClockworkMocks::Scheduler.new` and you are in a rails environment it will assume `"#{Rails.root}/clock.rb"` by default.
This reloads the `clock.rb` file in every test.
If you care about that performance leak, there is a more verbose initialization option:

```ruby
RSpec.describe ... do
  clockwork_scheduler = nil
  
  before do
    clockwork_scheduler ||= ClockworkMocks::Scheduler.init_rspec(->(a) { allow a }, ->(a) { receive a }, 'path/to/clock.rb')
    clockwork_scheduler.reset!
  end
end
```

### General Initialization

```ruby
clockwork_scheduler = ClockworkMocks::Scheduler.new

# ...

clockwork_scheduler.every(1.day, 'some task', at: '23:00') do
  # something
end
```

Using this interface, you can use any stub provider to stub `Clockwork.every` and call `clockwork_scheduler.every` instead, e.g. with rspec-mock:

```ruby
allow.call(Clockwork).to receive.call(:every) do |interval, name, hash, &block|
  clockwork_scheduler.every interval, name, hash, &block
end

load 'path/to/clock.rb'
```

### Executing clockwork tasks

At any time you can call `clockwork_scheduler.work` to execute all tasks that are due.
This works especially well in combination with timecop (although the latter is not a requirement):

```ruby
Timecop.freeze(2.days.from_now) do
  clockwork_scheduler.work
end
```

Tasks will be executed in correct order.
If enough time passed, tasks will be executed multiple times:

```ruby
clockwork_scheduler.every(1.second, 'often') { puts 'often' }
clockwork_scheduler.every(2.seconds, 'not-so-often') { puts 'not so often' }

Timecop.freeze(3.seconds.from_now) do
  clockwork_scheduler.work
end
```

outputs

```
often
often
not-so-often
often
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dpoetzsch/clockwork-mocks.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

### TODO

- [x] Basic support for tasks with block
- [x] Support for `Clockwork.handler`

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ClockworkMocks project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dpoetzsch/clockwork-mocks/blob/master/CODE_OF_CONDUCT.md).
