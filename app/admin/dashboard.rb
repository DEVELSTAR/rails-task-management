# app/admin/dashboard.rb
require 'ostruct' # Added to fix NameError

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "Dashboard"

  content title: "Task Management Dashboard" do
    div class: "bg-white p-6 rounded-lg shadow-lg mb-6" do
      h2 class: "text-xl font-bold text-gray-800 mb-4" do
        "Overview"
      end
      columns do
        column do
          panel "Users" do
            div class: "text-center" do
              strong class: "text-2xl text-blue-600" do
                User.count
              end
              div class: "text-gray-600" do
                "Total Users"
              end
            end
          end
        end
        column do
          panel "Admin Users" do
            div class: "text-center" do
              strong class: "text-2xl text-blue-600" do
                AdminUser.count
              end
              div class: "text-gray-600" do
                "Total Admin Users"
              end
            end
          end
        end
        column do
          panel "Tasks" do
            div class: "text-center" do
              strong class: "text-2xl text-blue-600" do
                Task.count
              end
              div class: "text-gray-600" do
                "Total Tasks"
              end
            end
          end
        end
      end
    end

    div class: "bg-white p-6 rounded-lg shadow-lg mb-6" do
      h2 class: "text-xl font-bold text-gray-800 mb-4" do
        "Tasks by Status"
      end
      table_for [OpenStruct.new(status: "Todo", count: Task.where(status: "todo").count),
                 OpenStruct.new(status: "In Progress", count: Task.where(status: "in_progress").count),
                 OpenStruct.new(status: "Done", count: Task.where(status: "done").count)] do
        column :status, class: "text-gray-700"
        column :count, class: "text-blue-600 font-semibold"
      end
    end

    div class: "bg-white p-6 rounded-lg shadow-lg" do
      h2 class: "text-xl font-bold text-gray-800 mb-4" do
        "Recent Tasks"
      end
      table_for Task.order(created_at: :desc).limit(5) do
        column :title do |task|
          link_to task.title, admin_task_path(task), class: "text-blue-600 hover:underline"
        end
        column :status, class: "text-gray-700"
        column :due_date, class: "text-gray-700"
        column :user do |task|
          task.user.email
        end
      end
    end
  end
end