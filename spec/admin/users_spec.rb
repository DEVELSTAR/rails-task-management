# spec/admin/users_spec.rb
require 'rails_helper'

RSpec.describe "Admin::Users", type: :feature do
  let!(:admin_user) { AdminUser.create!(email: "admin@example.com", password: "password") }
  let!(:user) { User.create!(email: "user@example.com", password: "userpass") }

  before do
    visit admin_login_path

    fill_in "Email", with: admin_user.email
    fill_in "Password", with: "password"
    click_button "Login"

    expect(page).to have_content("Dashboard")
  end

  it "shows the user index" do
    visit admin_users_path
    expect(page).to have_content("Users")
    expect(page).to have_content(user.email)
  end

it "creates a new user" do
  visit new_admin_user_path

  fill_in "Email", with: "newuser@example.com"
  fill_in "Password", with: "secure123"
  fill_in "Password confirmation", with: "secure123"
  fill_in "Name", with: "Test Name" # <-- add this
  click_button "Create User"

  expect(page).to have_content("newuser@example.com")
end

it "updates user without changing password" do
  visit edit_admin_user_path(user)

  fill_in "Email", with: "updated_user@example.com"
  fill_in "Name", with: "Updated Name" # <-- add this
  fill_in "Password", with: ""
  fill_in "Password confirmation", with: ""
  click_button "Update User"

  expect(page).to have_content("updated_user@example.com")
  user.reload
  expect(user.authenticate("userpass")).to be_truthy
end


  it "shows validation error for password mismatch" do
    visit edit_admin_user_path(user)

    fill_in "Password", with: "newpass"
    fill_in "Password confirmation", with: "wrong"
    click_button "Update User"

    expect(page).to have_content("doesn't match Password")
    user.reload
    expect(user.authenticate("userpass")).to be_truthy
  end
end
