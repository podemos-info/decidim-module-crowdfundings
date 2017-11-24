# Decidim::Collaborations
This rails engine implements a Decidim feature that allows to the administrators to
configure collaborations for a participatory space.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'decidim-collaborations'
```

And then execute:
```bash
$ bundle
$ bundle exec rails decidim_collaborations:install:migrations
$ bundle exec rails db:migrate
$ bundle exec rails generate iban_bic:install
$ bundle exec rails db:migrate
$ bundle exec rails iban_bic:load_data
```

## Tests

In order to execute the tests data from iban_bic must be populated as well:

```bash
$ bundle exec rails iban_bic:load_data RAILS_ENV=test
```

## Docker & Docker compose

Check the spec/decidim_dummy_app/database.yml and set the host setting to db, 
user to admin and finally password to admin. If you desire to use different settings
you need to check the Docker compose settings and adjust the setup of the PostgreSQL
image.

## Contributing
Contribution directions go here.
