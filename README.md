# Debtective

Find legacy code so you don't forget to pay off your debts! 💰

## Usage

### #️⃣ Comments

Globally, comments are a good clue to find smelly code that could be rewritten to become understandable without comments.

Morehover, TODO and FIXME comments indicate a debt that needs to be paid off.

Run it with:

```bash
bundle exec debtective --comments
```

This outputs the comment in the stdout and in a `comments.json` file, with useful information like the author and date, the type, the size of related statement, etc.

If you're interested only in the `comments.json` file, pass the `--quiet` option so nothing is logged to stdout.

You can filter comments by paths:

```bash
# find only comments in app/models and app/controllers
# excepting those in app/models/concerns and app/controllers/concerns
bundle exec debtective --comments \
  --include app/models app/controllers \
  --exclude app/models/concerns app/controllers/concerns
```

You can filter comments by author:

```bash
# find only your comments (rely on local git configuration)
bundle exec debtective --comments --me

# find only Jane Doe's comments
bundle exec debtective --comments --user "Jane Doe"
```

You can filter comments by type:

| type | example |
| --- | --- |
| `todo` | `# TODO: do that` |
| `fixme` | `# FIXME: do that` |
| `yard` | `# @return Float` |
| `offense` | `# rubocop:disable Metrics/MethodLength` |
| `magic` | `# frozen_string_literal: true` |
| `shebang` | `#!/usr/bin/env ruby` |
| `note` | `# hello world` (any other comment) |

Use `--<type>` to include a type or `--no-<type>` to exclude a type:

```bash
# find only todo and fixme comments
bundle exec debtective --comments --todo --fixme

# find all comments excepting magic and shebang
bundle exec debtective --comments --no-magic --no-shebang
```

Of course all options can be comined together:

```bash
# find only your todo and fixme comments in app/models and app/controllers
# excepting those in app/models/concerns and app/controllers/concerns
bundle exec debtective --comments --me --todo --fixme \
  --include app/models app/controllers \
  --exclude app/models/concerns app/controllers/concerns
```

### 💎 Gems

Find gems that are not maintained anymore.

:warning: Upcoming feature!

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

## Contributing

This gem is still a work in progress. You can use GitHub issue to start a discussion.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
