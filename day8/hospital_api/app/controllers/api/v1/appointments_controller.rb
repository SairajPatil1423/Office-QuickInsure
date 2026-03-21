class Api::V1::AppointmentsController < ApplicationController

  def index
    appointments = Appointment.includes(:patient, :doctor)
    render json: appointments, include: [:patient, :doctor]
  end

  def show
    appointment = Appointment.find(params[:id])
    render json: appointment, include: [:patient, :doctor]
  end

  def create
    appointment = Appointment.new(appointment_params)

    return render json: { error: "Invalid patient" }, status: 422 unless Patient.exists?(appointment.patient_id)
    return render json: { error: "Invalid doctor" }, status: 422 unless Doctor.exists?(appointment.doctor_id)

    if Appointment.slot_conflict?(appointment)
      return render json: { error: "Time slot already booked (doctor/patient conflict)" }, status: 422
    end

    if appointment.save
      render json: appointment, status: :created
    else
      render json: { errors: appointment.errors.full_messages }, status: 422
    end
  end

  def update
    appointment = Appointment.find(params[:id])

    if appointment.update(appointment_params)
      render json: appointment
    else
      render json: { errors: appointment.errors.full_messages }, status: 422
    end
  end

  def destroy
    appointment = Appointment.find(params[:id])
    appointment.destroy

    render json: { message: "Appointment deleted" }
  end

  def top_peak_hours
    result = Appointment.top_3_peak_hours.map do |r|
      start_hour = r.hour.to_i
      end_hour = start_hour + 1

      {
        range: "#{format('%02d:00', start_hour)} - #{format('%02d:00', end_hour)}",
        total_appointments: r.total_appointments
      }
    end

    render json: result
  end

  private

  def appointment_params
    params.require(:appointment).permit(
      :patient_id,
      :doctor_id,
      :apt_date,
      :apt_time,
      :status,
      :duration
    )
  end
end
