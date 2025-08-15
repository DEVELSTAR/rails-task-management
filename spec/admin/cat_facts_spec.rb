require 'rails_helper'

RSpec.describe "Admin::CatFacts", type: :feature do
  let!(:admin_user) { AdminUser.create!(email: "admin@example.com", password: "password") }
  let!(:cat_fact) { CatFact.create!(fact: "Cats sleep 70% of their lives.") }

  before do
    login_as_admin(admin_user)
  end

  it "displays cat facts on the index page" do
    visit admin_cat_facts_path
    expect(page).to have_content("Cats sleep 70% of their lives.")
  end

  it "shows a Fetch New Cat Fact button" do
    visit admin_cat_facts_path
    expect(page).to have_link("Fetch New Cat Fact")
  end

  it "calls the fetch_and_save action successfully" do
    allow(Api::V1::CatFactFetcherService).to receive(:call)

    visit admin_cat_facts_path
    click_link "Fetch New Cat Fact"

    expect(Api::V1::CatFactFetcherService).to have_received(:call)
    expect(page).to have_content("New cat fact fetched and saved")
  end

  it "shows error if fetch service raises exception" do
    allow(Api::V1::CatFactFetcherService).to receive(:call).and_raise("API limit exceeded")

    visit admin_cat_facts_path
    click_link "Fetch New Cat Fact"

    expect(page).to have_content("API limit exceeded")
  end
end
