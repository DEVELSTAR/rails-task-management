# app/admin/final_assessments.rb
ActiveAdmin.register FinalAssessment do
  permit_params :title, :instructions, :course_id,
                assessment_questions_attributes: [:id, :question_text, :options, :correct_option, :explanation, :_destroy]

  form do |f|
    f.semantic_errors

    f.inputs "Final Assessment" do
      f.input :course
      f.input :title
      f.input :instructions
    end

    f.has_many :assessment_questions, allow_destroy: true, new_record: true do |q_f|
      q_f.input :question_text
      q_f.input :options
      q_f.input :correct_option
      q_f.input :explanation
    end

    f.actions
  end
end
