class Doctor < ApplicationRecord
  belongs_to :department
  has_many :appointments

  validates :name, presence: true

  after_initialize do
    self.consultation_fee ||= 500
    self.start_time ||= "10:00"
    self.end_time ||= "17:00"
    self.slot_duration ||= 30
    self.status ||= "active"
  end

  def available_slots(date)
    return [] if status == "inactive"

    slots = []
    current_time = start_time

    while current_time < end_time
      slot_end = current_time + slot_duration.minutes

      booked = appointments.where(apt_date: date).any? do |appt|
        existing_start = appt.apt_time
        existing_end = existing_start + appt.duration.minutes
        (current_time < existing_end) && (slot_end > existing_start)
      end

      slots << current_time.strftime("%H:%M") unless booked
      current_time = slot_end
    end

    slots
  end
end