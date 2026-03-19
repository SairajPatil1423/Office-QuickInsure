Patient.destroy_all
Doctor.destroy_all
Department.destroy_all


patients_data = [
  ["Virat","Kohli"], ["Rohit","Sharma"], ["MS","Dhoni"], ["Sachin","Tendulkar"],
  ["Hardik","Pandya"], ["KL","Rahul"], ["Jasprit","Bumrah"], ["Ravindra","Jadeja"],
  ["Shubman","Gill"], ["Rishabh","Pant"], ["Yuvraj","Singh"], ["Suresh","Raina"],
  ["Rahul","Dravid"], ["Sourav","Ganguly"], ["Anil","Kumble"], ["Zaheer","Khan"],
  ["Harbhajan","Singh"], ["Mohammad","Shami"], ["Ishan","Kishan"], ["Surya","Yadav"],

  ["Shah","Rukh"], ["Salman","Khan"], ["Aamir","Khan"], ["Ranbir","Kapoor"],
  ["Ranveer","Singh"], ["Hrithik","Roshan"], ["Akshay","Kumar"], ["Ajay","Devgn"],
  ["Tiger","Shroff"], ["Varun","Dhawan"],

  ["Deepika","Padukone"], ["Alia","Bhatt"], ["Katrina","Kaif"], ["Kareena","Kapoor"],
  ["Priyanka","Chopra"], ["Anushka","Sharma"], ["Kiara","Advani"], ["Shraddha","Kapoor"],
  ["Kriti","Sanon"], ["Disha","Patani"],

  ["Rajinikanth","Superstar"], ["Kamal","Haasan"], ["Vijay","Thalapathy"], ["Allu","Arjun"],
  ["Prabhas","Raju"], ["Ram","Charan"], ["NTR","Jr"], ["Yash","Rocky"],
  ["Dulquer","Salmaan"], ["Fahadh","Faasil"]
]

patients_data.each_with_index do |(first, last), i|
  Patient.create!(
    first_name: first,
    last_name: last,
    phone: "90000000#{i+1}",
    dob: Date.today - rand(20..60).years,
    gender: ["male", "female"].sample,
    email: "#{first.downcase}#{i+1}@mail.com",
    address: ["Mumbai", "Delhi", "Bangalore", "Chennai", "Hyderabad"].sample,
    blood_group: ["A+", "B+", "O+", "AB+", "A-", "B-"].sample,
    registration_date: Date.today
  )
end

puts " Created #{Patient.count} patients"

dept_names = [
  "Cardiology",
  "Neurology",
  "Orthopedics",
  "Dermatology"
]

departments = {}  

dept_names.each do |name|
  dept = Department.create!(name: name)
  departments[name] = dept.id   
end

doctors_data = [
  ["Virat", "Cardiology"],
  ["Rohit", "Neurology"],
  ["Dhoni", "Orthopedics"],
  ["Sachin", "Cardiology"],
  ["Hardik", "Dermatology"],
  ["Rahul", "Neurology"],
  ["Bumrah", "Orthopedics"],
  ["Jadeja", "Cardiology"],
  ["Gill", "Dermatology"],
  ["Pant", "Neurology"]
]

doctors_data.each_with_index do |(name, dept_name), i|
  Doctor.create!(
    name: "Dr #{name}",
    specialization: dept_name,
    phone: "91111111#{i}",
    email: "dr#{name.downcase}@hospital.com",
    salary: rand(50000..150000),
    status: "active",
    department_id: departments[dept_name] 
  )
end

puts " Created #{Doctor.count} doctors"