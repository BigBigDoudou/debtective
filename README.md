# Debtective

Find TODOs in your codebase so you don't forget to pay off your debts! 💰

## Usage

Run it with:

```bash
bundle exec debtective
```

Print to stdout the TODOs positions with their location and author.

Result is saved in a JSON file `todos.json`.

To find only your TODOs, use the `--me` option:

```bash
bundle exec debtective --me
```

To find only a specific user TODOs, use the `--user` option:

```bash
bundle exec debtective --user "Jane Doe" 
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
