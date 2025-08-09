class UserSerializer < ApplicationSerializer
  attributes :email

  attribute :profile do |user, params|
    if user.profile
      {
        id: user.profile.id,
        name: user.profile.name,
        bio: user.profile.bio,
        avatar: AttachmentHelper.instance_method(:attachment_data).bind(self).call(user.profile&.avatar, host: params[:host] || Rails.application.routes.default_url_options[:host])
      }
    end
  end

  attribute :addresses do |user|
    user.addresses.map do |a|
      {
        id: a.id,
        line1: a.line1,
        line2: a.line2,
        city: a.city,
        state: a.state,
        country: a.country,
        zip: a.zip
      }
    end
  end
end
