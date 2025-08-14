# spec/support/request_helpers.rb
module RequestHelpers
  def auth_headers(user)
    token = Api::V1::JwtService.encode(user_id: user.id)
    {
      "token" => token,
      "Accept"        => "application/json"
    }
  end

  def json
    JSON.parse(response.body)
  end
end
