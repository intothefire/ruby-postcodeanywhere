Gem::Specification.new do |s|
  s.name = 'ruby-postcodeanywhere'
  s.version = '0.3.0'

  s.required_ruby_version = '>= 2.7.0'

  s.authors       = ['Funding Circle']
  s.email         = ['engineering@fundingcircle.com']
  s.summary       = 'Gem to provide basic access to PostcodeAnywhere services'
  s.description   = 'Gem to provide basic access to PostcodeAnywhere services'
  s.homepage      = 'http://github.com/FundingCircle/ruby-postcodeanywhere'
  s.licenses      = ['MIT']

  s.require_paths = ['lib']
  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.rdoc'
  ]
  s.files = [
    '.document',
    '.github/workflows/ci.yml',
    '.rspec',
    '.rubocop.yml',
    '.rubocop_todo.yml',
    '.ruby-version',
    'Gemfile',
    'Gemfile.lock',
    'LICENSE.txt',
    'README.rdoc',
    'Rakefile',
    'VERSION',
    'lib/postcode_anywhere/bank_account_validation.rb',
    'lib/ruby-postcodeanywhere.rb',
    'ruby-postcodeanywhere.gemspec',
    'spec/lib/postcode_anywhere/bank_account_validation_spec.rb',
    'spec/spec_helper.rb'
  ]

  s.add_dependency('activesupport', '>= 0')
  s.add_dependency('httparty', '>= 0')

  s.metadata['rubygems_mfa_required'] = 'true'
end
