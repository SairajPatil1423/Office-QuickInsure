class Api::V1::PatientsController < ApplicationController

  def index
    patients = Patient.all
    render json: patients
  end

  def show
    patient = Patient.find_by(id: params[:id])

    return render json: { error: "Patient not found" }, status: :not_found unless patient

    render json: patient
  end

  def create
    patient = Patient.new(patient_params)

    if patient.save
      render json: patient, status: :created
    else
      render json: { errors: patient.errors.full_messages }, status: :unprocessable_entity
    end
  end

 
  def update
    patient = Patient.find_by(id: params[:id])

    return render json: { error: "Patient not found" }, status: :not_found unless patient

    if patient.update(patient_params)
      render json: patient
    else
      render json: { errors: patient.errors.full_messages }, status: :unprocessable_entity
    end
  end

 
  def destroy
    patient = Patient.find_by(id: params[:id])

    return render json: { error: "Patient not found" }, status: :not_found unless patient

    patient.destroy
    render json: { message: "Patient deleted successfully" }
  end

  private

  def patient_params
    params.require(:patient).permit(
      :first_name,
      :last_name,
      :phone,
      :dob,
      :gender,
      :email,
      :address,
      :blood_group,
      :registration_date
    )
  end
end