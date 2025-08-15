# spec/admin/courses_spec.rb
require 'rails_helper'

RSpec.describe "Admin::Courses", type: :feature do
  let!(:admin_user) { AdminUser.create!(email: "admin@example.com", password: "password") }

  let!(:course) { create(:course, :with_full_structure, :with_thumbnail) }

  before do
    login_as_admin(admin_user)
  end

  it "shows the courses index" do
    visit admin_courses_path
    expect(page).to have_content("Ruby Basics")
    expect(page).to have_content("draft")
    expect(page).to have_content("beginner")
  end

  it "shows a course details page" do
    visit admin_course_path(course)
    expect(page).to have_content("Ruby Basics")
    expect(page).to have_content("Learn the fundamentals of Ruby")
  end

  it "edits a course" do
    visit edit_admin_course_path(course)

    fill_in "Title", with: "Updated Ruby Basics", match: :first
    select "published", from: "Status"
    click_button "Update Course"

    expect(page).to have_content("Updated Ruby Basics")
    expect(page).to have_content("published")
  end

  it "duplicates a course using the Clone Course button" do
    visit admin_course_path(course)

    click_link "Clone Course"

    expect(page).to have_content("Course cloned successfully")
    expect(Course.count).to eq(2)
    expect(Course.last.title).to match(/Ruby Basics-Copy/)
  end

  it "deletes a course", js: true do
    visit admin_courses_path

    accept_confirm do
      click_link "Delete", href: admin_course_path(course)
    end

    expect(page).not_to have_content("Ruby Basics")
    expect(Course.count).to eq(0)
  end
end
