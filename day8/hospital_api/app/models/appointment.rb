class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor

  validates :apt_date, presence: true
  validates :status, inclusion: { in: %w[scheduled completed cancelled] }
  validates :duration, presence: true,
                       numericality: { greater_than: 10, less_than_or_equal_to: 180 }

  validate :valid_time_slot

  after_initialize do
    self.status ||= "scheduled"
  end

  def valid_time_slot
    return if apt_time.blank?

    errors.add(:apt_time, "must be valid time") unless apt_time.present?
  end

  
  def self.slot_conflict?(appointment)
    start_time = appointment.apt_time
    end_time   = start_time + appointment.duration.minutes

    where(apt_date: appointment.apt_date)
      .where("doctor_id = ? OR patient_id = ?", appointment.doctor_id, appointment.patient_id)
      .any? do |appt|
        existing_start = appt.apt_time
        existing_end   = existing_start + appt.duration.minutes

        (start_time < existing_end) && (end_time > existing_start)
      end
  end
end