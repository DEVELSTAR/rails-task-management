# app/admin/courses.rb
ActiveAdmin.register Course do
  permit_params :title, :description, :duration, :slug, :image, :price, :status, :level, :language, :is_published,
                course_modules_attributes: [:id, :title, :description, :position, :_destroy],
                lessons_attributes: [
                  :id, :title, :description, :position, :course_module_id, :_destroy,
                  lesson_contents_attributes: [:id, :content_type, :position, :content_data, :_destroy],
                  lesson_assessment_attributes: [
                    :id, :title, :instructions, :_destroy,
                    assessment_questions_attributes: [
                      :id, :question_text, :options, :correct_option, :explanation, :_destroy
                    ]
                  ]
                ]

  index do
    selectable_column
    id_column
    column :title
    column :description
    column :duration
    column :slug
    column :status
    column :level
    column :is_published
    actions
  end

  form do |f|
    f.semantic_errors

    f.inputs "Course Details" do
      f.input :title
      f.input :description
      f.input :duration
      f.input :slug
      f.input :image
      f.input :price
      f.input :status
      f.input :level
      f.input :language
      f.input :is_published
    end

    f.has_many :course_modules, allow_destroy: true, heading: "Modules", new_record: true do |mod_f|
      mod_f.input :title
      mod_f.input :description
      mod_f.input :position
    end

    f.has_many :lessons, allow_destroy: true, heading: "Lessons", new_record: true do |lesson_f|
      lesson_f.input :title
      lesson_f.input :description
      lesson_f.input :position
      lesson_f.input :course_module

      lesson_f.has_many :lesson_contents, allow_destroy: true, heading: "Contents", new_record: true do |content_f|
        content_f.input :content_type, as: :select, collection: LessonContent.content_types.keys
        content_f.input :position
        content_f.input :content_data, as: :text
      end

      # lesson_f.has_one :lesson_assessment, allow_destroy: true, heading: "Assessment", new_record: true do |assess_f|
      #   assess_f.input :title
      #   assess_f.input :instructions

      #   assess_f.has_many :assessment_questions, allow_destroy: true, heading: "Questions", new_record: true do |q_f|
      #     q_f.input :question_text
      #     q_f.input :options, as: :tags
      #     q_f.input :correct_option
      #     q_f.input :explanation
      #   end
      # end

      lesson_f.has_many :lesson_assessment, allow_destroy: true, heading: "Assessment", new_record: true do |assess_f|
        if lesson_f.object.lesson_assessment.present?
          assess_f.input :title
          assess_f.input :instructions

          assess_f.has_many :assessment_questions, allow_destroy: true, heading: "Questions", new_record: true do |q_f|
            q_f.input :question_text
            q_f.input :options, as: :tags
            q_f.input :correct_option
            q_f.input :explanation
          end
        end
      end
    end

    f.actions
  end
end
