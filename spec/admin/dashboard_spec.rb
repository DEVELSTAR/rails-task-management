require "rails_helper"

RSpec.describe "Admin::Dashboard", type: :feature do
  let!(:admin_user) { AdminUser.create!(email: "admin@example.com", password: "password") }
  let!(:course) do
    FactoryBot.create(
      :course,
      title: "Ruby 101",
      price: 99.99,
      course_modules_count: 3,
      user_course_enrollments_count: 5
    )
  end
  let!(:user) { User.create!(email: "user@example.com", password: "password") }
  let!(:enrollment_completed) { UserCourseEnrollment.create!(user: user, course: course, status: "completed", progress: 100) }
  let!(:enrollment_in_progress) { UserCourseEnrollment.create!(user: user, course: course, status: "in_progress", progress: 50) }

  before do
    visit admin_login_path
    fill_in "Email", with: admin_user.email
    fill_in "Password", with: "password"
    click_button "Login"
    expect(page).to have_content("Dashboard")
    visit admin_login_path
    fill_in "Email", with: admin_user.email
    fill_in "Password", with: "password"
    click_button "Login"
    expect(page).to have_content("Dashboard")
  end

  it "displays the Courses Overview panel" do
    visit admin_dashboard_path
    expect(page).to have_content("Courses Overview")
    expect(page).to have_link("Ruby 101", href: admin_course_path(course))
    expect(page).to have_content("$99.99")
    expect(page).to have_content("3")  # modules
    expect(page).to have_content("5")  # students enrolled
    expect(page).to have_link("View All Courses", href: admin_courses_path)
  end

  it "displays the Admin Users panel" do
    visit admin_dashboard_path
    expect(page).to have_content("Admin Users")
    expect(page).to have_content(admin_user.email)
    expect(page).to have_content("1") # mocked sign_in_count
  end

  it "displays the Users & Enrollments panel" do
    visit admin_dashboard_path
    expect(page).to have_content("Users & Enrollments")
    expect(page).to have_content(user.email)
    expect(page).to have_content("1") # completed courses count
    expect(page).to have_content("1") # in progress courses count
    expect(page).to have_content("Ruby 101: 100%")
    expect(page).to have_content("Ruby 101: 50%")
    expect(page).to have_link("View All Users", href: admin_users_path)
  end

  it "displays the charts section" do
    visit admin_dashboard_path
    expect(page).to have_content("Course Enrollments Chart")
    expect(page).to have_content("Course Completion Chart")
  end
end
