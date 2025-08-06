# app/admin/dashboard.rb
require 'ostruct'

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "Dashboard"

  content title: "Task Management Dashboard" do
    # ----------------------------
    # Overview Stats
    # ----------------------------
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
        column do
          panel "Cat Facts" do
            div class: "text-center" do
              strong class: "text-2xl text-blue-600" do
                CatFact.count
              end
              div class: "text-gray-600" do
                "Total Cat Facts"
              end
            end
          end
        end
        column do
          panel "Quran" do
            div class: "text-center" do
              strong class: "text-2xl text-blue-600" do
                QuranVerse.count
              end
              div class: "text-gray-600" do
                "Total Quran Verses"
              end
            end
          end
        end
      end
    end

    # ----------------------------
    # Task Status Table
    # ----------------------------
    div class: "bg-white p-6 rounded-lg shadow-lg mb-6" do
      h2 class: "text-xl font-bold text-gray-800 mb-4" do
        "Tasks by Status"
      end
      table_for [
        OpenStruct.new(status: "Todo", count: Task.where(status: "todo").count),
        OpenStruct.new(status: "In Progress", count: Task.where(status: "in_progress").count),
        OpenStruct.new(status: "Done", count: Task.where(status: "done").count)
      ] do
        column :status, class: "text-gray-700"
        column :count, class: "text-blue-600 font-semibold"
      end
    end

    # ----------------------------
    # Recent Tasks
    # ----------------------------
    div class: "bg-white p-6 rounded-lg shadow-lg mb-6" do
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

    # ----------------------------
    # Recent Cat Facts
    # ----------------------------
    div class: "bg-white p-6 rounded-lg shadow-lg mb-6" do
      h2 class: "text-xl font-bold text-gray-800 mb-4" do
        "Recent Cat Facts"
      end
      table_for CatFact.order(created_at: :desc).limit(5) do
        column :fact
        column "Created" do |verse|
          formatted_time_ago(verse.created_at)
        end
      end
      div class: "mt-2" do
        link_to "View All Cat Facts", admin_cat_facts_path, class: "button"
      end
    end

    # ----------------------------
    # Recent Quran Verses
    # ----------------------------
    div class: "bg-white p-6 rounded-lg shadow-lg" do
      h2 class: "text-xl font-bold text-gray-800 mb-4" do
        "Recent Quran Verses"
      end
      table_for QuranVerse.order(created_at: :desc).limit(5) do
        column :surah_name
        column :verse_number
        column :language
        column :text
      end
      div class: "mt-2" do
        link_to "View All Quran Verses", admin_quran_verses_path, class: "button"
      end
    end
  end
end
