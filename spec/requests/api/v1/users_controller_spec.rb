# spec/requests/api/v1/users_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  def json
    JSON.parse(response.body)
  end

  describe 'GET /api/v1/users' do
    let!(:users) { create_list(:user, 3) }

    it 'returns paginated users' do
      get '/api/v1/users'
      expect(response).to have_http_status(:ok)
      expect(json['data'].size).to eq(3)
      expect(json['data'][0]['attributes']).to have_key('email')
      expect(json['meta']).to include('total_count' => 3)
    end
  end

  describe 'GET /api/v1/users/:id' do
    let!(:user) { create(:user, email: 'showme@example.com') }

    it 'returns a user' do
      get "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(:ok)
      expect(json['data']['attributes']['email']).to eq('showme@example.com')
    end

    it 'returns 404 for non-existent user' do
      get '/api/v1/users/999'
      expect(response).to have_http_status(:not_found)
      expect(json['error']).to eq('User not found')
    end
  end

  describe 'POST /api/v1/users/register' do
    it 'creates a user with valid attributes' do
      expect {
        post '/api/v1/users/register', params: { user: { email: 'user@example.com', password: 'password' } }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json['data']['attributes']).to include('email' => 'user@example.com')
      expect(json).to have_key('token')
    end

    it 'returns errors for invalid attributes' do
      post '/api/v1/users/register', params: { user: { email: '', password: 'password' } }
      expect(response).to have_http_status(:unprocessable_content)
      expect(json['errors']).to include("Email can't be blank")
    end
  end

  describe 'POST /api/v1/users/login' do
    let!(:user) { create(:user, email: 'user@example.com', password: 'password') }

    it 'returns token for valid credentials' do
      post '/api/v1/users/login', params: { email: 'user@example.com', password: 'password' }
      expect(response).to have_http_status(:ok)
      expect(json['data']['attributes']['email']).to eq('user@example.com')
      expect(json).to have_key('token')
    end

    it 'returns error for invalid credentials' do
      post '/api/v1/users/login', params: { email: 'user@example.com', password: 'wrong' }
      expect(response).to have_http_status(:unauthorized)
      expect(json['error']).to eq('Invalid email or password')
    end
  end
end
