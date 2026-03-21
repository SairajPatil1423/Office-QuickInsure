class Api::V1::BillsController < ApplicationController

  def index
    bills = Bill.includes(:patient)
    render json: bills, include: :patient
  end

  def show
    bill = Bill.find_by(id: params[:id])
    return render json: { error: "Bill not found" }, status: 404 unless bill

    render json: bill, include: :patient
  end

  def create
    result = Bill.generate(params[:patient_id])

    if result[:error]
      render json: { error: result[:error] }, status: 422
    else
      render json: result, status: :created
    end
  end

end