module Greetings
  def say_hi
    puts "this is hi"
  end
  def say_bye
    puts "this is bye"
  end
end
module Greet
  def say_hi
    puts "this is greet hi"
  end
  def say_bye
    puts "this is greet bye"
  end
end


class Person
  include Greetings
  include Greet
end
puts Person.ancestors
p=Person.new
p.say_hi
p.say_bye



