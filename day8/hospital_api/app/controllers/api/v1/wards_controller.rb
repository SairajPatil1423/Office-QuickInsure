class Api::V1::WardsController < ApplicationController

  def index
    wards = Ward.all
    render json: wards
  end

  def create
    ward = Ward.new(ward_params)

    if ward.save
      render json: ward, status: :created
    else
      render json: { errors: ward.errors.full_messages }, status: 422
    end
  end

  private

  def ward_params
    params.require(:ward).permit(:ward_name, :ward_type, :capacity)
  end
end