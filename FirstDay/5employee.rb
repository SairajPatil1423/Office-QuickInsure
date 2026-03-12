employee = {

  1 => {
    name: "madhav",
    age: 23,
    sal: 38000
  },
  2 => {
    name: "abc",
    age: 25,
    sal: 45000
  },
  3 => {
    name: "xyz",
    age: 28,
    sal: 80000
  },
  4 => {
    name: "pqr",
    age: 38,
    sal: 150000
  },
  5 => {
    name: "sai",
    age: 22,
    sal: 38000
  }
}

def add_emp(emp)
  id = emp.keys.max + 1

  print "Enter name: "
  name = gets.chomp

  print "Enter age: "
  age = gets.chomp.to_i

  print "Enter salary: "
  sal = gets.chomp.to_i

  emp[id] = {name: name, age: age, sal: sal}

  puts "Employee added successfully!"
end

def update(emp)
  puts "Enter employee id to update"
  id = gets.chomp.to_i

  if emp[id]

    puts "Enter 1:name 2:age 3:salary"
    inp = gets.chomp.to_i

    if inp == 1
      puts "Enter new name"
      new_name = gets.chomp
      emp[id][:name] = new_name

    elsif inp == 2
      puts "Enter new age"
      new_age = gets.chomp.to_i
      emp[id][:age] = new_age

    elsif inp == 3
      puts "Enter new salary"
      new_sal = gets.chomp.to_i
      emp[id][:sal] = new_sal

    else
      puts "Invalid option"
    end
  else
    puts "Employee not found"
  end
end
def display(emp)
  emp.each do |id,data|
    puts "ID: #{id}"
    puts "name: #{data[:name]}"
    puts "age: #{data[:age]}"
    puts "sal: #{data[:sal]}"
    puts "_____________________"
  end
end

def find(emp)
  puts "Enter employee id to find"
  id = gets.chomp.to_i
  
  if emp[id]
    puts "name: #{emp[id][:name]}"
    puts "name: #{emp[id][:age]}"
    puts "name: #{emp[id][:sal]}"
  else 
    puts "Employee not found"
  end
end

def delete(emp)
  puts "Enter employee id to delete"
  id = gets.chomp.to_i
  if emp[id]
    emp.delete(id)
    "employee #{id} deleted"
  else 
    puts "Employee not found"
  end
end

# add_emp(employee)
# update(employee)
# find(employee)
# delete(employee)
# display(employee)
