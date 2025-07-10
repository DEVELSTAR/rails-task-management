FactoryBot.define do
  factory :task do
    title { 'Test Task' }
    description { 'Test Description' }
    status { 'todo' }
    due_date { '2025-07-15' }
  end
end
