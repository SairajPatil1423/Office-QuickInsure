string="this Is First string"
# string operations
puts string.capitalize  #capitalize operations
puts string.downcase #downcase operation
puts string.upcase #upcase operation
puts string.swapcase #swapcase operation
# concat operation
p=string+"this is new string"
puts p
string.concat(" this is new word")
puts string
# reverse operation
puts string.reverse
# length
puts string.length

# empty
puts string.empty?

# include 
puts string.include?("abc")

# match
puts string.match?("t")

# index 
puts string.rindex("t",0)

# split
print string.split(" ")

#iteration
str = "ruby"
puts
str.each_char do |c|
  puts c
end

# word count
r="ruby is fast and ruby is fun"
puts r.split(" ").count

# palindrome check
pal="sasa"
if pal.reverse==pal
  puts "palindrome"
else
  puts "not palindrome"
end

# vowels count
str = "programming"
count = 0

str.each_char do |c|
  if "aeiou".include?(c)
    count += 1
  end
end

puts count

# replace substring
puts "replace operation"
str = "ruby programming"
puts str.gsub("ruby","python")

