# Defra Ruby Email

[![Build Status](https://travis-ci.com/DEFRA/defra-ruby-email.svg?branch=master)](https://travis-ci.com/DEFRA/defra-ruby-email)
[![Maintainability](https://api.codeclimate.com/v1/badges/0eb068e0b0ec99debf88/maintainability)](https://codeclimate.com/github/DEFRA/defra-ruby-email/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0eb068e0b0ec99debf88/test_coverage)](https://codeclimate.com/github/DEFRA/defra-ruby-email/test_coverage)
[![security](https://hakiri.io/github/DEFRA/defra-ruby-email/master.svg)](https://hakiri.io/github/DEFRA/defra-ruby-email/master)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

A Rails Engine used by the [Ruby services team](https://github.com/DEFRA/ruby-services-team) in their digital services.

We use it to allow us to access the content of the last email sent by an app. This information is used by our [acceptance tests](https://github.com/DEFRA/waste-carriers-acceptance-tests) to confirm emails are being sent with the expected content.

When mounted in an app, it will add a new route which when called, will return details of the last email as JSON.

## Prerequisites

Make sure you already have:

- Ruby 2.4.2
- [Bundler](http://bundler.io/) – for installing Ruby gems

## Mounting the engine

Add the engine to your Gemfile:

```ruby
gem "defra_ruby_email"
```

Install it with `bundle install`.

Then mount the engine in your routes.rb file:

```ruby
Rails.application.routes.draw do
  mount DefraRubyEmail::Engine => "/email"
end
```

The engine should now be mounted at `/email` in your project. You can change `"/email"` to a different route if you'd prefer it to be elsewhere.

## Configuration

For the email routes to be accessible you'll also need to enable them.

```ruby
# config/initializers/defra_ruby_email.rb
require "defra_ruby_email"

DefraRubyEmail.configure do |config|
  config.enable = true
end
```

To protect against having this enabled when in production, by default the engine will not allow access unless it has been enabled in the config.

## Last email

When no emails have been sent accessing the `/email/last-email` page will return

```json
{
  "error": "No emails sent."
}
```

If an email has been sent you'll get something like this

```json
{
  "last_email": {
    "date": "2020-02-19T14:06:11+00:00",
    "from": [
      "registrations@my-env.aws.defra.cloud"
    ],
    "to": [
      "qizy@example.com"
    ],
    "bcc": null,
    "cc": null,
    "reply_to": null,
    "subject": "Waste exemptions registration WEX000060 completed",
    "body": "<!doctype html>\n<!--[if lt IE 7]>  <html class=\"ie ie ... </body>\n</html>\n",
    "attachments": [
      "WEX000060.pdf",
      "privacy_policy.pdf",
      "govuk_logotype_email.png"
    ]
  }
}
```

### Multiple emails

We know that some services will fire multiple emails at the same time, for example where the form filler and the contact email are different.

It's important to note only the last email sent is retained.

### Multiple processes

In a production environment it is likely that the same app will be deployed to multiple servers, and might even spawn multiple processes if an appplication server like [Passenger](https://www.phusionpassenger.com/) is used.

So trying to get the last email sent by an application is not possible. Ensure in your tests that you build in a retry function that allows you to hit an environment multiple times in order to confirm if an expected email has been sent.

## Installation

You don't need to do this if you're just mounting the engine without making any changes.

However, if you want to edit the engine, you'll have to install it locally.

Clone the repo and drop into the project:

```bash
git clone https://github.com/DEFRA/defra-ruby-email.git && cd defra-ruby-email
```

Then install the dependencies with `bundle install`.

## Testing the engine

The engine is mounted in a dummy Rails 4 app (in /spec/dummy) so we can properly test its behaviour.

The test suite is written in RSpec.

To run all the tests, use `bundle exec rspec`.

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

<http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3>

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
