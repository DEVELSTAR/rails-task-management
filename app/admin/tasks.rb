# app/admin/tasks.rb
ActiveAdmin.register Task do
  permit_params :title, :description, :status, :due_date, :user_id

  index do
    selectable_column
    id_column
    column :title
    column :status
    column :due_date
    column :user
    column :created_at
    actions
  end

  filter :title
  filter :status, as: :select, collection: %w[todo in_progress done]
  filter :due_date
  filter :user_email, as: :string
  filter :created_at

  scope :all
#   scope :todo
#   scope :in_progress
#   scope :done

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
