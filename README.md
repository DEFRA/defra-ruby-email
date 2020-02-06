# Defra Ruby Email

> Work in progress. This project is not yet complete!

A Rails Engine used by the [Ruby services team](https://github.com/DEFRA/ruby-services-team) in their digital services.

We use it to allow us to access the content of the last email sent by an app. This information is used by our [acceptance tests](https://github.com/DEFRA/waste-carriers-acceptance-tests) to confirm emails are being sent with the expected content.

When mounted in an app, it will add a new route which when called, will return details of the last email as JSON.

## Prerequisites

Make sure you already have:

- Ruby 2.4.2
- [Bundler](http://bundler.io/) – for installing Ruby gems

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
