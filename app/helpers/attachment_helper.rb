# app/serializers/attachment_helper.rb
module AttachmentHelper
  include Rails.application.routes.url_helpers

  def attachment_data(file, host:)
    return nil unless file.attached?

    {
      id: file.blob.id,
      host: host,
      url: Rails.application.routes.url_helpers.url_for(file),
      content_type: file.blob.content_type,
      filename: file.blob.filename.to_s
    }
  end
end
