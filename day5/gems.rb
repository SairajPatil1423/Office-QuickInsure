# frozen_string_literal: true

# using colorize gem

require 'colorize'
puts 'hello im red sai'.red
puts 'hello im black sai'.black

# using httpparty gem -- this gem used to fetch apis
require 'httparty'
response = HTTParty.get('https://jsonplaceholder.typicode.com/posts/1')

# puts response
puts response['title']


# faker --> dummy data gem
require 'faker'
5.times do
  puts Faker::Name.name
end
