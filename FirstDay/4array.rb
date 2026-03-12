#declaration
arr=[[1, 'one', :one, [2, 'two', :two]]]
arr2=[1,2,3,4,5,6,7,8,9,10]

print arr
puts
print arr2
puts
# literals of array
print %w[hello i am sai]

# range operations
array= Array(1..10)
print array

# accessing elements
arr = [1,2,3,4]
puts "accessing elements"
puts arr[0]
puts arr[2]
puts "push"
arr.push(5)
print arr
puts
puts "pop"
arr.pop
print arr
puts
puts arr.include?(3)

# iterating on array
arr = [1,2,3]
puts
puts "iterations"
arr.each do |num|
  puts num
end

# map operation on elements
arr = [1,2,3]
puts "map operation"
result = arr.map do |x|
  x * 2
end
puts result

# select elements from array
arr = [1,2,3,4,5]
puts "select operation"
even = arr.select do |x|
  x % 2 == 0
end
puts even

#length
puts "length of array #{arr.length}"