# app/serializers/application_serializer.rb
class ApplicationSerializer
  include JSONAPI::Serializer
  include Rails.application.routes.url_helpers
  include AttachmentHelper
end
