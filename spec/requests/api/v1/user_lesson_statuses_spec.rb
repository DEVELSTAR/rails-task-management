# spec/requests/api/v1/user_lesson_statuses_spec.rb
require "rails_helper"

RSpec.describe Api::V1::UserLessonStatusesController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }
  let(:course) { create(:course) }
  let(:course_module) { create(:course_module, course: course) }
  let(:lesson) { create(:lesson, course_module: course_module) }

  describe "PATCH /api/v1/user_lesson_statuses/:id" do
    context "when the user is enrolled" do
      let!(:enrollment) { create(:user_course_enrollment, user: user, course: course) }

      it "creates a new user_lesson_status if it doesn't exist" do
        put "/api/v1/lessons/#{lesson.id}/status",
              params: { status: "completed" },
              headers: headers

        expect(response).to have_http_status(:ok)
        expect(json["lesson_id"]).to eq(lesson.id)
        expect(json["status"]).to eq("completed")
        expect(user.user_lesson_statuses.count).to eq(1)
      end

      it "updates an existing user_lesson_status" do
        create(:user_lesson_status, user: user, lesson: lesson, status: "in_progress")

        put "/api/v1/lessons/#{lesson.id}/status",
              params: { status: "completed" },
              headers: headers

        expect(response).to have_http_status(:ok)
        expect(json["status"]).to eq("completed")
      end

      it "returns errors if status is invalid" do
        put "/api/v1/lessons/#{lesson.id}/status",
              params: { status: "not_a_status" },
              headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        expect(json["errors"]).to be_an(Array)
      end
    end

    context "when the user is not enrolled in the course" do
      it "returns forbidden status" do
        put "/api/v1/lessons/#{lesson.id}/status",
              params: { status: "completed" },
              headers: headers

        expect(response).to have_http_status(:forbidden)
        expect(json["error"]).to eq("You are not enrolled in this course")
      end
    end
  end
end
