# 🔥 CLEAR DATA (order matters)
Appointment.delete_all
Admission.delete_all
Bill.delete_all

Bed.delete_all
Ward.delete_all

Patient.delete_all
Doctor.delete_all
Department.delete_all

# 🔥 PATIENTS
patients_data = [
  ["Virat","Kohli"], ["Rohit","Sharma"], ["MS","Dhoni"], ["Sachin","Tendulkar"],
  ["Hardik","Pandya"], ["KL","Rahul"], ["Jasprit","Bumrah"], ["Ravindra","Jadeja"],
  ["Shubman","Gill"], ["Rishabh","Pant"], ["Yuvraj","Singh"], ["Suresh","Raina"],
  ["Rahul","Dravid"], ["Sourav","Ganguly"], ["Anil","Kumble"], ["Zaheer","Khan"],
  ["Harbhajan","Singh"], ["Mohammad","Shami"], ["Ishan","Kishan"], ["Surya","Yadav"],
  ["Shah","Rukh"], ["Salman","Khan"], ["Aamir","Khan"], ["Ranbir","Kapoor"],
  ["Ranveer","Singh"], ["Hrithik","Roshan"], ["Akshay","Kumar"], ["Ajay","Devgn"],
  ["Tiger","Shroff"], ["Varun","Dhawan"]
]

patients_data.each_with_index do |(first, last), i|
  Patient.create!(
    first_name: first,
    last_name: last,
    phone: "90000000#{i+1}",
    dob: Date.today - rand(20..60).years,
    gender: ["male", "female"].sample,
    email: "#{first.downcase}#{i+1}@mail.com",
    address: ["Mumbai", "Delhi", "Bangalore"].sample,
    blood_group: ["A+", "B+", "O+", "AB+"].sample,
    registration_date: Date.today
  )
end

puts "Created #{Patient.count} patients"

# 🔥 DEPARTMENTS
dept_names = ["Cardiology", "Neurology", "Orthopedics", "Dermatology"]

departments = {}
dept_names.each do |name|
  dept = Department.create!(name: name)
  departments[name] = dept.id
end

puts "Created #{Department.count} departments"

# 🔥 DOCTORS
doctors_data = [
  ["Virat", "Cardiology"],
  ["Rohit", "Neurology"],
  ["Dhoni", "Orthopedics"],
  ["Sachin", "Cardiology"],
  ["Hardik", "Dermatology"],
  ["Rahul", "Neurology"],
  ["Bumrah", "Orthopedics"],
  ["Jadeja", "Cardiology"]
]

doctors_data.each_with_index do |(name, dept), i|
  Doctor.create!(
    name: "Dr #{name}",
    specialization: dept,
    phone: "91111111#{i}",
    email: "dr#{name.downcase}@hospital.com",
    salary: rand(50000..150000),
    status: "active",
    consultation_fee: 500,
    start_time: "10:00",
    end_time: "17:00",
    slot_duration: [10, 20, 30].sample,
    department_id: departments[dept]
  )
end

puts "Created #{Doctor.count} doctors"

# 🔥 WARDS + BEDS
wards_data = [
  { name: "General Ward", type: "general", capacity: 10 },
  { name: "ICU", type: "icu", capacity: 5 },
  { name: "Emergency", type: "emergency", capacity: 6 }
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

puts "Created #{Ward.count} wards"
puts "Created #{Bed.count} beds"

# 🔥 APPOINTMENTS (VALID SLOTS)
patients = Patient.all
doctors  = Doctor.all

30.times do
  patient = patients.sample
  doctor  = doctors.sample
  date = Date.today + rand(0..2).days

  slots = doctor.available_slots(date)
  next if slots.empty?

  time = slots.sample

  appointment = Appointment.new(
    patient_id: patient.id,
    doctor_id: doctor.id,
    apt_date: date,
    apt_time: Time.parse(time),
    duration: doctor.slot_duration,
    status: "scheduled"
  )

  next unless appointment.valid?

  appointment.save!
end

puts "Created #{Appointment.count} appointments"