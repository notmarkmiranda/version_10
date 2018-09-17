require 'rails_helper'

describe 'Visitor can log in', type: :feature do
  let(:user) { create(:user, password: 'password') }

  it 'redirects to dashboard after successful login' do
    visit '/users/sign_in'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    expect(current_path).to eq(dashboard_path)
  end
end
