class Api::V1::DepartmentsController < ApplicationController

  def index
    departments = Department.all
    render json: departments
  end

 
  def show
    department = Department.find(params[:id])
    render json: department
  end


  def create
    department = Department.new(department_params)

    if department.save
      render json: department, status: :created
    else
      render json: { errors: department.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    department = Department.find(params[:id])

    if department.update(department_params)
      render json: department
    else
      render json: { errors: department.errors.full_messages }
    end
  end

  def destroy
    department = Department.find(params[:id])
    department.destroy

    render json: { message: "Department deleted" }
  end

  private

  def department_params
    params.require(:department).permit(:name, :dept_head_id)
  end
end