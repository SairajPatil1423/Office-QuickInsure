class Api::V1::AdmissionsController < ApplicationController

  def create
    result = Admission.admit_patient(params[:patient_id], params[:bed_id])

    if result[:error]
      render json: { error: result[:error] }, status: 422
    else
      render json: result[:admission], status: :created
    end
  end

  def discharge
    admission = Admission.find_by(id: params[:id])
    return render json: { error: "Admission not found" }, status: 404 unless admission

    result = admission.discharge!

    if result[:error]
      render json: { error: result[:error] }, status: 422
    else
      render json: { message: result[:success], status: :ok }
    end
  end

end