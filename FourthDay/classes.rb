# simple class inheritance
# class Animal

#   attr_accessor :name
#   def initialize(name)
#     @name=name
#   end
# end
 
# class Cat<Animal
#   def initialize(name)
#    super
#   end
# end

# p= Cat.new("meoww")
# puts p.name

# methods in classes
# class MathUtil
#   def self.add(a,b)
#     a+b
#   end
# end

# puts MathUtil.add(2,3)

# class variables

# class Counter
#   @@count = 0

#   def initialize
#     @@count += 1
#   end

#   def self.show
#     puts @@count
#   end
# end

# Counter.new
# Counter.new

# Counter.show

# public / private methods
# class Test
#   def show
#     puts "public method"
#   end

#   private

#   def secret
#     puts "private method"
#   end
# end
# t=Test.new
# t.show
# t.secret

