# spec/requests/api/v1/tasks_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :request do
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
  let(:parsed_response) { JSON.parse(response.body) }

  describe 'GET /api/v1/tasks' do
    it 'returns all tasks' do
      FactoryBot.create(:task, title: 'Task 1')
      FactoryBot.create(:task, title: 'Task 2')

      get '/api/v1/tasks'
      expect(response).to have_http_status(:ok)
      expect(parsed_response.size).to eq(2)
      expect(parsed_response.first).to include('title' => 'Task 1')
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    let(:task) { FactoryBot.create(:task) }

    it 'returns a task' do
      get "/api/v1/tasks/#{task.id}"
      expect(response).to have_http_status(:ok)
      expect(parsed_response).to include('title' => task.title)
    end

    it 'returns 404 for non-existent task' do
      get '/api/v1/tasks/999'
      expect(response).to have_http_status(:not_found)
      expect(parsed_response).to include('error' => 'Task not found')
    end
  end

  describe 'POST /api/v1/tasks' do
    it 'creates a task with valid attributes' do
      expect {
        post '/api/v1/tasks', params: valid_attributes
      }.to change(Task, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(parsed_response).to include('title' => 'Test Task')
    end

    it 'returns errors for invalid attributes' do
      post '/api/v1/tasks', params: invalid_attributes
      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_response['errors']).to include("Title can't be blank")
    end
  end

  describe 'PATCH /api/v1/tasks/:id' do
    let(:task) { FactoryBot.create(:task) }

    it 'updates a task with valid attributes' do
      patch "/api/v1/tasks/#{task.id}", params: { task: { title: 'Updated Task' } }
      expect(response).to have_http_status(:ok)
      expect(parsed_response).to include('title' => 'Updated Task')
      expect(task.reload.title).to eq('Updated Task')
    end

    it 'returns errors for invalid attributes' do
      patch "/api/v1/tasks/#{task.id}", params: invalid_attributes
      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_response['errors']).to include("Title can't be blank")
    end

    it 'returns 404 for non-existent task' do
      patch '/api/v1/tasks/999', params: valid_attributes
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v1/tasks/:id' do
    let(:task) { FactoryBot.create(:task) }

    it 'deletes a task' do
      delete "/api/v1/tasks/#{task.id}"
      expect(response).to have_http_status(:ok)
      expect(Task.exists?(task.id)).to be_falsey
    end

    it 'returns 404 for non-existent task' do
      delete '/api/v1/tasks/999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v1/tasks/bulk_destroy' do
    let!(:task1) { FactoryBot.create(:task) }
    let!(:task2) { FactoryBot.create(:task) }

    it 'deletes multiple tasks' do
      expect {
        delete '/api/v1/tasks/bulk_destroy', params: { task_ids: [task1.id, task2.id] }
      }.to change(Task, :count).by(-2)

      expect(response).to have_http_status(:ok)
      expect(parsed_response).to include('message' => '2 tasks deleted successfully')
    end

    it 'returns errors for non-existent task IDs' do
      delete '/api/v1/tasks/bulk_destroy', params: { task_ids: [task1.id, 999] }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_response['errors'][0]).to include('Tasks with IDs 999 not found')
    end

    it 'returns errors for empty task IDs' do
      delete '/api/v1/tasks/bulk_destroy', params: { task_ids: [] }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_response['errors'][0]).to include("Tasks with IDs  not found")
    end
  end

  describe 'GET /api/v1/tasks/search' do
    let!(:task1) { FactoryBot.create(:task, title: 'Project Task', status: 'todo', due_date: '2025-07-15') }
    let!(:task2) { FactoryBot.create(:task, title: 'Other Task', status: 'done', due_date: '2025-08-01') }

    it 'filters tasks by status' do
      get '/api/v1/tasks/search', params: { status: 'todo' }
      expect(response).to have_http_status(:ok)
      expect(parsed_response.size).to eq(1)
      expect(parsed_response.first).to include('title' => 'Project Task')
    end

    it 'filters tasks by title' do
      get '/api/v1/tasks/search', params: { title: 'Project' }
      expect(response).to have_http_status(:ok)
      expect(parsed_response.size).to eq(1)
      expect(parsed_response.first).to include('title' => 'Project Task')
    end

    it 'filters tasks by date range' do
      get '/api/v1/tasks/search', params: { start_date: '2025-07-01', end_date: '2025-07-31' }
      expect(response).to have_http_status(:ok)
      expect(parsed_response.size).to eq(1)
      expect(parsed_response.first).to include('title' => 'Project Task')
    end

    it 'returns empty array when no tasks match' do
      get '/api/v1/tasks/search', params: { status: 'in_progress' }
      expect(response).to have_http_status(:ok)
      expect(parsed_response).to eq([])
    end
  end
end
