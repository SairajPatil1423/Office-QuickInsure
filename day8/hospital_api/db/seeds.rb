Appointment.destroy_all
Admission.destroy_all
PrescriptionMedicine.destroy_all
Prescription.destroy_all
Bill.destroy_all

Patient.destroy_all
Doctor.destroy_all
Department.destroy_all
Medicine.destroy_all
Bed.destroy_all
Room.destroy_all
Ward.destroy_all

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
puts " Created #{Department.count} departments"

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



patients = Patient.all
doctors  = Doctor.all

time_slots = [
  "10:00", "10:30", "11:00", "11:30",
  "12:00", "12:30", "14:00", "14:30",
  "15:00", "15:30"
]

20.times do
  patient = patients.sample
  doctor  = doctors.sample

  date = Date.today + rand(0..5).days
  time = time_slots.sample

  apt_time = Time.parse(time)

  appointment = Appointment.new(
    patient_id: patient.id,
    doctor_id: doctor.id,
    apt_date: date,
    apt_time: apt_time,
    status: "scheduled"
  )

  next if Appointment.slot_conflict?(appointment)

  appointment.save!
end

puts " Created #{Appointment.count} appointments"



Bed.delete_all
Ward.delete_all


wards_data = [
  { name: "General Ward", type: "general", capacity: 10 },
  { name: "ICU", type: "critical", capacity: 5 },
  { name: "Emergency", type: "emergency", capacity: 6 },
  { name: "Maternity", type: "special", capacity: 8 },
  { name: "Pediatric", type: "special", capacity: 7 }
]

wards_data.each do |ward_data|
  ward = Ward.create!(
    ward_name: ward_data[:name],
    ward_type: ward_data[:type],
    capacity: ward_data[:capacity]
  )

 
  ward.capacity.times do |i|
    Bed.create!(
      ward_id: ward.id,
      bed_number: "#{ward.ward_name[0..2].upcase}-#{i+1}",
      status: "available"
    )
  end
end

puts " Created #{Ward.count} wards"
puts " Created #{Bed.count} beds"