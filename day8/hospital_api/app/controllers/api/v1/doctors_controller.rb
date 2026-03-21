class Api::V1::DoctorsController < ApplicationController

  def index
    render json: Doctor.includes(:department), include: :department
  end

  def show
    doctor = Doctor.find_by(id: params[:id])
    return render json: { error: "Not found" }, status: 404 unless doctor

    render json: doctor, include: :department
  end

  def create
    doctor = Doctor.new(doctor_params)

    if doctor.save
      render json: doctor, status: :created
    else
      render json: { errors: doctor.errors.full_messages }, status: 422
    end
  end

  def update
    doctor = Doctor.find_by(id: params[:id])
    return render json: { error: "Not found" }, status: 404 unless doctor

    if doctor.update(doctor_params)
      render json: doctor
    else
      render json: { errors: doctor.errors.full_messages }, status: 422
    end
  end

  def destroy
    doctor = Doctor.find_by(id: params[:id])
    return render json: { error: "Not found" }, status: 404 unless doctor

    doctor.destroy
    render json: { message: "Deleted" }
  end

  def slots
    doctor = Doctor.find_by(id: params[:id])
    return render json: { error: "Not found" }, status: 404 unless doctor

    dates = (Date.today..Date.today+2).to_a

    result = dates.map do |d|
      {
        date: d,
        slots: doctor.available_slots(d)
      }
    end

    render json: result
  end

  private

  def doctor_params
    params.require(:doctor).permit(
      :name,
      :specialization,
      :phone,
      :email,
      :salary,
      :status,
      :department_id,
      :consultation_fee,
      :start_time,
      :end_time,
      :slot_duration
    )
  end
end