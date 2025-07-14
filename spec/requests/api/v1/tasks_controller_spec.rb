# spec/requests/api/v1/tasks_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :request do
  let(:user) { create(:user) }
  let(:token) { Api::V1::JwtService.encode(user_id: user.id) }
  let(:headers) { { 'token' => token } }

  let(:valid_attributes) do
    {
      task: {
        title: 'Test Task',
        description: 'Test Description',
        status: 'todo',
        due_date: '2025-07-15'
      }
    }
  end

  let(:invalid_attributes) do
    { task: { title: '' } }
  end

  describe 'GET /api/v1/tasks' do
    it 'returns all tasks for authenticated user' do
      create(:task, user: user, title: 'Task 1')
      create(:task, user: create(:user), title: 'Task 2') # Different user

      get '/api/v1/tasks', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
      expect(JSON.parse(response.body).first).to include('title' => 'Task 1')
    end

    it 'returns unauthorized without token' do
      get '/api/v1/tasks'
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to include('error' => 'Unauthorized')
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    let(:task) { create(:task, user: user) }

    it 'returns a task' do
      get "/api/v1/tasks/#{task.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('title' => task.title)
    end

    it 'returns 404 for non-existent task' do
      get '/api/v1/tasks/999', headers: headers
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to include('error' => 'Task not found')
    end
  end

  describe 'POST /api/v1/tasks' do
    it 'creates a task with valid attributes' do
      expect {
        post '/api/v1/tasks', params: valid_attributes, headers: headers
      }.to change { user.tasks.count }.by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include('title' => 'Test Task')
    end

    it 'returns errors for invalid attributes' do
      post '/api/v1/tasks', params: invalid_attributes, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include("Title can't be blank")
    end
  end

  describe 'PATCH /api/v1/tasks/:id' do
    let(:task) { create(:task, user: user) }

    it 'updates a task with valid attributes' do
      patch "/api/v1/tasks/#{task.id}", params: { task: { title: 'Updated Task' } }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('title' => 'Updated Task')
      expect(task.reload.title).to eq('Updated Task')
    end

    it 'returns errors for invalid attributes' do
      patch "/api/v1/tasks/#{task.id}", params: invalid_attributes, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include("Title can't be blank")
    end

    it 'returns 404 for non-existent task' do
      patch '/api/v1/tasks/999', params: valid_attributes, headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v1/tasks/:id' do
    let(:task) { create(:task, user: user) }

    it 'deletes a task' do
      delete "/api/v1/tasks/#{task.id}", headers: headers
      expect(response).to have_http_status(:no_content)
      expect(Task.exists?(task.id)).to be_falsey
    end

    it 'returns 404 for non-existent task' do
      delete '/api/v1/tasks/999', headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v1/tasks/bulk_destroy' do
    let!(:task1) { create(:task, user: user) }
    let!(:task2) { create(:task, user: user) }

    it 'deletes multiple tasks' do
      expect {
        delete '/api/v1/tasks/bulk_destroy', params: { task_ids: [task1.id, task2.id] }, headers: headers
      }.to change { user.tasks.count }.by(-2)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('message' => '2 tasks deleted successfully')
    end

    it 'returns errors for non-existent task IDs' do
      delete '/api/v1/tasks/bulk_destroy', params: { task_ids: [task1.id, 999] }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include('Tasks with IDs 999 not found')
      expect(Task.exists?(task1.id)).to be_truthy
    end

    it 'returns errors for empty task IDs' do
      delete '/api/v1/tasks/bulk_destroy', params: { task_ids: [] }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include("Tasks with IDs  not found")
    end
  end

  describe 'GET /api/v1/tasks/search' do
    let!(:task1) { create(:task, user: user, title: 'Project Task', status: 'todo', due_date: '2025-07-15') }
    let!(:task2) { create(:task, user: user, title: 'Other Task', status: 'done', due_date: '2025-08-01') }

    it 'filters tasks by status' do
      get '/api/v1/tasks/search', params: { status: 'todo' }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
      expect(JSON.parse(response.body).first).to include('title' => 'Project Task')
    end

    it 'filters tasks by title' do
      get '/api/v1/tasks/search', params: { title: 'Project' }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
      expect(JSON.parse(response.body).first).to include('title' => 'Project Task')
    end

    it 'filters tasks by date range' do
      get '/api/v1/tasks/search', params: { start_date: '2025-07-01', end_date: '2025-07-31' }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
      expect(JSON.parse(response.body).first).to include('title' => 'Project Task')
    end

    it 'returns empty array when no tasks match' do
      get '/api/v1/tasks/search', params: { status: 'in_progress' }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end
  end
end
