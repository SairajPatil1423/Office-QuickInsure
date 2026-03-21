require 'faker'

puts "Cleaning database..."

Appointment.destroy_all
Admission.destroy_all
Bill.destroy_all

Patient.destroy_all
Doctor.destroy_all
Department.destroy_all
Bed.destroy_all
Ward.destroy_all


dept_names = [
  "Cardiology", "Neurology", "Orthopedics",
  "Dermatology", "Pediatrics", "Oncology"
]

departments = dept_names.map do |name|
  Department.create!(name: name)
end

puts "Created #{Department.count} departments"

30.times do
  Doctor.create!(
    name: Faker::Name.name,
    specialization: dept_names.sample,
    phone: Faker::Number.unique.number(digits: 10),
    email: Faker::Internet.unique.email,
    salary: rand(50000..150000),
    status: ["active", "inactive"].sample,
    department: departments.sample,
    consultation_fee: [300, 500, 700].sample,
    start_time: "10:00",
    end_time: "17:00",
    slot_duration: [15, 30].sample
  )
end

puts "Created #{Doctor.count} doctors"

200.times do
  Patient.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone: Faker::Number.unique.number(digits: 10),
    dob: Faker::Date.birthday(min_age: 18, max_age: 80),
    gender: ["male", "female"].sample,
    email: Faker::Internet.unique.email,
    address: Faker::Address.full_address,
    blood_group: ["A+", "B+", "O+", "AB+", "A-", "B-"].sample,
    registration_date: Date.today - rand(1..30).days
  )
end

puts "Created #{Patient.count} patients"

wards_data = [
  { name: "General Ward", type: "general", beds: 120 },
  { name: "ICU", type: "critical", beds: 50 },
  { name: "Emergency", type: "emergency", beds: 40 },
  { name: "Maternity", type: "special", beds: 40 },
  { name: "Pediatric", type: "special", beds: 50 }
]

wards_data.each do |ward_data|
  ward = Ward.create!(
    ward_name: ward_data[:name],
    ward_type: ward_data[:type],
    capacity: ward_data[:beds]
  )

  ward_data[:beds].times do |i|
    Bed.create!(
      ward: ward,
      bed_number: "#{ward.ward_name[0..2].upcase}-#{i+1}",
      status: "available",
      price_per_day: case ward.ward_type
                     when "general" then 2000
                     when "critical" then 5000
                     else 3000
                     end
    )
  end
end

puts "Created #{Ward.count} wards"
puts "Created #{Bed.count} beds"

patients = Patient.all
doctors  = Doctor.where(status: "active")

300.times do
  patient = patients.sample
  doctor  = doctors.sample

  next unless doctor

  date = Date.today - rand(0..5).days

 
  start_time = doctor.start_time
  slot = start_time + (rand(0..10) * doctor.slot_duration).minutes

  appointment = Appointment.new(
    patient_id: patient.id,
    doctor_id: doctor.id,
    apt_date: date,
    apt_time: slot,
    duration: doctor.slot_duration,
    status: "scheduled"
  )

  next if Appointment.slot_conflict?(appointment)

  appointment.save!
end

puts "Created #{Appointment.count} appointments"

puts "SEEDING DONE SUCCESSFULLY"