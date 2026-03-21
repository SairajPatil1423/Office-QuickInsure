class Api::V1::DepartmentsController < ApplicationController

  def index
    render json: Department.all
  end

  def show
    department = Department.find_by(id: params[:id])
    return render json: { error: "Not found" }, status: 404 unless department

    render json: department
  end

  def create
    department = Department.new(department_params)

    if department.save
      render json: department, status: :created
    else
      render json: { errors: department.errors.full_messages }, status: 422
    end
  end

  def update
    department = Department.find_by(id: params[:id])
    return render json: { error: "Not found" }, status: 404 unless department

    if department.update(department_params)
      render json: department
    else
      render json: { errors: department.errors.full_messages }, status: 422
    end
  end

  def destroy
    department = Department.find_by(id: params[:id])
    return render json: { error: "Not found" }, status: 404 unless department

    department.destroy
    render json: { message: "Deleted" }
  end

  private

  def department_params
    params.require(:department).permit(:name)
  end
end