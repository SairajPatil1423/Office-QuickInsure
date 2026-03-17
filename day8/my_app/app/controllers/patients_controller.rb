class PatientsController < ApplicationController

  def index
    patients = Patient.all
    render json: patients
  end

  def create
  patient = Patient.new(patient_params)

  if patient.save
    render json: patient
  else
    render json: { errors: patient.errors.full_messages }
  end
  end
  
  private

  def patient_params
    params.permit(:first_name, :last_name, :phone)
  end

end