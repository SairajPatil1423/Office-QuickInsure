class Api::V1::BillsController < ApplicationController

  def create
    result = Bill.generate_bill(params[:patient_id])

    if result[:error]
      render json: { error: result[:error] }, status: 422
    else
      render json: result[:bill], status: :created
    end
  end

end