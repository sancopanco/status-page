# StatusPage

Think of this tool as a CLI version of sites like https://statuspages.me/

![Alt text](./screen-shot-status-page.png?raw=true "Status Pages")

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'status_page'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install status_page

## Usage

### Commands:
  `status-page backup <path>`   # Creates a backup of historic and currently saved data.
  `status-page help [COMMAND]`  # Describe available commands or one specific command
  `status-page history`         # Display all the data
  `status-page live`            # Output the status periodically on the console
  `status-page pull`            # Pull all the status page infos
  `status-page restore <path>`  # Restore backup data
  `status-page status`          # Summarizes the data and displays
  `status-page version`         # Display Statuspage gem version

### Options:
  [--config-file=CONFIG_FILE]   # Default: ~/.status-page.rc.yaml
  [--service-name=SERVICE_NAME]
  [--format=FORMAT]             # Default: pretty

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/status_page. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the StatusPage project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/status_page/blob/master/CODE_OF_CONDUCT.md).
