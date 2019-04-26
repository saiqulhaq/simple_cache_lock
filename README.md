# SimpleCacheLock

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/simple_cache_lock`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_cache_lock'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_cache_lock

## Usage

    SimpleCacheLock.configure do |config|
      config.redis_urls = ['redis://localhost:6379', '...']
      config.cache_store = Rails.cache
    end

    client = SimpleCacheLock::Client.new

    lock_key = 'foo'
    cache_key = 'bar'

    # returns yielded block
    client.lock lock_key, cache_key do
      # code
    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/saiqulhaq/simple_cache_lock. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimpleCacheLock project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/saiqulhaq/simple_cache_lock/blob/master/CODE_OF_CONDUCT.md).
