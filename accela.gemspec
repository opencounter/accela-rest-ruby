$LOAD_PATH.push File.expand_path('lib', __dir__)

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

  s.add_runtime_dependency   'activesupport'
  s.add_runtime_dependency   'faraday', '>= 2.0.1'
  s.add_runtime_dependency   'faraday-detailed_logger'
  s.add_runtime_dependency   'faraday-multipart'

  s.add_development_dependency 'debug'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
