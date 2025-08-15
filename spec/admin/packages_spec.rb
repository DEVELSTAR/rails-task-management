# spec/system/admin/packages_spec.rb
require "rails_helper"

RSpec.describe "Admin::Packages", type: :feature do
  let!(:admin_user) { create(:admin_user) }
  let!(:course1) { create(:course, title: "Course A") }
  let!(:course2) { create(:course, title: "Course B") }

  before do
    login_as_admin(admin_user)
  end

  it "creates a new package with courses" do
    visit admin_packages_path

    click_link "New Package"

    fill_in "Title", with: "Premium Package"
    fill_in "Description", with: "Includes multiple courses"
    fill_in "Price", with: "99.99"
    fill_in "Discount", with: "10"
    fill_in "Duration", with: "30"

    # Attach a thumbnail (ensure you have a thumbnail file in spec/support/assets)
    attach_file "Thumbnail", Rails.root.join("spec/support/assets/thumbnail.png")

    check "Course A"
    check "Course B"

    click_button "Create Package"

    expect(page).to have_content("Package was successfully created")
    expect(page).to have_content("Premium Package")
    expect(page).to have_content("99.99")
    expect(page).to have_content("Course A")
    expect(page).to have_content("Course B")
  end

  it "shows the package details" do
    package = create(:package, title: "Starter Package", courses: [course1])
    visit admin_package_path(package)

    expect(page).to have_content("Starter Package")
    expect(page).to have_content(course1.title)
  end

  it "lists packages in index view" do
    package = create(:package, title: "List Package", price: 49.99)
    visit admin_packages_path

    expect(page).to have_content("List Package")
    expect(page).to have_content("49.99")
  end
end
