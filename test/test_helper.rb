if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'test/'
    add_filter 'pkg/'
    add_filter 'vendor/'
  end
end
