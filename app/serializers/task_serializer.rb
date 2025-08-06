class TaskSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :description, :status, :due_date, :created_at, :updated_at
end
