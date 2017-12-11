# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'decidim/collaborations/version'

Gem::Specification.new do |s|
  s.version = Decidim::Collaborations::VERSION
  s.authors = ['Juan Salvador Perez Garcia']
  s.email = ['jsperezg@gmail.com']
  s.license = 'AGPL-3.0'
  s.homepage = 'https://github.com/podemos-info/decidim-module-crowdfundings'
  s.required_ruby_version = '>= 2.3.1'

  s.name = 'decidim-collaborations'
  s.summary = 'New feature that adds the possibility of having crowdfunding campaigns within participatory spaces'
  s.description = s.summary

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE-AGPLv3.txt', 'Rakefile', 'README.md']

  s.add_dependency 'decidim', '~> 0.8.0'
  s.add_dependency 'decidim-admin'
  s.add_dependency 'decidim-core', '~> 0.8.0'
  s.add_dependency 'decidim-verifications'
  s.add_dependency 'httparty'
  s.add_dependency 'iban_bic'
  s.add_dependency 'rails', '~> 5.1.4'
  s.add_dependency 'rectify'

  s.add_development_dependency 'decidim-dev'
  s.add_development_dependency 'webmock'
end
