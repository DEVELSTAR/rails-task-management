# app/admin/quran_verses.rb
ActiveAdmin.register QuranVerse do
  menu priority: 101
  actions :all, except: [:new, :edit]

  LANGUAGES = {
    "English (Asad)" => "en.asad",
    "Urdu (Junagarhi)" => "ur.junagarhi",
    "Indonesian" => "id.indonesian",
    "French (Hamidullah)" => "fr.hamidullah"
  }.freeze

  index do
    selectable_column
    id_column
    column :surah_name
    column :verse_number
    column :language
    column :text
    column :created_at
    actions
  end

  filter :language
  filter :surah_name
  filter :created_at

  collection_action :fetch_and_save, method: :post do
    language = params[:language] || Api::V1::QuranVerseFetcherService::DEFAULT_LANG

    begin
      Api::V1::QuranVerseFetcherService.call(nil, language)
      redirect_to admin_quran_verses_path, notice: "New Quran verse (#{language}) fetched and saved!"
    rescue => e
      redirect_to admin_quran_verses_path, alert: e.message
    end
  end

  action_item :fetch, only: :index do
    raw(
      form_tag(fetch_and_save_admin_quran_verses_path, method: :post) do
        select_tag(:language, options_for_select(LANGUAGES)) +
        submit_tag("Fetch New Quran Verse", class: "button")
      end
    )
  end
end
