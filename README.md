# Oauth Bwergemn on Grape API

Oauth Bwergemn is a Grape middleware to connect your API resources with your API authenticator.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oauth-bwergemn'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oauth-bwergemn

## Usage

### Install generator

On your first install, run this generator :

```ruby
rails g oauth_bwergemn:install
```

### Usage with Grape

You will need to use the middleware in your main API :

```ruby
# use middleware
use ::OauthBwergemn::Oauth2
```

You could also use the helpers :

```ruby
# use helpers
helpers ::OauthBwergemn::Helpers
```

And also don't forget to rescue the invalid token :

```ruby
# rescue invalid token
rescue_from OauthBwergemn::Errors::InvalidToken do |e|
  error!(e, 401)
end
rescue_from OauthBwergemn::Errors::InvalidScope do |e|
  error!(e, 401)
end
```

### Protecting your endpoint

In your endpoint you need to define which protected endpoint by adding this DSL :

1.  `oauth2`
2.  `oauth2 "email"`

Example :

```ruby
desc "Your protected endpoint"
oauth2 
get :protected do
    # your code goes here
end
```

```ruby
desc "Your protected endpoint with defined scope"
oauth2 "email"
get :protected do
    # your code goes here
end
```

## Nice feature

From your protected endpoint you could get :

1. `resource_access_token` => Your access token
2. `resource_credentials` => Full credentials
3. `resource_owner` => Current Object


## TODO

- Add rspec test

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [ https://github.com/namakukingkong/oauth-bwergemn ] . This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Oauth Bwergemn project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/namakukingkong/oauth-bwergemn/blob/master/CODE_OF_CONDUCT.md).
