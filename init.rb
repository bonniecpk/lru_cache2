require 'pry'
require 'pry-nav'

Dir['lib/**/*.rb'].each do |file|
  require_relative file
end
