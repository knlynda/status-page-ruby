require 'rubygems'
require 'bundler/setup'

require 'tempfile'

require 'status_page_ruby'
require 'status_page_ruby_cli'

RSpec.configure(&:disable_monkey_patching!)
