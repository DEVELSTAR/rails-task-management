class AddColumnsToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :status, :string, default: 'todo'
    add_column :tasks, :due_date, :date
  end
end
