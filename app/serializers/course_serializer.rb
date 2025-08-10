# app/serializers/course_serializer.rb
class CourseSerializer < ApplicationSerializer
  attributes :title, :description, :duration, :price, :slug, :status, :level, :language

  attribute :thumbnail do |course, params|
    host = params[:host] || Rails.application.routes.default_url_options[:host]
    AttachmentHelper.instance_method(:attachment_data).bind(self).call(course.thumbnail, host: host)
  end

  attribute :course_modules do |course, params|
    host = params[:host] || Rails.application.routes.default_url_options[:host]

    course.course_modules.map do |mod|
      {
        id: mod.id,
        title: mod.title,
        description: mod.description,
        position: mod.position,
        lessons: mod.lessons.map do |lesson|
          {
            id: lesson.id,
            title: lesson.title,
            description: lesson.description,
            position: lesson.position,
            lesson_contents: lesson.lesson_contents.map do |content|
              {
                id: content.id,
                content_type: content.content_type,
                position: content.position,
                content_data: content.content_data,
                image: AttachmentHelper.instance_method(:attachment_data).bind(self).call(content.image, host: host),
                video: AttachmentHelper.instance_method(:attachment_data).bind(self).call(content.video, host: host)
              }
            end,
            lesson_assessment: lesson.lesson_assessment && {
              id: lesson.lesson_assessment.id,
              title: lesson.lesson_assessment.title,
              instructions: lesson.lesson_assessment.instructions,
              assessment_questions: lesson.lesson_assessment.assessment_questions.map do |q|
                {
                  id: q.id,
                  question_text: q.question_text,
                  explanation: q.explanation,
                  assessment_answers: q.assessment_answers.map do |a|
                    {
                      id: a.id,
                      answer_text: a.answer_text,
                      is_correct: a.is_correct
                    }
                  end
                }
              end
            }
          }
        end
      }
    end
  end

  attribute :final_assessment do |course|
    course.final_assessment && {
      id: course.final_assessment.id,
      title: course.final_assessment.title,
      instructions: course.final_assessment.instructions,
      assessment_questions: course.final_assessment.assessment_questions.map do |q|
        {
          id: q.id,
          question_text: q.question_text,
          explanation: q.explanation,
          assessment_answers: q.assessment_answers.map do |a|
            {
              id: a.id,
              answer_text: a.answer_text,
              is_correct: a.is_correct
            }
          end
        }
      end
    }
  end
end
