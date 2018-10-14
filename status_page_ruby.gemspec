require File.expand_path('lib/status_page_ruby/version', __dir__)

Gem::Specification.new do |gem|
  gem.name          = 'status_page_ruby'
  gem.version       = StatusPageRuby::VERSION
  gem.date          = '2018-10-14'
  gem.summary       = 'Status page commandline tool.'
  gem.description   = 'Status page tool parses, stores and report statuses of web services.'
  gem.authors       = ['Konstantin Lynda']
  gem.email         = 'knlynda@gmail.com'
  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ['lib']
  gem.bindir        = 'bin'
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.homepage      = 'http://rubygems.org/gems/status_page_ruby'
  gem.license       = 'MIT'

  gem.add_runtime_dependency 'nokogiri'
  gem.add_runtime_dependency 'thor'
end
