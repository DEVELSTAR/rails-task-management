class CourseSerializer
  include Rails.application.routes.url_helpers

  def initialize(course)
    @course = course
  end

  def as_json(*)
    {
      id: @course.id,
      title: @course.title,
      description: @course.description,
      duration: @course.duration,
      price: @course.price,
      slug: @course.slug,
      status: @course.status,
      level: @course.level,
      language: @course.language,
      thumbnail: @course.thumbnail.attached? ? url_for(@course.thumbnail) : nil,
      course_modules: @course.course_modules.map do |mod|
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
                  image: content.image.attached? ? url_for(content.image) : nil,
                  video: content.video.attached? ? url_for(content.video) : nil
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
                    options: q.options,
                    correct_option: q.correct_option,
                    explanation: q.explanation
                  }
                end
              }
            }
          end
        }
      end,
      final_assessment: @course.final_assessment && {
        id: @course.final_assessment.id,
        title: @course.final_assessment.title,
        instructions: @course.final_assessment.instructions,
        assessment_questions: @course.final_assessment.assessment_questions.map do |q|
          {
            id: q.id,
            question_text: q.question_text,
            options: q.options,
            correct_option: q.correct_option,
            explanation: q.explanation
          }
        end
      }
    }
  end
end
