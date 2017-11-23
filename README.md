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

## Contributing
Contribution directions go here.
