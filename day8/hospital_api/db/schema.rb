# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_03_21_045555) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "admissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "patient_id", null: false
    t.uuid "bed_id", null: false
    t.date "admission_date"
    t.date "discharge_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bed_id"], name: "index_admissions_on_bed_id"
    t.index ["patient_id"], name: "index_admissions_on_patient_id"
  end

  create_table "appointments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "patient_id", null: false
    t.uuid "doctor_id", null: false
    t.date "apt_date"
    t.time "apt_time"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration", default: 30, null: false
    t.index ["doctor_id"], name: "index_appointments_on_doctor_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
  end

  create_table "beds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "bed_number"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "ward_id"
    t.index ["ward_id"], name: "index_beds_on_ward_id"
  end

  create_table "bills", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "patient_id", null: false
    t.decimal "total_amount"
    t.string "payment_status"
    t.date "payment_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_bills_on_patient_id"
  end

  create_table "departments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "dept_head_id"
    t.index ["dept_head_id"], name: "index_departments_on_dept_head_id"
  end

  create_table "doctors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "specialization"
    t.string "phone"
    t.string "email"
    t.decimal "salary", precision: 10, scale: 2
    t.string "status"
    t.uuid "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "consultation_fee", default: "500.0"
    t.time "start_time"
    t.time "end_time"
    t.integer "slot_duration", default: 30
    t.index ["department_id"], name: "index_doctors_on_department_id"
  end

  create_table "medicines", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.integer "stock_qty"
    t.date "expiry_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.date "dob"
    t.string "gender"
    t.string "email"
    t.text "address"
    t.string "blood_group"
    t.date "registration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prescription_medicines", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "prescription_id", null: false
    t.uuid "medicine_id", null: false
    t.string "dosage"
    t.string "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medicine_id"], name: "index_prescription_medicines_on_medicine_id"
    t.index ["prescription_id"], name: "index_prescription_medicines_on_prescription_id"
  end

  create_table "prescriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "patient_id", null: false
    t.uuid "doctor_id", null: false
    t.date "date"
    t.text "diagnosis"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_prescriptions_on_doctor_id"
    t.index ["patient_id"], name: "index_prescriptions_on_patient_id"
  end

  create_table "rooms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ward_id", null: false
    t.string "room_number"
    t.string "room_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ward_id"], name: "index_rooms_on_ward_id"
  end

  create_table "wards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "ward_name"
    t.string "ward_type"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "admissions", "beds"
  add_foreign_key "admissions", "patients"
  add_foreign_key "appointments", "doctors"
  add_foreign_key "appointments", "patients"
  add_foreign_key "beds", "wards"
  add_foreign_key "bills", "patients"
  add_foreign_key "departments", "doctors", column: "dept_head_id"
  add_foreign_key "doctors", "departments"
  add_foreign_key "prescription_medicines", "medicines"
  add_foreign_key "prescription_medicines", "prescriptions"
  add_foreign_key "prescriptions", "doctors"
  add_foreign_key "prescriptions", "patients"
  add_foreign_key "rooms", "wards"
end
