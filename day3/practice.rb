class Bank
 attr_accessor :id,:name
 @@count=0;
 def self.show
   puts @@count
 end
  def initialize
  @id
  @name
  @@count+=1
  puts "object created"
  end
end

obj= Bank.new;
obj.id=1
obj.name="sairaj"
puts "id #{obj.id} name #{obj.name}"
Bank.show
obj2= Bank.new;
obj2.id=1
obj2.name="sairaj"
puts "id #{obj.id} name #{obj.name}"
Bank.show

