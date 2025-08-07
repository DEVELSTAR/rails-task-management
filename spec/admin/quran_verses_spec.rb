require 'rails_helper'

RSpec.describe "Admin::QuranVerses", type: :feature do
  let!(:admin_user) { AdminUser.create!(email: "admin@example.com", password: "password") }
  let!(:verse) do
    QuranVerse.create!(
      surah_name: "Al-Fatiha",
      verse_number: 1,
      language: "en.asad",
      text: "In the name of God, the Most Gracious, the Dispenser of Grace."
    )
  end

  before do
    visit admin_login_path
    fill_in "Email", with: admin_user.email
    fill_in "Password", with: "password"
    click_button "Login"
    expect(page).to have_content("Dashboard")
  end

  it "displays Quran verses in index" do
    visit admin_quran_verses_path
    expect(page).to have_content("Al-Fatiha")
    expect(page).to have_content("1")
    expect(page).to have_content("en.asad")
    expect(page).to have_content("In the name of God")
  end

  it "does not show New or Edit buttons" do
    visit admin_quran_verses_path
    expect(page).not_to have_link("New Quran Verse")
    within("table") do
      expect(page).not_to have_link("Edit")
    end
  end

  it "shows language dropdown and fetch button" do
    visit admin_quran_verses_path
    expect(page).to have_select("language", options: [
      "English (Asad)",
      "Urdu (Junagarhi)",
      "Indonesian",
      "French (Hamidullah)"
    ])
    expect(page).to have_button("Fetch New Quran Verse")
  end

  it "fetches a new verse with selected language" do
    allow(Api::V1::QuranVerseFetcherService).to receive(:call).with(nil, "ur.junagarhi")

    visit admin_quran_verses_path
    select "Urdu (Junagarhi)", from: "language"
    click_button "Fetch New Quran Verse"

    expect(Api::V1::QuranVerseFetcherService).to have_received(:call).with(nil, "ur.junagarhi")
    expect(page).to have_content("New Quran verse (ur.junagarhi) fetched and saved!")
  end

  it "shows error message if fetch fails" do
    allow(Api::V1::QuranVerseFetcherService).to receive(:call).and_raise("API down")

    visit admin_quran_verses_path
    click_button "Fetch New Quran Verse"

    expect(page).to have_content("API down")
  end
end
