# app/serializers/user_serializer.rb
class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :created_at, :updated_at
end
