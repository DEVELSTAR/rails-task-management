# app/admin/cat_facts.rb
ActiveAdmin.register CatFact do
  menu priority: 100
  actions :all, except: [ :new, :edit ]

  index do
    selectable_column
    id_column
    column :fact
    column :created_at do |col|
      formatted_time_ago(col.created_at)
    end
    actions
  end

  filter :source
  filter :created_at

  collection_action :fetch_and_save, method: :post do
    begin
      Api::V1::CatFactFetcherService.call
      redirect_to admin_cat_facts_path, notice: "New cat fact fetched and saved!"
    rescue => e
      redirect_to admin_cat_facts_path, alert: e.message
    end
  end

  action_item :fetch, only: :index do
    link_to "Fetch New Cat Fact", fetch_and_save_admin_cat_facts_path, method: :post
  end
end
