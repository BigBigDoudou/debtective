# Debtective

Help find out debt in your application.

## Usage

Run dedicated tasks:

- `bundle exec rake debtective:unused`: list unused helpers, constants and partials.
- `bundle exec rake debtective:absolute_paths:partials`: find absolute paths for partials.
- - `bundle exec rake debtective:absolute_paths:locales`: find absolute paths for locales.

More tasks to come!

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'debtective'
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

## Contributing

This gem is still a work in progress. You can use GitHub issue to start a discussion.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
