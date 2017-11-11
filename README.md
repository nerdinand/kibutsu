# kibutsu
[![Gem Version](https://badge.fury.io/rb/kibutsu.svg)](https://badge.fury.io/rb/kibutsu) [![Build Status](http://img.shields.io/travis/nerdinand/kibutsu/master.svg)](https://travis-ci.org/nerdinand/kibutsu?branch=master)

Kibutsu is an easy-to-use database fixture library.

The only dependency kibutsu has is the [sequel](https://rubygems.org/gems/sequel) gem. Thus, you may use it with any project that uses sequel, e.g. with a hanami app!

It features Rails-style database fixtures with
* ERB-preprocessing capability
* cross-referencing of fixtures to simplify work with foreign keys
* automatic filling of `created_at` and `updated_at`, if necessary

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kibutsu'
```

And then execute:

```shell
$ bundle
```

## Usage

Kibutsu can be used in any project that uses the sequel gem. The public API is accessible through the [Kibutsu](http://www.rubydoc.info/gems/kibutsu/1.0.1/Kibutsu) module.

### Usage with RSpec and Hanami

In your `spec_helper.rb`, add the following:

```ruby
config.before(:suite) do
  Kibutsu.load_fixtures!(ENV['DATABASE_URL'], Hanami.root.join('spec', 'fixtures'))
end
```

This will tell Kibutsu to load the fixture files saved in `spec/fixtures/` in your project. It will then import that fixture data into the database specified in the `DATABASE_URL` environment variable.

It's also recommended that you reset the status of the database after each individual test, for example via a transaction configured in `spec_helper.rb`:

```ruby
config.around(:each) do |example|
  Hanami::Model.configuration.connection.transaction(savepoint: true) do
    example.run
    raise Sequel::Rollback
  end
end
```

### Fixture files

The fixture file format is almost exactly like the one used for [Rails](http://guides.rubyonrails.org/testing.html#the-low-down-on-fixtures). Here's an example:

`spec/fixtures/authors.yml`
```yaml
authors: # name of the database table
  adams: # name of this fixture, to be referenced in other fixtures
    first_name: Douglas
    last_name: Adams
```

If a fixture file ends in `.yml.erb` instead of `.yml`, it is being run through ERB partial processing:

`spec/fixtures/books.yml.erb`
```yaml
books:
  hitchhiker:
    title: The Hitchhiker's Guide to the Galaxy
    author: adams # we reference another fixture here (this assumes there is a column books.author_id)
    page_count: <%= 179 %>

  restaurant:
    title: The Restaurant at the End of the Universe
    author: adams
    page_count: <%= 200 %>
```

In case you need to reference a particular fixture from a test, you can use `Kibutsu.fixture_name_to_id` to get the id of a named fixture like so:

```ruby
AuthorRepository.new.find(Kibutsu.fixture_name_to_id(:adams))
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nerdinand/kibutsu. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
