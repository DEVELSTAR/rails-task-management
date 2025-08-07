# spec/admin/tasks_spec.rb
require 'rails_helper'

RSpec.describe "Admin::Tasks", type: :feature do
  let!(:admin_user) { AdminUser.create!(email: "admin@example.com", password: "password") }
  let!(:user) { User.create!(email: "user@example.com", password: "userpass") }
  let!(:task) { Task.create!(title: "Sample Task", description: "Some details", status: "todo", user: user, due_date: Date.today + 1.week) }

  before do
    visit admin_login_path

    fill_in "Email", with: admin_user.email
    fill_in "Password", with: "password"
    click_button "Login"

    expect(page).to have_content("Dashboard")
  end

  it "shows the task index" do
    visit admin_tasks_path
    expect(page).to have_content("Sample Task")
    expect(page).to have_content("todo")
    expect(page).to have_content(user.email)
  end

  it "edits a task" do
    visit edit_admin_task_path(task)

    fill_in "Title", with: "Updated Task Title"
    select "in_progress", from: "Status"
    click_button "Update Task"

    expect(page).to have_content("Updated Task Title")
    expect(page).to have_content("in_progress")
  end

  it "updates task status using custom action" do
    visit admin_tasks_path

    click_link "Mark as In Progress"

    expect(page).to have_content("Status updated to in_progress")
    task.reload
    expect(task.status).to eq("in_progress")
  end

  it "deletes a task", js: true do
    visit admin_tasks_path

    accept_confirm do
      click_link "Delete", href: admin_task_path(task)
    end

    expect(page).not_to have_content("Sample Task")
  end
end
