
# spec/requests/api/v1/users_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'POST /api/v1/register' do
    it 'creates a user with valid attributes' do
      expect {
        post '/api/v1/register', params: { user: { email: 'user@example.com', password: 'password' } }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include('user' => hash_including('email' => 'user@example.com'))
      expect(JSON.parse(response.body)).to have_key('token')
    end

    it 'returns errors for invalid attributes' do
      post '/api/v1/register', params: { user: { email: '', password: 'password' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include("Email can't be blank")
    end
  end

  describe 'POST /api/v1/login' do
    let!(:user) { create(:user, email: 'user@example.com', password: 'password') }

    it 'returns token for valid credentials' do
      post '/api/v1/login', params: { email: 'user@example.com', password: 'password' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('user' => hash_including('email' => 'user@example.com'))
      expect(JSON.parse(response.body)).to have_key('token')
    end

    it 'returns error for invalid credentials' do
      post '/api/v1/login', params: { email: 'user@example.com', password: 'wrong' }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to include('error' => 'Invalid email or password')
    end
  end
end
