# frozen_string_literal: true

# class Robots
#   def walk
#     puts "walking"
#   end
#   def talk
#     puts "talking"
#   end
#   def jump
#     puts "jumping"
#   end

# end

# r = Robots.new
# actions = [:walk,:talk,:jump,:swim]
# actions.each do |a|
#   puts r.send(a)
# end
class User
  attr_accessor :name, :email, :role

  def initialize(name, email, role)
    @name = name
    @email = email
    @role = role
  end
end

def find_by_attribute(users, attribute, value)
  users.select { |user| user.send(attribute) == value }
end

users = [
  User.new('alice', 'alice@123', :admin),
  User.new('bob', 'bob@123', :user),
  User.new('charlie', 'char@123', :admin)
]

admins = find_by_attribute(users, :role, :admin)

admins.each { |user| puts user.name }
