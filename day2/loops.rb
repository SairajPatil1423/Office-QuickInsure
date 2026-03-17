# for loop
# for i in 0..5
#   puts "#{i+1} zombieeessss!"
# end

# times loop
# 5.times do |num|
#   num=5
#   puts "num is #{num}"

# end

# loop
# i = 1
# loop do
#   puts "i is #{i*3}"
#   i += 1
#   break if i == 11
# end

# while
# i = 1
# while i < 11 do
#  puts "i is #{i*2}"
#  i += 1
# end

# while gets.chomp != "yes" do
#   puts "Are you coming home "
# end

# until loop
# i=1
# until i>=11
#   puts "#{i*5}"
#   i+=1
# end

#  upto | downto
# 5.upto(10) {|x| print "num #{x}"}
# puts
# 10.downto(5) {|x| print "num #{x}"}

# yield
# def logger
#   puts "before yield"
#   yield
#   puts "after yield"
# end
#  logger{ puts "this is logger fun"}

# logger do
#   p [1,2,3]
# end

#proc ->procedure
# p = Proc.new do
#   puts "inside proc"
# end
# p.call

# proc = Proc.new {|x|  puts " #{x*x}" } 
#  proc.call(5)

def call_proc
  puts "before proc"
  my_proc=Proc.new{return 2}
  my_proc.call
  puts "after proc"
end
p call_proc

my_lambda = ->{return 1}
puts ""