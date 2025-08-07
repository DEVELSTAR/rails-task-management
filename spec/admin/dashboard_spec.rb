require "rails_helper"

RSpec.describe "Admin::Dashboard", type: :feature do
  let!(:admin_user) { AdminUser.create!(email: "admin@example.com", password: "password") }
  let!(:user) { User.create!(email: "user@example.com", password: "password") }

  before do
    # Create various records to test dashboard counts
    2.times { CatFact.create!(fact: "Cats have five toes.") }
    3.times { QuranVerse.create!(surah_name: "Al-Fatiha", verse_number: 1, language: "en.asad", text: "In the name of Allah") }
    Task.create!(title: "Todo Task", status: "todo", user: user)
    Task.create!(title: "In Progress Task", status: "in_progress", user: user)
    Task.create!(title: "Done Task", status: "done", user: user)

    visit admin_login_path
    fill_in "Email", with: admin_user.email
    fill_in "Password", with: "password"
    click_button "Login"
    expect(page).to have_content("Dashboard")
  end

  it "displays counts for Users, Admin Users, Tasks, Cat Facts, Quran Verses" do
    visit admin_dashboard_path
    expect(page).to have_content("Total Users")
    expect(page).to have_content(User.count.to_s)

    expect(page).to have_content("Total Admin Users")
    expect(page).to have_content(AdminUser.count.to_s)

    expect(page).to have_content("Total Tasks")
    expect(page).to have_content(Task.count.to_s)

    expect(page).to have_content("Total Cat Facts")
    expect(page).to have_content(CatFact.count.to_s)

    expect(page).to have_content("Total Quran Verses")
    expect(page).to have_content(QuranVerse.count.to_s)
  end

  it "displays tasks grouped by status" do
    visit admin_dashboard_path
    expect(page).to have_content("Tasks by Status")
    expect(page).to have_content("Todo")
    expect(page).to have_content("In Progress")
    expect(page).to have_content("Done")
    expect(page).to have_content("1") # for each task status created above
  end

  it "shows recent tasks with details" do
    visit admin_dashboard_path
    expect(page).to have_content("Recent Tasks")
    expect(page).to have_link("Todo Task")
    expect(page).to have_link("In Progress Task")
    expect(page).to have_link("Done Task")
    expect(page).to have_content("user@example.com")
  end

  it "shows recent cat facts with link to all" do
    visit admin_dashboard_path
    expect(page).to have_content("Recent Cat Facts")
    expect(page).to have_content("Cats have five toes.")
    expect(page).to have_link("View All Cat Facts", href: admin_cat_facts_path)
  end

  it "shows recent Quran verses with link to all" do
    visit admin_dashboard_path
    expect(page).to have_content("Recent Quran Verses")
    expect(page).to have_content("Al-Fatiha")
    expect(page).to have_content("1")
    expect(page).to have_content("en.asad")
    expect(page).to have_link("View All Quran Verses", href: admin_quran_verses_path)
  end
end
