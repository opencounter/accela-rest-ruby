$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'accela/version'

Gem::Specification.new do |s|
  s.name           = 'accela'
  s.version        = Accela::Version::String
  s.author         = 'Accela'
  s.email          = 'devsupport@accela.com'
  s.homepage       = 'https://developer.accela.com/'

  s.summary        = 'Accela Ruby Client Library'
  s.description    = 'This gem provides access to the HTTP Accela API'
  s.license        = 'MIT'

  s.files          = Dir.glob ['README.md', 'LICENSE', 'lib/**/*.{rb}', 'spec/**/*', '*.gemspec']
  s.has_rdoc       = false

  s.add_runtime_dependency   'faraday', '~> 0.9'
  s.add_runtime_dependency   'faraday-detailed_logger', '>= 1.0.0'
  s.add_runtime_dependency   'activesupport', '~> 4.2.1'

  s.add_development_dependency 'rake', "~> 10.3.2"
  s.add_development_dependency 'rspec', "~> 3.1.0"
  s.add_development_dependency 'pry', "~> 0.10.1"
  s.add_development_dependency 'vcr', "~> 2.9.2"
  s.add_development_dependency 'webmock', "~> 1.18.0"
end
