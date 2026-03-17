class Animal
  def speak
    puts "Animal sound"
  end
end

class Dog < Animal
  def speak
    super
    puts "Dog barks"
  end
end

class Cat<Animal
  def speak
    puts "Cats meoww"
  end
end
Dog.new.speak
Cat.new.speak
