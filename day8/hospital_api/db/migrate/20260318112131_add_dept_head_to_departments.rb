class AddDeptHeadToDepartments < ActiveRecord::Migration[7.1]
  def change
    add_reference :departments, :dept_head, type: :uuid, foreign_key: { to_table: :doctors }
  end
end