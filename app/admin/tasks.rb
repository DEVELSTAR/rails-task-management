# app/admin/tasks.rb
ActiveAdmin.register Task do
  permit_params :title, :description, :status, :due_date, :user_id

  filter :title
  filter :status, as: :select, collection: %w[todo in_progress done]
  filter :due_date
  filter :user_email, as: :string
  filter :created_at

  scope :all
  scope :todo
  scope :in_progress
  scope :done

  index do
    selectable_column
    id_column
    column :title
    column :status
    column :due_date
    column :user
    column :created_at
    actions defaults: true do |task|
      next_status = case task.status
                    when "todo" then "in_progress"
                    when "in_progress" then "done"
                    else "todo"
                    end

      link_to "Mark as #{next_status.titleize}", update_status_admin_task_path(task, status: next_status), method: :put
    end
  end

  member_action :update_status, method: :put do
    resource.update(status: params[:status])
    redirect_to admin_tasks_path, notice: "Status updated to #{params[:status]}"
  end

  form do |f|
    f.inputs do
      f.input :user
      f.input :title
      f.input :description
      f.input :status, as: :select, collection: %w[todo in_progress done]
      f.input :due_date, as: :date_picker
    end
    f.actions
  end
end
