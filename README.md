# Debtective

Find todos in your codebase so you don't forget to pay off your debts! 💰

## Usage

Run the task with:

```bash
bundle exec rake debtective:todo_list
```

It outputs the todos positions with the concerned lines of code and some counts.

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem "debtective"
end
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install debtective
```

Configure the paths that should be analyzed (all by default):

```ruby
# config/initializers/debtective.rb

Debtective.configure do |config|
  config.paths = ["app/**/*", "lib/**/*"]
end
```

## Contributing

This gem is still a work in progress. You can use GitHub issue to start a discussion.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
