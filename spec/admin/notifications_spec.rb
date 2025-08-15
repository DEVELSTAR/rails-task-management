# spec/admin/notifications_spec.rb
require 'rails_helper'

RSpec.describe "Admin::Notifications", type: :feature do
  let!(:admin_user) { AdminUser.create!(email: "admin@example.com", password: "password") }
  let!(:user) { create(:user, email: "user@example.com") }
  let!(:course) { create(:course, title: "Ruby Basics") }

  let!(:read_notification) do
    create(:notification, user: user, course: course, notification_type: :enrolled, read: true)
  end

  let!(:unread_notification) do
    create(:notification, user: user, course: course, notification_type: :lesson_completed, read: false)
  end

  before do
    login_as_admin(admin_user)
  end

  it "lists notifications" do
    visit admin_notifications_path

    expect(page).to have_content(read_notification.description)
    expect(page).to have_content(unread_notification.description)
    expect(page).to have_content(user.email)
    expect(page).to have_content(course.title)
  end

  it "marks a notification as read" do
    visit admin_notifications_path
    within("tr", text: unread_notification.description) do
      click_link "Read"
    end

    expect(page).to have_content("Marked as read.")
    unread_notification.reload
    expect(unread_notification.read).to eq(true)
  end

  it "marks a notification as unread" do
    visit admin_notifications_path
    within("tr", text: read_notification.description) do
      click_link "Unread"
    end

    expect(page).to have_content("Marked as unread.")
    read_notification.reload
    expect(read_notification.read).to eq(false)
  end

  it "filters notifications by user" do
    visit admin_notifications_path
    select user.email, from: "User"
    click_button "Filter"

    expect(page).to have_content(user.email)
    expect(page).to have_content(course.title)
  end
end
