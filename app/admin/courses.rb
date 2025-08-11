ActiveAdmin.register Course do
  permit_params :title, :description, :duration, :slug, :thumbnail, :price, :status, :level, :language,
    course_modules_attributes: [
      :id, :title, :description, :position, :_destroy,
      lessons_attributes: [
        :id, :title, :description, :position, :course_module_id, :_destroy,
        lesson_contents_attributes: [:id, :content_type, :image, :video, :position, :content_data, :_destroy],
        lesson_assessment_attributes: [
          :id, :title, :instructions, :_destroy,
          assessment_questions_attributes: [
            :id, :question_text, :explanation, :_destroy,
            assessment_answers_attributes: [:id, :answer_text, :is_correct, :_destroy]
          ]
        ]
      ]
    ],
    final_assessment_attributes: [
      :id, :title, :instructions, :_destroy,
      assessment_questions_attributes: [
        :id, :question_text, :explanation, :_destroy,
        assessment_answers_attributes: [:id, :answer_text, :is_correct, :_destroy]
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
    column :language
    actions
  end

  member_action :clone, method: :post do
    original = Course.find(params[:id])
    cloned = original.dup
    random_number = rand(1000..9999)
    cloned.title = "#{original.title}-Copy (#{random_number})"
    cloned.slug  = "#{original.slug}-Copy #{random_number}"
    cloned.save!

    # Clone course modules
    original.course_modules.each do |mod|
      cloned_mod = mod.dup
      cloned_mod.course_id = cloned.id
      cloned_mod.save!

      # Clone lessons
      mod.lessons.each do |lesson|
        cloned_lesson = lesson.dup
        cloned_lesson.course_module_id = cloned_mod.id
        cloned_lesson.save!

        # Clone lesson contents
        lesson.lesson_contents.each do |content|
          cloned_content = content.dup
          cloned_content.lesson_id = cloned_lesson.id
          cloned_content.save!
        end

        # Clone lesson assessment
        if lesson.lesson_assessment
          cloned_final = lesson.lesson_assessment.dup
          cloned_final.assessable = cloned
          cloned_final.save!

          lesson.lesson_assessment.assessment_questions.each do |q|
            cloned_q = q.dup
            cloned_q.assessment = cloned_final
            cloned_q.save!

            q.assessment_answers.each do |a|
              cloned_a = a.dup
              cloned_a.assessment_question = cloned_q
              cloned_a.save!
            end
          end
        end
      end
    end

    # Clone final assessment
    if original.final_assessment
      cloned_final = original.final_assessment.dup
      # cloned_final.course_id = cloned.id
      cloned_final.save!

      original.final_assessment.assessment_questions.each do |q|
        cloned_q = q.dup
        cloned_q.assessment_id = cloned_final.id
        cloned_q.save!

        q.assessment_answers.each do |a|
          cloned_a = a.dup
          cloned_a.assessment_question_id = cloned_q.id
          cloned_a.save!
        end
      end
    end

    redirect_to admin_course_path(cloned), notice: "Course cloned successfully."
  end

  # Add button to UI
  action_item :clone, only: :show do
    link_to "Clone Course", clone_admin_course_path(resource), method: :post
  end

  form do |f|
    f.semantic_errors

    f.inputs "Course Details" do
      f.input :title
      f.input :description
      f.input :duration
      f.input :slug
      f.input :thumbnail, as: :file
      f.input :price
      f.input :status, as: :select, collection: Course.statuses.keys
      f.input :level, as: :select, collection: Course.levels.keys
      f.input :language
    end

    f.inputs "Modules" do
      f.has_many :course_modules, allow_destroy: true, new_record: "Add Module" do |mod_f|
        mod_f.input :title
        mod_f.input :description
        mod_f.input :position

        mod_f.has_many :lessons, allow_destroy: true, new_record: "Add Lesson" do |lesson_f|
          lesson_f.input :title
          lesson_f.input :description
          lesson_f.input :position

          lesson_f.has_many :lesson_contents, allow_destroy: true, new_record: "Add Content" do |content_f|
            content_f.input :content_type, as: :select, collection: LessonContent.content_types.keys
            content_f.input :content_data
            content_f.input :image, as: :file
            content_f.input :video, as: :file
            content_f.input :content_data
            content_f.input :position
          end

          lesson_f.has_many :lesson_assessment, allow_destroy: true, new_record: "Add Assessment" do |assess_f|
            assess_f.input :title
            assess_f.input :instructions
            assess_f.has_many :assessment_questions, allow_destroy: true, new_record: "Add Question" do |q_f|
              q_f.input :question_text
              q_f.input :explanation
              q_f.has_many :assessment_answers, allow_destroy: true, new_record: "Add Answers" do |a_f|
                a_f.input :answer_text
                a_f.input :is_correct
              end
            end
          end
        end
      end
    end

    f.inputs "Final Assessment" do
      f.has_many :final_assessment, allow_destroy: true, new_record: "Add Final Assessment" do |final_f|
        final_f.input :title
        final_f.input :instructions
        final_f.has_many :assessment_questions, allow_destroy: true, new_record: "Add Question" do |q_f|
          q_f.input :question_text
          q_f.input :explanation
          q_f.has_many :assessment_answers, allow_destroy: true, new_record: "Add Answers" do |a_f|
            a_f.input :answer_text
            a_f.input :is_correct
          end
        end
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :title
      row :description
      row :duration
      row :slug
      row :price
      row :status
      row :level
      row :language
      row :thumbnail do |course|
        if course.thumbnail.attached?
          image_tag course.thumbnail, style: "max-width: 300px;"
        else
          "No thumbnail"
        end
      end
    end

    panel "Modules & Lessons" do
      course.course_modules.order(:position).each do |mod|
        panel "Module: #{mod.title} (Position: #{mod.position})" do
          para mod.description
          mod.lessons.order(:position).each do |lesson|
            panel "Lesson: #{lesson.title} (Position: #{lesson.position})" do
              para lesson.description

              if lesson.lesson_contents.any?
                table_for lesson.lesson_contents.order(:position) do
                  column("Content Type") { |c| c.content_type }
                  column("Data") { |c| c.content_data }
                  column("Image") do |c|
                    if c.image.attached?
                      image_tag url_for(c.image), size: "100x100"
                    end
                  end
                  column("Video") do |c|
                    if c.video.attached?
                      link_to "View Video", url_for(c.video), target: "_blank"
                    end
                  end
                  column("Position") { |c| c.position }
                end
              end

              if lesson.lesson_assessment
                panel "Lesson Assessment: #{lesson.lesson_assessment.title}" do
                  para lesson.lesson_assessment.instructions
                  if lesson.lesson_assessment.assessment_questions.any?
                    table_for lesson.lesson_assessment.assessment_questions do
                      column :question_text
                      column :explanation
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    if course.final_assessment
      panel "Final Assessment: #{course.final_assessment.title}" do
        para course.final_assessment.instructions
        if course.final_assessment.assessment_questions.any?
          table_for course.final_assessment.assessment_questions do
            column :question_text
            column :explanation
          end
        end
      end
    end
  end
end
