require 'rubygems'
require 'bundler/setup'

require 'tempfile'
require 'timecop'

require 'status_page_ruby'
require 'status_page_ruby_cli'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.after do
    Timecop.return
  end
end
