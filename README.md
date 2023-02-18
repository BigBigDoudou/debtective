# Debtective

Find legacy code so you don't forget to pay off your debts! 💰

## Usage

### Find TODOs

Run it with:

```bash
# find the TODOs comment
bundle exec debtective --todos
```

It prints to stdout the TODOs and saves the list in `todos.json`.

To find only your TODOs, use the `--me` option:

```bash
bundle exec debtective --todos --me
```

To find only a specific user TODOs, use the `--user` option:

```bash
bundle exec debtective --todos --user "Jane Doe" 
```

To silence all outputs and only build the JSON file, use the `--quiet` option:

```bash
bundle exec debtective --todos --quiet
```

### Upcoming features

:warning: These features are under development.

```bash
# find the disbaled offenses (# rubocop:disable ...)
bundle exec debtective --offenses
```

```bash
# find the outdated gems (not maintained anymore)
bundle exec debtective --gems
```

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
