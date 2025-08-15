require 'rails_helper'

RSpec.describe "AdminUsers", type: :feature do
  let!(:admin_user) { AdminUser.create!(email: "admin@example.com", password: "password", password_confirmation: "password") }

  before do
    login_as_admin(admin_user)
  end

  it "shows admin users index" do
    visit admin_admin_users_path
    expect(page).to have_content("Admin Users")
    expect(page).to have_content(admin_user.email)
  end

  it "creates a new admin user" do
    visit new_admin_admin_user_path

    fill_in "Email", with: "new_admin@example.com"
    fill_in "Password", with: "securepass"
    fill_in "Password confirmation", with: "securepass"
    click_button "Create Admin user"

    expect(page).to have_content("new_admin@example.com")
  end

  it "edits an admin user without changing password" do
    visit edit_admin_admin_user_path(admin_user)

    fill_in "Email", with: "updated_admin@example.com"
    fill_in "Password", with: ""
    fill_in "Password confirmation", with: ""
    click_button "Update Admin user"

    expect(page).to have_content("updated_admin@example.com")
    admin_user.reload
    expect(admin_user.authenticate("password")).to be_truthy
  end

  it "shows validation error for password mismatch" do
    visit edit_admin_admin_user_path(admin_user)

    fill_in "Password", with: "newpass"
    fill_in "Password confirmation", with: "mismatch"
    click_button "Update Admin user"

    expect(page).to have_content("doesn't match Password")
    admin_user.reload
    expect(admin_user.authenticate("password")).to be_truthy
  end

  it "deletes an admin user", js: true do
    visit admin_admin_users_path
    accept_confirm do
      click_link "Delete", href: admin_admin_user_path(admin_user)
    end
    expect(page).not_to have_content(admin_user.email)
  end
end
