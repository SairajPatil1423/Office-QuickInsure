class Api::V1::DoctorsController < ApplicationController

  
  def index
    doctors = Doctor.includes(:department)
    render json: doctors, include: :department
  end

  def show
    doctor = Doctor.find(params[:id])
    render json: doctor, include: :department
  end

 
  def create
    department = Department.find_by(id: params[:doctor][:department_id])

    if department.nil?
      return render json: { error: "Invalid department" }, status: :unprocessable_entity
    end

    doctor = Doctor.new(doctor_params)

    if doctor.save
      render json: doctor, status: :created
    else
      render json: { errors: doctor.errors.full_messages }, status: :unprocessable_entity
    end
  end

 
  def update
    doctor = Doctor.find(params[:id])

    if doctor.update(doctor_params)
      render json: doctor
    else
      render json: { errors: doctor.errors.full_messages }, status: :unprocessable_entity
    end
  end

 
  def destroy
    doctor = Doctor.find(params[:id])
    doctor.destroy

    render json: { message: "Doctor deleted successfully" }
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
      :department_id
    )
  end
end