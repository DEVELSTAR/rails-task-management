# app/admin/users.rb
ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation,
                profile_attributes: [:id, :name, :bio, :avatar, :_destroy],
                addresses_attributes: [:id, :line1, :line2, :city, :state, :zip, :country, :_destroy]

  index do
    selectable_column
    id_column
    column :email
    column :created_at do |col|
      formatted_time_ago(col.created_at)
    end
    actions
  end

  filter :email
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end

    f.inputs "Profile", for: [:profile, f.object.profile || Profile.new] do |p|
      p.input :name
      p.input :bio
      p.input :avatar, as: :file
    end

    f.has_many :addresses, allow_destroy: true, new_record: "Add Address" do |a|
      a.input :line1
      a.input :line2
      a.input :city
      a.input :state
      a.input :zip
      a.input :country
    end

    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      super
    end
  end

  show do
    attributes_table do
      row :id
      row :email
      row :created_at
    end

    panel "Profile" do
      if resource.profile
        attributes_table_for resource.profile do
          row :name
          row :bio
          row :avatar do |p|
            if p.avatar.attached?
              image_tag url_for(p.avatar), height: 100
            else
              status_tag "No Avatar", :warning
            end
          end
        end
      else
        div class: "blank_slate_container" do
          span "No profile available"
        end
      end
    end

    panel "Addresses" do
      if resource.addresses.any?
        table_for resource.addresses do
          column :line1
          column :line2
          column :city
          column :state
          column :zip
          column :country
        end
      else
        div class: "blank_slate_container" do
          span "No addresses available"
        end
      end
    end
  end
end
