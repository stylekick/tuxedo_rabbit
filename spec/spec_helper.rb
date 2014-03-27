require 'rspec/fire'
require 'tuxedo_rabbit'

RSpec.configure do |config|
  config.include(RSpec::Fire)
end

def deep_copy(obj)
  Marshal.load(Marshal.dump(obj))
end