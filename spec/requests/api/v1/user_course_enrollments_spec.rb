# spec/requests/api/v1/user_course_enrollments_spec.rb
require "rails_helper"

RSpec.describe Api::V1::UserCourseEnrollmentsController, type: :request do
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:headers) { auth_headers(user) }

  describe "GET /api/v1/user_course_enrollments" do
    let!(:enrollment) { create(:user_course_enrollment, user: user, course: course, progress: 50, status: :in_progress) }

    it "returns a list of enrollments with course data" do
      get "/api/v1/user_course_enrollments", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json).to be_an(Array)
      expect(json.first['course']['id']).to eq(course.id)
      expect(json.first['progress']).to eq(50)
      expect(json.first['status']).to eq("in_progress")
    end
  end

  describe "POST /api/v1/user_course_enrollments" do
    it "enrolls the user in a course" do
      post "/api/v1/courses/#{course.id}/enroll", params: { course_id: course.id }, headers: headers

      expect(response).to have_http_status(:created)
      expect(json['course_id']).to eq(course.id)
      expect(json['progress']).to eq(0)
      expect(json['status']).to eq("in_progress")
    end

    it "prevents duplicate enrollment" do
      create(:user_course_enrollment, user: user, course: course)
      post "/api/v1/courses/#{course.id}/enroll", params: { course_id: course.id }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(json['message']).to eq("You are already enrolled in this course!")
    end
  end

  describe "GET /api/v1/user_course_enrollments/:id" do
    let!(:enrollment) { create(:user_course_enrollment, user: user, course: course, progress: 20) }

    it "returns enrollment details with modules and progress" do
      get "/api/v1/courses/#{course.id}/progress", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json['course']['id']).to eq(course.id)
      expect(json['progress']).to eq(20)
      expect(json['status']).to eq("completed")
      expect(json['modules']).to be_an(Array)
    end

    it "returns 404 if user is not enrolled" do
      other_course = create(:course)
      get "/api/v1/courses/#{other_course.id}/progress", headers: headers

      expect(response).to have_http_status(:not_found)
      expect(json['error']).to eq("You are not enrolled in this course")
    end
  end

  describe "DELETE /api/v1/user_course_enrollments/:id" do
    let!(:enrollment) { create(:user_course_enrollment, user: user, course: course) }

    it "unenrolls the user without resetting progress" do
      delete "/api/v1/user_course_enrollments/#{course.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json['message']).to eq("Unenrolled successfully.")
      expect(UserCourseEnrollment.exists?(enrollment.id)).to be_falsey
    end

    it "unenrolls the user and resets progress" do
      delete "/api/v1/user_course_enrollments/#{course.id}", params: { reset_progress: "true" }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(json['message']).to eq("Unenrolled successfully and progress reset.")
      expect(UserCourseEnrollment.exists?(enrollment.id)).to be_falsey
    end
  end
end
