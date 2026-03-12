#polymorphism

class Duck

  def speak
    puts "duck quacks"
  end
  private
  def fly
    puts "duck flys"
  end
end

class Person
  def speak
    puts "man speaks"
  end
end

def make_speak(object)
  object.speak
end
make_speak(Duck.new)
make_speak(Person.new)

#respond to
puts Duck.new.respond_to?(:speak)
puts Duck.new.respond_to?(:fly)
#send
puts Duck.new.send(:speak)
puts Duck.new.send(:fly)

