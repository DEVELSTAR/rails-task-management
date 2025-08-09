# app/admin/packages.rb
ActiveAdmin.register Package do
  permit_params :title, :description, :price, :discount, :duration, :thumbnail,
                course_ids: []

  form do |f|
    f.semantic_errors

    f.inputs "Package Details" do
      f.input :title
      f.input :description
      f.input :price
      f.input :discount
      f.input :duration, hint: "Duration in days"
      f.input :thumbnail, as: :file, hint: f.object.thumbnail.attached? ? image_tag(f.object.thumbnail, style: 'max-width: 200px;') : content_tag(:span, "No thumbnail yet")
    end

    f.inputs "Courses" do
      f.input :courses, as: :check_boxes, collection: Course.all
    end

    f.actions
  end

  index do
    selectable_column
    id_column
    column :title
    column :price
    column :discount
    column :duration
    column "Thumbnail" do |pkg|
      if pkg.thumbnail.attached?
        image_tag pkg.thumbnail, style: "width: 50px; height: auto;"
      else
        "No image"
      end
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :description
      row :price
      row :discount
      row :duration
      row :thumbnail do |pkg|
        if pkg.thumbnail.attached?
          image_tag pkg.thumbnail, style: "max-width: 300px;"
        else
          "No image"
        end
      end
      row :created_at
      row :updated_at
    end

    panel "Courses in this Package" do
      table_for package.courses do
        column :title
        column :created_at
      end
    end
  end
end
