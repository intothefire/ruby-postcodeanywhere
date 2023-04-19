# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'ruby-postcodeanywhere'
  s.version = '0.1.3'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Chris Norman']
  s.date = '2011-08-04'
  s.description = 'Gem to provide basic access to PostcodeAnywhere services'
  s.email = 'chris@norman.me'
  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.rdoc'
  ]
  s.files = [
    '.document',
    '.rspec',
    'Gemfile',
    'Gemfile.lock',
    'LICENSE.txt',
    'Postcode Anywhere.tmproj',
    'README.rdoc',
    'Rakefile',
    'VERSION',
    'lib/ruby-postcodeanywhere.rb',
    'ruby-postcodeanywhere.gemspec',
    'spec/ruby-postcodeanywhere_spec.rb',
    'spec/spec_helper.rb'
  ]
  s.homepage = 'http://github.com/intothefire/ruby-postcodeanywhere'
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.rubygems_version = '1.8.5'
  s.summary = 'Gem to provide basic access to PostcodeAnywhere services'

  if s.respond_to? :specification_version
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
      s.add_runtime_dependency('httparty', ['>= 0'])
      s.add_development_dependency('bundler', ['>= 0'])
      s.add_development_dependency('jeweler', ['~> 1.6.2'])
      s.add_dependency('bundler', ['>= 0'])
      s.add_development_dependency('rspec', ['~> 2.3.0'])
    else
      s.add_dependency('bundler', ['>= 0'])
      s.add_dependency('httparty', ['>= 0'])
      s.add_dependency('jeweler', ['~> 1.6.2'])
      s.add_dependency('jeweler', ['~> 1.6.2'])
      s.add_dependency('rspec', ['~> 2.3.0'])
    end
  else
    s.add_dependency('httparty', ['>= 0'])
    s.add_dependency('rspec', ['~> 2.3.0'])
  end
end
