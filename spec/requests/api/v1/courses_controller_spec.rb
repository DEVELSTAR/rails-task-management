# spec/requests/api/v1/courses_controller_spec.rb
require "rails_helper"

RSpec.describe Api::V1::CoursesController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }
  let!(:courses) { create_list(:course, 2, :with_full_structure) }
  let(:course) { courses.first }

  describe "GET /api/v1/courses" do
    it "returns all courses with nested data" do
      get "/api/v1/courses", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json).to be_an(Array)
      expect(json.size).to eq(2)
      expect(json[0]['data']['attributes']['course_modules'][0]['title']).to be_present
      expect(json[0]['data']['attributes']['course_modules']).to be_present
      expect(json[0]['data']['attributes']["final_assessment"]).to be_present
    end
  end

  describe "GET /api/v1/courses/:id" do
    it "returns a single course with nested data" do
      get "/api/v1/courses/#{course.id}", headers: headers

      expect(response).to have_http_status(:ok)
      data = json["data"]["attributes"]
      expect(data["title"]).to eq(course.title)
      expect(data["course_modules"]).to be_present
    end
  end

  describe "POST /api/v1/courses" do
    let(:valid_params) do
      {
        course: attributes_for(:course).merge(
          course_modules_attributes: [
            attributes_for(:course_module).merge(
              lessons_attributes: [
                attributes_for(:lesson).merge(
                  lesson_contents_attributes: [attributes_for(:lesson_content)],
                  lesson_assessment_attributes: attributes_for(:assessment).merge(
                    assessment_questions_attributes: [
                      attributes_for(:assessment_question).merge(
                        assessment_answers_attributes: [attributes_for(:assessment_answer)]
                      )
                    ]
                  )
                )
              ]
            )
          ],
          final_assessment_attributes: attributes_for(:assessment).merge(
            assessment_questions_attributes: [
              attributes_for(:assessment_question).merge(
                assessment_answers_attributes: [attributes_for(:assessment_answer)]
              )
            ]
          )
        )
      }
    end

    it "creates a course with nested modules, lessons, and assessments" do
      expect {
        post "/api/v1/courses", params: valid_params, headers: headers
      }.to change(Course, :count).by(1)
        .and change(CourseModule, :count).by(1)
        .and change(Lesson, :count).by(1)
        .and change(Assessment, :count).by(2) # lesson_assessment + final_assessment

      expect(response).to have_http_status(:created)
      expect(json['data']['attributes']['title']).to eq(valid_params[:course][:title])
    end

    it "returns errors when invalid" do
      invalid_params = { course: { title: "" } }

      post "/api/v1/courses", params: invalid_params, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]).to be_present
    end
  end
end
