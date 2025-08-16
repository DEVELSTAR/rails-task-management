require "rails_helper"

RSpec.describe "Api::V1::Notifications", type: :request do
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let!(:notification1) { create(:notification, user: user, course: course, created_at: 2.days.ago, message: "a") }
  let!(:notification2) { create(:notification, user: user, course: course, created_at: 1.day.ago, read_at: nil, message: "b") }
  let(:headers) { auth_headers(user) }

  describe "GET /api/v1/notifications" do
    it "returns a list of notifications for the current user" do
      get "/api/v1/notifications", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(2)
      expect(json.first).to include("id" => notification2.id, "message" => notification2.message)
    end
  end

  describe "GET /api/v1/notifications/unread" do
    it "returns only unread notifications" do
      get "/api/v1/notifications/unread", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(2)
      expect(json.first["id"]).to eq(notification2.id)
    end
  end

  describe "PATCH /api/v1/notifications/:id/mark_as_read" do
    it "marks a notification as read" do
      patch "/api/v1/notifications/#{notification2.id}/mark_as_read", headers: headers

      expect(response).to have_http_status(:ok)
      notification2.reload
      expect(notification2.read?).to be true
    end
  end

  describe "PATCH /api/v1/notifications/:id/mark_as_unread" do
    it "marks a notification as unread" do
      notification1.update!(read_at: Time.current)

      patch "/api/v1/notifications/#{notification1.id}/mark_as_unread", headers: headers

      expect(response).to have_http_status(:ok)
      notification1.reload
      expect(notification1.read?).to be false
    end
  end

  describe "DELETE /api/v1/notifications/:id" do
    it "deletes a notification" do
      expect {
        delete "/api/v1/notifications/#{notification1.id}", headers: headers
      }.to change(Notification, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect(json["message"]).to eq("Notification deleted successfully.")
    end
  end

  describe "error handling" do
    it "returns 404 if notification not found" do
      delete "/api/v1/notifications/999999", headers: headers

      expect(response).to have_http_status(:not_found)
      expect(json["error"]).to eq("Notification not found")
    end
  end
end
