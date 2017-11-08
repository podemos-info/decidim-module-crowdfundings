# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'decidim/collaborations/version'

Gem::Specification.new do |s|
  s.version = Decidim::Collaborations::VERSION
  s.authors = ['Juan Salvador Pérez García']
  s.email = ['jsperezg@gmail.com']
  s.license = 'AGPL-3.0'
  s.homepage = 'https://github.com/podemos-info/decidim-collaborations'
  s.required_ruby_version = '>= 2.3.1'

  s.name = 'decidim-collaborations'
  s.summary = 'New feature that adds the possibility of having economic collaborations within participatory processes'
  s.description = s.summary

  s.files = Dir['{app,config,db,lib,vendor}/**/*', 'Rakefile', 'README.md']

  s.add_dependency 'decidim-core', '>= 0.7.0', '<= 0.8.0'
  s.add_dependency 'decidim-admin'
  s.add_dependency 'rectify'

  s.add_development_dependency 'decidim-dev'
end
