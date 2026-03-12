# simple class inheritance
class Animal

  attr_accessor :name
  def initialize(name)
    @name=name
  end
end
 
class Cat<Animal
  def initialize(name)
   super
  end
end

p= Cat.new("meoww")
puts p.name

