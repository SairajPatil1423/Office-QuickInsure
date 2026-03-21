class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor

  validates :apt_date, presence: true
  validates :duration, presence: true

  validate :slot_valid

  after_initialize do
    self.status ||= "scheduled"
  end

  def slot_valid
    return if doctor.nil? || apt_time.nil?

    if doctor.status == "inactive"
      errors.add(:base, "Doctor not available")
      return
    end

    if apt_time < doctor.start_time || apt_time >= doctor.end_time
      errors.add(:base, "Outside working hours")
      return
    end

    unless valid_slot_time?
      errors.add(:base, "Invalid slot")
      return
    end

    if self.class.slot_conflict?(self)
      errors.add(:base, "Slot already booked")
    end
  end

  def valid_slot_time?
    slot = doctor.start_time
    while slot < doctor.end_time
      return true if slot.strftime("%H:%M") == apt_time.strftime("%H:%M")
      slot += doctor.slot_duration.minutes
    end
    false
  end

  def self.slot_conflict?(appointment)
    start_time = appointment.apt_time
    end_time = start_time + appointment.duration.minutes

    where(apt_date: appointment.apt_date)
      .where("doctor_id = ? OR patient_id = ?", appointment.doctor_id, appointment.patient_id)
      .any? do |appt|
        existing_start = appt.apt_time
        existing_end = existing_start + appt.duration.minutes
        (start_time < existing_end) && (end_time > existing_start)
      end
  end

  def self.top_3_peak_hours
    group("DATE_PART('hour', apt_time)")
      .order("COUNT(*) DESC")
      .limit(3)
      .select("DATE_PART('hour', apt_time) AS hour, COUNT(*) AS total_appointments")
  end
  
  def as_json(options = {})
    super(options).merge(
      "apt_time" => apt_time.strftime("%H:%M")
    )
  end
end