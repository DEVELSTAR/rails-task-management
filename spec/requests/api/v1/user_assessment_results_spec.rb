require "rails_helper"

RSpec.describe Api::V1::UserAssessmentResultsController, type: :request do
  let!(:user) { create(:user) }
  let!(:course) { create(:course) }
  let!(:course_module) { create(:course_module, course: course) }
  let!(:lesson) { create(:lesson, course_module: course_module) }
  let!(:assessment) { create(:assessment, :with_questions_and_answers, assessable: lesson) }
  let!(:question1) { assessment.assessment_questions.first }
  let!(:correct_answer1) { question1.assessment_answers.find_by(is_correct: true) }
  let!(:wrong_answer1)   { question1.assessment_answers.find_by(is_correct: false) }
  let!(:enrollment) { create(:user_course_enrollment, user: user, course: course) }
  let(:headers) { auth_headers(user) }
  let!(:url) { "/api/v1/assessments/#{assessment.id}/submit" }


  describe "POST /api/v1/user_assessment_results/:id" do
    context "when user is enrolled and answers correctly" do
      it "creates a result and returns score" do
        post url, params: {
          answers: [
            { question_id: question1.id, answer_id: correct_answer1.id }
          ]
        }, headers: headers

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["score"]).to eq(50)
        expect(json["assessment_id"]).to eq(assessment.id)
        expect(user.user_assessment_results.count).to eq(1)
      end
    end

    context "when user answers incorrectly" do
      it "returns lower score" do
        post url, params: {
          answers: [
            { question_id: question1.id, answer_id: wrong_answer1.id }
          ]
        }, headers: headers

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["score"]).to eq(0)
      end
    end

    context "when user is not enrolled" do
      before { enrollment.destroy }

      it "returns forbidden" do
        post url, params: {
          answers: [
            { question_id: question1.id, answer_id: correct_answer1.id }
          ]
        }, headers: headers

        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)["error"]).to match(/not enrolled/)
      end
    end

    # context "when no answers provided" do
    #   it "returns unprocessable_content" do
    #     post url, params: { answers: [] }, headers: headers

    #     expect(response).to have_http_status(:unprocessable_content)
    #     expect(JSON.parse(response.body)["errors"]).to include("Answers are required")
    #   end
    # end

    context "when no questions in assessment" do
      before { assessment.assessment_questions.destroy_all }

      it "returns unprocessable_content" do
        post url, params: {
          answers: [
            { question_id: 999, answer_id: 999 }
          ]
        }, headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)["errors"]).to include("No questions found for this assessment")
      end
    end
  end
end
