module  Speakable
  def greet
    puts "hi from #{self.class}"
  end
end
class Person
  include Speakable
end
class Robots
  extend Speakable
end

p=Person.new
p.greet
Robots.greet
