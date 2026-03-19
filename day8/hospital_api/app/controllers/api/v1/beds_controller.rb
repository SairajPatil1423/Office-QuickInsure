class Api::V1::BedsController < ApplicationController

  def index
    beds = Bed.all
    render json: beds
  end

  def create
    ward = Ward.find_by(id: params[:bed][:ward_id])
    return render json: { error: "Ward not found" }, status: 404 unless ward

    bed = Bed.new(bed_params)

    if bed.save
      render json: bed, status: :created
    else
      render json: { errors: bed.errors.full_messages }, status: 422
    end
  end

  private

  def bed_params
    params.require(:bed).permit(:ward_id, :bed_number, :status)
  end
end