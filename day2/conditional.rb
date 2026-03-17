# conditional statements in ruby

# nil,false->gives only false or condition
# 0 "" gives true 
# if nil
#   puts "true"
# else
#   puts "false"
# end

# if ""
#   puts "true"
# else
#   puts "false"
# end


# case 
# puts "enter a marks"
# marks = gets.chomp.to_i

# case marks
# when (1..39)
#   puts "Fail ! "
# when (40..60)
#   puts "Grade A "
# when (61..75)
#   puts "Grade A+"
# when (76..100)
#   puts "Grade A++ Distinction  yeah :)"
# else
#   puts "Invalid Marks lol "
# end

# unless 
# age = 16
# unless age < 18
#   puts "Get a job."
# end

# single line conditional statement
age = 15
response = age < 18 ? "jindgi jile" : "kuch kam krle"
puts response 

