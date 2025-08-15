# spec/admin/users_spec.rb
require 'rails_helper'

RSpec.describe "Admin::Users", type: :feature do
  let!(:admin_user) { AdminUser.create!(email: "admin@example.com", password: "password") }
  let!(:user) { User.create!(email: "user@example.com", password: "userpass") }

  before do
    login_as_admin(admin_user)
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
  
  it "shows user addresses in the show page" do
    user_with_address = User.create!(
      email: "address_user@example.com",
      password: "password",
      profile: Profile.new(name: "Address User"),
      addresses: [
        Address.new(
          line1: "123 Main St",
          line2: "Apt 4B",
          city: "Springfield",
          state: "IL",
          zip: "62704",
          country: "USA"
        )
      ]
    )

    visit admin_user_path(user_with_address)

    expect(page).to have_content("123 Main St")
    expect(page).to have_content("Apt 4B")
    expect(page).to have_content("Springfield")
    expect(page).to have_content("IL")
    expect(page).to have_content("62704")
    expect(page).to have_content("USA")
  end
end
