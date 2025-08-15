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

  def login_as_admin(admin_user)
    visit '/admin/login'
    fill_in 'Email', with: admin_user.email
    fill_in 'Password', with: 'password'
    click_button 'Login'
    expect(page).to have_content("Dashboard") # confirm login
  end
end
