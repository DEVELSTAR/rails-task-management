# spec/support/admin_login_helper.rb
module AdminLoginHelper
  def login_as_admin(admin_user)
    visit admin_login_path
    expect(page).to have_field('Email')
    fill_in 'Email', with: admin_user.email
    fill_in 'Password', with: 'password'
    click_button 'Login'
    expect(page).to have_content("Dashboard") # confirm login
  end
end
